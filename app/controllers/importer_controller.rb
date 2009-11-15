require 'csv'

class ImporterController < ApplicationController
  
  require_role :user
  
  def index
    # this is just to upload the file
  end
  
  def import
    @parsed_file=CSV::Reader.parse(params[:import][:file].read, ';')
    @imported_lines = []
    skip_lines = 0
    for line in @parsed_file
      amount = line[3]
      reference_date = Time.parse line[0]
      notes = line[7]
      expense = Expense.new (:creator => current_user,
                            :reference_date => reference_date,
                            :amount  => amount,
                            :description => notes )
      if expense.amount and expense.amount < 0
        @imported_lines.push expense
      end
    end
  end
  
  def import_expense
    params[:expense][:creator_id] = current_user.id
    form_id = params[:expense][:form_id]
    params[:expense].delete :form_id
    @expense = Expense.new(params[:expense])
    
    respond_to do |format|
      if @expense.save
        format.js { 
            render :update do |page|
              response = render :partial=>"expenses/expense_line", :locals=>{:object=>@expense}
              page.replace_html form_id, "" #response
            end
          }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
        format.js { 
            render :update do |page|
              bad_attributes = @expense.errors.each{ |attr, msg| attr }
              for attribute in [ 'description', 'reference_date', 'amount' ]
                if bad_attributes.include? attribute
                  page["expense_#{attribute}"].visual_effect :highlight
                end
              end
            end
          }
      end
    end # end respond_to
  end
  
end
