require 'rails_helper'

RSpec.describe Car, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @car = FactoryBot.build(:car, user_id: @user.id)
  end

  context '登録できる' do
    it '全て揃っていれば登録できる' do
      expect(@car).to be_valid
    end
  end

  context '登録できない' do
    it 'vehicle_typeが空では登録できない' do
      @car.vehicle_type = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("車種を入力してください")
    end

    it 'cityが空では登録できない' do
      @car.city = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("地域を入力してください")
    end

    it 'class_numberが空では登録できない' do
      @car.class_number = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("分類番号を入力してください")
    end

    it 'class_numberが全角数字では登録できない' do
      @car.class_number = '５００'
      @car.valid?
      expect(@car.errors.full_messages).to include("分類番号は3文字以下の半角数字を入力してください")
    end

    it 'class_numberが3文字以内でない場合、登録できない' do
      @car.class_number = 1234
      @car.valid?
      expect(@car.errors.full_messages).to include("分類番号は3文字以下の半角数字を入力してください")
    end

    it 'registration_typeが空では登録できない' do
      @car.registration_type = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("登録種別を入力してください")
    end

    it 'registration_typeが1文字以外では登録できない' do
      @car.registration_type = 'ああ'
      @car.valid?
      expect(@car.errors.full_messages).to include("登録種別は適切なひらがな、半角英字を1文字入力してください")
    end

    it 'registration_typeがひらがな1文字でも適切でないと登録できない' do
      @car.registration_type = 'お'
      @car.valid?
      expect(@car.errors.full_messages).to include("登録種別は適切なひらがな、半角英字を1文字入力してください")
    end

    it 'registration_typeが適切な英語でも全角であると登録できない' do
      @car.registration_type = 'Ｅ'
      @car.valid?
      expect(@car.errors.full_messages).to include("登録種別は適切なひらがな、半角英字を1文字入力してください")
    end

    it 'designated_numberが空では登録できない' do
      @car.designated_number = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("ナンバーを入力してください")
    end

    it 'designated_numberが4文字を超える場合は登録できない' do
      @car.designated_number = 12345
      @car.valid?
      expect(@car.errors.full_messages).to include("ナンバーは4文字以下の半角数字を入力してください")
    end

    it 'designated_numberが全角数字では登録できない' do
      @car.designated_number = '１２３４'
      @car.valid?
      expect(@car.errors.full_messages).to include("ナンバーは4文字以下の半角数字を入力してください")
    end

    it 'vehicle_imageが空では登録できない' do
      @car.vehicle_image = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("車両画像を入力してください")
    end

    it 'number_imageが空では登録できない' do
      @car.number_image = nil
      @car.valid?
      expect(@car.errors.full_messages).to include("ナンバー画像を入力してください")
    end
  end
end
