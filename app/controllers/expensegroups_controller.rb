class ExpensegroupsController < ApplicationController
  
  require_role :admin

  # GET /expensegroups
  # GET /expensegroups.xml
  def index
    @expensegroups = Expensegroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expensegroups }
    end
  end

  # GET /expensegroups/1
  # GET /expensegroups/1.xml
  def show
    @expensegroup = Expensegroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expensegroup }
    end
  end

  # GET /expensegroups/new
  # GET /expensegroups/new.xml
  def new
    @expensegroup = Expensegroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @expensegroup }
    end
  end

  # GET /expensegroups/1/edit
  def edit
    @expensegroup = Expensegroup.find(params[:id])
  end

  # POST /expensegroups
  # POST /expensegroups.xml
  def create
    @expensegroup = Expensegroup.new(params[:expensegroup])

    respond_to do |format|
      if @expensegroup.save
        flash[:notice] = 'Expensegroup was successfully created.'
        format.html { redirect_to(@expensegroup) }
        format.xml  { render :xml => @expensegroup, :status => :created, :location => @expensegroup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @expensegroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /expensegroups/1
  # PUT /expensegroups/1.xml
  def update
    @expensegroup = Expensegroup.find(params[:id])

    respond_to do |format|
      if @expensegroup.update_attributes(params[:expensegroup])
        flash[:notice] = 'Expensegroup was successfully updated.'
        format.html { redirect_to(@expensegroup) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expensegroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /expensegroups/1
  # DELETE /expensegroups/1.xml
  def destroy
    @expensegroup = Expensegroup.find(params[:id])
    @expensegroup.destroy

    respond_to do |format|
      format.html { redirect_to(expensegroups_url) }
      format.xml  { head :ok }
    end
  end
end
