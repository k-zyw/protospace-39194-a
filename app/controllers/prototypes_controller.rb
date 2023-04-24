class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  #↑全てのアクションの前に、ユーザーがログインしているかどうか確認する！
  #ただし、showアクションと、indexアクションと、newアクションが呼び出された場合は、除く
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    #↑新規投稿を実行する
    Prototype.create #←実行された投稿を保存
    if @prototype.save #←もし、新規投稿が正常に保存された場合、index画面へ戻る。
      redirect_to action: 'index'
    else
      @prototype = Prototype.new(prototype_params) #←新規投稿が正常に保存されなかったら値を保持した状態で、新規投稿画面に留まる
      render :new
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
                                 #↑prototypesテーブルの(params[:id])を削除
    @prototype.destroy                                  #↑paramsとして送られてきたデータ
    redirect_to action: 'index'
  end  

  def edit    
    @prototype = Prototype.find(params[:id])
                                 #↑prototypesテーブルの(params[:id])を編集
  end                                                   #↑paramsとして送られてきたデータ

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to action: 'show'
      #↑updateアクションにデータを更新する記述をし、更新されれば、詳細画面へ戻る。
    else    
      render :edit
      #↑updateアクションで更新ができなかったときは、renderで値を保持した状態で編集画面へ留まる。
    end  
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new 
    @comments = @prototype.comments.includes(:user)   
  end
  
  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    prototype = Prototype.find(params[:id])
    if prototype.user_id != current_user.id
      redirect_to action: :index
    end
  end
end
 
