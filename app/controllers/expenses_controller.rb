class ExpensesController < ApplicationController

  require_role :user
  require_role :admin, :for => [:edit,:update,:destroy], :unless => "current_user.is_owner?(params[:id],Expense)"
  
  # GET /expenses
  # GET /expenses.xml
  def index
    @user = User.find session[:user_id]
    @expensegroups = @user.expensegroups
    
    if params[:limit]
      @limit = params[:limit]
    else
      @limit = 30
    end
    
    #query = []
    #params = {}
    #query.push "expensegroup_id in :expensegroup_ids"
    #params[:expensegroup_ids] = @expensegroups.collect {|p| p.id }
    
    #@posts = Post.paginate_by_board_id @board.id, :page => params[:page], :order => 'updated_at DESC'
    
    
    @expenses = Expense.paginate :all, :page => params[:page], :conditions => { :expensegroup_id => @expensegroups }, :order=>'reference_date DESC'
    @totals = calculate_total_for Expense.all :conditions => [ "reference_date > :last_month and expensegroup_id in (:expensegroup_ids)" , { :last_month => 1.month.ago, :expensegroup_ids => @expensegroups} ]
    
    # This is just for the ajax form
    @expense = Expense.new :reference_date => Date.today
 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expenses }
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
  end

  # POST /expenses
  # POST /expenses.xml
  def create
    user = current_user
    if not user.has_role? :admin or not params[:expense][:creator_id]
      params[:expense][:creator_id] = user.id
    end 
    @expense = Expense.new(params[:expense])
    
    respond_to do |format|
      if @expense.save
        flash[:notice] = 'Expense was successfully created.'
        format.html { redirect_to(:action=>'index') }
        format.xml  { render :xml => @expense, :status => :created, :location => @expense }
        format.js { 
            render :update do |page|
              page[:new_expense].reset
              page[:notice].visual_effect :highlight
              flash.discard
              response = render :partial=>"expense_line", :locals=>{:object=>@expense}
              page.insert_html :top, :expense_list_table, response  
              #here add the line
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
    user = User.find session[:user_id]
    personal = 0
    shared = 0
    amounts = []
    for expense in expense_list
      if expense.expensegroup.personal == user
        personal += expense.amount
      elsif true #expense.status == 'approved'
        shared += expense.amount / expense.expensegroup.users.length
      end
       
    end
    total = shared + personal
    return { :personal => personal, :shared => shared, :total => total }
  end
end
