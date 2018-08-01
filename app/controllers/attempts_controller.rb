class AttemptsController < ApplicationController
  before_action :set_attempt, only: [:show, :edit, :update, :destroy]

  def showques
    q = Attempt.where(:uid => session[:user_id], :state => 0)
    if q.present?
      ques = Question.find_by(id: q[0].qid)
      ques.correctoption = ""
    else
      if Attempt.where(:uid => session[:user_id]).reverse.present?
        x = Attempt.where(:uid => session[:user_id]).reverse
        s = Question.find_by(:id => x[0].qid)
        z = Question.where(:subgenre => s.subgenre).length
        a = Attempt.where(:uid => session[:user_id]).reverse
        arr = Array.new
        for i in 0..z-1
          w = Array.new
          w << i << a[i].success
          arr << w
        end
        print arr
        ques = {array: arr}
      end
    end
    render json: ques
  end

  def check
    # print params
    ques = Question.find(params[:quizid])
    a = Attempt.find_by(:uid => session[:user_id], :state => 0, :qid => params[:quizid])
    if ques.correctoption.eql? params[:quizanswer]
      abc = Score.find_by(uid: session[:user_id], state: 0)
      xy = abc.sid
      za = abc.score
      we = abc.lifeone
      wq = abc.lifetwo
      abc.update({"uid" => session[:user_id], "sid" => xy, "state" => 0, "score" => za+10, "lifeone" => we, "lifetwo" => wq})
      a.update({"uid" => session[:user_id], "qid" => params[:quizid], "state" => 1, "success" => 1})
    else
      a.update({"uid" => session[:user_id], "qid" => params[:quizid], "state" => 1, "success" => 0})
    end
  end

  # GET /attempts
  # GET /attempts.json
  def index
    if session[:user_id] and  User.find_by(id: session[:user_id]).name == "admin"
      @attempts = Attempt.all  
    elsif session[:user_id]
    #  @users = User.all
      redirect_to quiz_url
    else
      redirect_to login_url
    end
    
  end

  # GET /attempts/1
  # GET /attempts/1.json
  def show
  end

  # GET /attempts/new
  def new
    @attempt = Attempt.new
  end

  # GET /attempts/1/edit
  def edit
  end

  # POST /attempts
  # POST /attempts.json
  def create
    @attempt = Attempt.new(attempt_params)

    respond_to do |format|
      if @attempt.save
        format.html { redirect_to @attempt, notice: 'Attempt was successfully created.' }
        format.json { render :show, status: :created, location: @attempt }
      else
        format.html { render :new }
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attempts/1
  # PATCH/PUT /attempts/1.json
  def update
    respond_to do |format|
      if @attempt.update(attempt_params)
        format.html { redirect_to @attempt, notice: 'Attempt was successfully updated.' }
        format.json { render :show, status: :ok, location: @attempt }
      else
        format.html { render :edit }
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attempts/1
  # DELETE /attempts/1.json
  def destroy
    @attempt.destroy
    respond_to do |format|
      format.html { redirect_to attempts_url, notice: 'Attempt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt
      @attempt = Attempt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attempt_params
      params.require(:attempt).permit(:uid, :qid, :success, :state)
    end
end
