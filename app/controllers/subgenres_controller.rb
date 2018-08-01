class SubgenresController < ApplicationController
  before_action :set_subgenre, only: [:show, :edit, :update, :destroy]

  # GET /subgenres
  # GET /subgenres.json
  def index
    if session[:user_id] and  User.find_by(id: session[:user_id]).name == "admin"
      @subgenres = Subgenre.all
    elsif session[:user_id]
    #  @users = User.all
      redirect_to quiz_url
    else
      redirect_to login_url
    end  
  end

  # GET /subgenres/1
  # GET /subgenres/1.json
  def show
  end

  # GET /subgenres/new
  def new
    if session[:user_id] and  User.find_by(id: session[:user_id]).name == "admin"
      @subgenre = Subgenre.new
    elsif session[:user_id]
    #  @users = User.all
      redirect_to quiz_url
    else
      redirect_to login_url
    end  
  end

  # GET /subgenres/1/edit
  def edit
  end

  # POST /subgenres
  # POST /subgenres.json
  def create
    print "\n\n"
    print subgenre_params
    print "\n\n"  
    @subgenre = Subgenre.new(subgenre_params)

    respond_to do |format|
      if @subgenre.save
        format.html { redirect_to @subgenre, notice: 'Subgenre was successfully created.' }
        format.json { render :show, status: :created, location: @subgenre }
      else
        format.html { render :new }
        format.json { render json: @subgenre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subgenres/1
  # PATCH/PUT /subgenres/1.json
  def update
    respond_to do |format|
      if @subgenre.update(subgenre_params)
        format.html { redirect_to @subgenre, notice: 'Subgenre was successfully updated.' }
        format.json { render :show, status: :ok, location: @subgenre }
      else
        format.html { render :edit }
        format.json { render json: @subgenre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subgenres/1
  # DELETE /subgenres/1.json
  def destroy
    if session[:user_id] and User.find_by(id: session[:user_id]).name == "admin"
      subgenre = Subgenre.find_by(id: params[:id])
      Question.where(subgenre: subgenre.name).destroy_all
      @subgenre.destroy
      respond_to do |format|
        format.html { redirect_to subgenres_url, notice: 'Subgenre was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to login_url, notice: "Please login as admin"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subgenre
      @subgenre = Subgenre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subgenre_params
      params.require(:subgenre).permit(:name, :genrename)
    end
end
