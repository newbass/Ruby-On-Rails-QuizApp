class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def fromsub
    wq = Subgenre.find_by(id: params[:sid]).genrename
    if wq != Genre.find_by(id: params[:gid]).name
      render json: {no: "null"}
    else
      a = Subgenre.find_by(id: params[:sid]).name
      q = Question.where(:subgenre => a)

      if Score.where(uid: session[:user_id], state: 0).present?
        abc = Score.where(uid: session[:user_id], state: 0)
        abc.each do |i|
          xy = i.sid
          za = i.score
          we = i.lifeone
          wq = i.lifetwo
          i.update({"uid" => session[:user_id], "sid" => xy, "state" => 1, "score" => za, "lifeone" => we, "lifetwo" => wq})
        end
      end
      @score = Score.new({"uid" => session[:user_id], "sid" => params[:sid], "state" => 0, "score" => 0, "lifeone" => 0, "lifetwo" => 0})
      @score.save

      all = Attempt.where(:uid => session[:user_id], :state => 0)
      all.each do |j|
        x = j.qid
        j.update({"uid" => session[:user_id], "qid" => x, "state" => 1, "success" => 0})
      end

      q = q.shuffle
      q.each do |i|
        i.correctoption = ""
        @attempt = Attempt.new({"uid" => session[:user_id], "qid" => i.id, "state" => 0, "success" => 0})
        @attempt.save
      end
      render json: q
    end  
  end

  # GET /questions
  # GET /questions.json
  def index
    if session[:user_id] and User.find_by(id: session[:user_id]).name == "admin"
      @questions = Question.all
    elsif session[:user_id]
      redirect_to quiz_url
    else
      redirect_to login_url
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    if session[:user_id] and User.find_by(id: session[:user_id]).name == "admin"
      @question = Question.new
    elsif session[:user_id]
      redirect_to questions_url
    else
      redirect_to login_url, notice: "Please login first"
    end
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    u=params[:question]
    gen=u[:genre]
    subgen=u[:subgenre]
    
    if Subgenre.find_by(name: subgen).genrename == gen
      @question = Question.new(question_params)

      respond_to do |format|
        if @question.save
          format.html { redirect_to @question, notice: 'Question was successfully created.' }
          format.json { render :show, status: :created, location: @question }
        else
          format.html { render :new }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to '/admin', notice: "Subgenre does not exist in the selected genre"
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:question, :optiona, :optionb, :optionc, :optiond, :correctoption, :subgenre, :genre)
    end
end
