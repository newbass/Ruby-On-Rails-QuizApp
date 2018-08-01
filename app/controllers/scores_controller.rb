class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  def subgenleaderboard
    usr = User.all
    fin = []
    arrname = []
    scor = []
    usr.each do |i|
      sum = 0
      if Score.where(sid: params[:id], uid: i.id).present?
        b = Score.where(sid: params[:id], uid: i.id)
        a = b.order(score: :desc)
        print a
        sum = a[0].score
      end
      #scor << sum
      #arrname << i.name
      fin << {name: i.name ,scr: sum}
    end

    final = fin.sort_by do |y|
      y[:scr]
    end
    print final
    render json: final.reverse
    end

  def genleaderboard
    x = Genre.find_by(id: params[:id])
    print x
    ids = Subgenre.where(genrename: x.name)
    fin = []
    arrname = []
    scor = []
    peep = User.all
    peep.each do |i|

      arrname << i.name
      sum = 0
      
      ids.each do |j|
        if Score.where(sid: j.id, uid: i.id).present?
          b = Score.where(sid: j.id, uid: i.id)
          a = b.order(score: :desc)
          sum = sum + a[0].score
        end
      end
      scor << sum
      fin << {name: i.name ,scr: sum}
    end
    #print arrname
    #print scor
    final = fin.sort_by do |y|
      y[:scr]
    end
    print final
    render json: final.reverse
  end

  def notattempted
    ne = []
    r = Subgenre.all
    r.each do |j|
      if Score.where(sid: j.id, uid: session[:user_id]).present?
      else
        ne << {name: j.name}
      end
    end
    print ne
    render json: ne
  end

  def updatestate
    if Score.where(uid: session[:user_id], state: 0).reverse.present?
      x = Score.where(uid: session[:user_id], state: 0).reverse
      xy = x[0].sid
      za = x[0].score
      we = x[0].lifeone
      wq = x[0].lifetwo
      x[0].update({"uid" => session[:user_id], "sid" => xy, "state" => 1, "score" => za, "lifeone" => we, "lifetwo" => wq})
    end
  end

  def oneanswer
    a = Score.where(uid: session[:user_id], state: 0).reverse
    if(a[0].lifeone==0)
      x = params[:id]
      ans = Question.find_by(id: x)
      y = Random.rand(ans.correctoption.length)
      print y
      xy = a[0].sid
      za = a[0].score
      wq = a[0].lifetwo
      a[0].update({"uid" => session[:user_id], "sid" => xy, "state" => 0, "score" => za, "lifeone" => 1, "lifetwo" => wq})
      render json: {answer: ans.correctoption[y]}
    else
      render json: {answer: ""}
    end
  end

  def numanswer
    a = Score.where(uid: session[:user_id], state: 0).reverse
    if(a[0].lifetwo==0)
      x = params[:id]
      ans = Question.find_by(id: x)
      y = ans.correctoption.length
      xy = a[0].sid
      za = a[0].score
      we = a[0].lifeone
      a[0].update({"uid" => session[:user_id], "sid" => xy, "state" => 0, "score" => za, "lifeone" => we, "lifetwo" => 1})
      render json: {numanswer: y}
    else
      render json: {numanswer: "null"}
    end
  end

  def fetchdata
    fin = []
    all = Subgenre.all
    all.each do |i|
      if Score.where(uid: session[:user_id], sid: i.id).present?
        a = Score.where(uid: session[:user_id], sid: i.id)
        b = a.order(score: :desc)
        fin << {name: i.name, score: b[0].score}
      end
    end
    render json: fin
  end

  # GET /scores
  # GET /scores.json
  def index
    if session[:user_id] and  User.find_by(id: session[:user_id]).name == "admin"
      @scores = Score.all
    elsif session[:user_id]
    #  @users = User.all
      redirect_to quiz_url
    else
      redirect_to login_url
    end
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
  end

  # GET /scores/new
  def new
    @score = Score.new
  end

  # GET /scores/1/edit
  def edit
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scores/1
  # PATCH/PUT /scores/1.json
  def update
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score, notice: 'Score was successfully updated.' }
        format.json { render :show, status: :ok, location: @score }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to scores_url, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:uid, :sid, :state, :score, :lifeone, :lifetwo)
    end
end
