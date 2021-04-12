require 'rails_helper'

RSpec.describe Park, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @park = FactoryBot.build(:park, user_id: @user.id)
  end

  context '登録できる' do
    it '全て揃っていれば登録できる' do
      expect(@park).to be_valid
    end
    it 'explosiveは空でも登録できる' do
      @park.explosive = nil
      @park.valid?
      expect(@park).to be_valid
    end
  end

  context '登録できない' do
    it 'prefecture_idが空では登録できない' do
      @park.prefecture_id = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('都道府県を入力してください')
    end
    it 'prefecture_idが１では登録できない' do
      @park.prefecture_id = 1
      @park.valid?
      expect(@park.errors.full_messages).to include('都道府県は1以外の値にしてください')
    end
    it 'cityが空では登録できない' do
      @park.city = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('市町村を入力してください')
    end
    it 'streetが空では登録できない' do
      @park.street = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('番地を入力してください')
    end
    it 'nameが空では登録できない' do
      @park.name = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('名前を入力してください')
    end
    it 'unit_priceが空では登録できない' do
      @park.unit_price = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('単価を入力してください')
    end
    it 'unit_priceが全角数字では登録できない' do
      @park.unit_price = '５００'
      @park.valid?
      expect(@park.errors.full_messages).to include('単価は半角数字を入力してください')
    end
    it 'start_timeが空では登録できない' do
      @park.start_time = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('開始日時を入力してください')
    end
    it 'start_timeは現在時刻より前では登録できない' do
      @park.start_time = Time.now.floor_to(15.minutes)
      @park.valid?
      expect(@park.errors.full_messages).to include('開始日時は現在の日時より遅い時間を選択してください')
    end
    it 'end_timeが空では登録できない' do
      @park.end_time = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('終了日時を入力してください')
    end
    it 'end_timeがstart_timeと同じ日時では登録できない' do
      @park.end_time = @park.start_time
      @park.valid?
      expect(@park.errors.full_messages).to include('終了日時は開始時刻より遅い時間を選択してください')
    end
    it 'park_imageが空では登録できない' do
      @park.park_image = nil
      @park.valid?
      expect(@park.errors.full_messages).to include('駐車場画像を入力してください')
    end
  end
end
