class ItemsController < ApplicationController
  def index
  end

  def new
    @item = Item.new 
    #ネストしたテーブルを作成
    @item.images.build
  end

  def create
    item = Item.create(item_params)
    if item.save
      #file_fieldのparams(name属性)に含まれる複数のimageを分解
      params[:images][:image].each do |image|
        #アソシエーションを使い、itemテーブルを通してimageテーブルに作成
        item.images.create(image: image, item_id: item.id)
      end
    end
    redirect_to root_path
  end

  private
  # ユーザーidは、ユーザー登録後に実装(現在は仮で1を挿入)
  def item_params
    params.require(:item).permit(
      :name, 
      :status, 
      :body, 
      :deliver_fee, 
      :delivery_date, 
      :how_to_deliver, 
      :region, 
      :price, 
      :category_id, 
      :brand_id,
      #field_forで設定した値+_attributesで受け取る。複数の為{file_field属性名: []}で受け取る。
      images_attributes: {image: []}
    ).merge(user_id: 1)
  end

end
