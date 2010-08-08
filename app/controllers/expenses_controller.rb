include ApplicationHelper

class ExpensesController < ApplicationController

  before_filter :login_required
  require_role :admin, :for => [:edit,:update,:destroy], :unless => "current_user.is_owner?(params[:id],Expense)"
  sortable_table Expense   
  
  # GET /expenses
  # GET /expenses.xml
  def index                        
     @user = User.find session[:user_id]    
     @expense = Expense.new :reference_date => Date.today  
     build_table @user,params
     
     respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @expenses }
       format.csv {
         response = FasterCSV.generate do |csv| 
           csv << ["Creation date", "Reference date", "Category", "Group", 
                   'User', "Description", "Amount"]
           Expense.all.each do |e|
             csv << [ e.created_at, e.reference_date, e.category, e.creator.login, 
                      e.description, e.amount ]
           end
         end
         send_data response,
                   :type => 'text/csv; charset=iso-8859-1; header=present',
                   :disposition => "attachment; filename=users.csv"
       }
     end
  end
  
  # GET /expenses/1
  # GET /expenses/1.xml
  def show
    @expense = Expense.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.xml
  def new
    @expense = Expense.new :creator=>current_user
    @expense.reference_date = DateTime.now
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])     
    @users_expense = []
    @expense.users.each do |user|
        @users_expense.push({:title => name_or_login(user), :value => user.id})
    end  
    @users_expense = @users_expense.to_json
  end

  # POST /expenses
  # POST /expenses.xml
  def create
    user = current_user
    if not user.has_role? :admin or not params[:expense][:creator_id]
      params[:expense][:creator_id] = user.id
    end 
    expense_data = params[:expense]
    if not expense_data.include? :users
      expense_data[:users] = []
    end
    expense_data[:user_ids] = Set.new(expense_data[:users].each{|id| id.to_i})
    if not expense_data[:user_ids].include? params[:expense][:creator_id]
      expense_data[:user_ids].add(params[:expense][:creator_id])
    end
    expense_data.delete :users
    @expense = Expense.new(expense_data)
    
    respond_to do |format|
      if @expense.save
        flash[:notice] = 'Expense was successfully created.'
        format.html { redirect_to(:action=>'index') }
        format.xml  { render :xml => @expense, :status => :created, :location => @expense }
        format.js { build_table User.find session[:user_id] }
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

  # PUT /expenses/1
  # PUT /expenses/1.xml
  def update
    @expense = Expense.find(params[:id])

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        flash[:notice] = 'Expense was successfully updated.'
        format.html { redirect_to(@expense) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.xml
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to(expenses_url) }
      format.xml  { head :ok }
    end
  end
  
  def calculate_total_for(expense_list)
    user = current_user
    personal = 0
    shared = 0
    amounts = []
    for expense in expense_list
      if expense.users == [ user ]
        personal += expense.amount
      elsif true #expense.status == 'approved'
        shared += expense.amount / expense.users.length
      end
    end
    total = shared + personal
    return { :personal => personal, :shared => shared, :total => total }
  end
  
  def users_autocomplete
    @response = []
    for user in User.find :all
      @response.push({:caption => name_or_login(user), :value => user.id})
    end
    respond_to do |format|
      format.js { render :json => @response.to_json() }
    end
  end     

  def users_and_groups_autocomplete
    @response = []
    for user in User.find :all
      @response.push({:caption => name_or_login(user), :value => "user:%s" % user.id})
    end    
    
    for group in Expensegroup.find :all
      @response.push({:caption => group.name, :value => "expensegroup:%s" % group.id})
    end
    respond_to do |format|
      format.js { render :json => @response.to_json() }
    end
  end

  def group_users
      @response = []     
      if params[:group_id]  
        expensegroup = Expensegroup.find(params[:group_id])     
    
        for user in expensegroup.users
          @response.push({:title => name_or_login(user), :value => "user:%s" % user.id})
        end  
      end
       
      respond_to do |format|
        format.js { render :json => @response.to_json() }
      end
  end

  def groups_autocomplete
        @response = []
        for group in Expensegroup.find :all
          @response.push({:caption => group.name, :value => group.id})
        end
        respond_to do |format|
          format.js { render :json => @response.to_json() }
        end
    end

end   

def build_table(user,p = params)
  options = {
    :table_headings => [['Reference date', 'formatted_reference_date'],
                       ['Description', 'description'], 
                       ['Creator','creator.login'],
                       ['Amount', 'amount']], 
    :sort_map =>  {'formatted_reference_date' => ['expenses.reference_date'], 
                  'description' => ['expenses.description'],
                  'amount' => ['expenses.amount'],
                  'creator.login' => ['expenses.creator_id']},
    :include_relations => [:creator, :users] , 
    :per_page => 15,
    :conditions => ['expenses_users.user_id == ? and expenses_users.expense_id = expenses.id', user.id ], 
    :default_sort => ['formatted_reference_date', 'DESC']
  }
  get_sorted_objects(p,options)
end 