require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @car = FactoryBot.create(:car)
    @park = FactoryBot.create(:park)
    @event = FactoryBot.build(:event, user_id: @user.id, car_id: @car.id, park_id: @park.id)
    @event.start_date = Faker::Time.between(from: @park.start_time + 15.minutes, to: @park.end_time - 15.minutes)
    @event.end_date = @event.start_date + 15.minutes
    sleep 0.1
  end

  context '登録できる' do
    it '全て揃っていれば登録できる' do
      expect(@event).to be_valid
    end
  end

  context '登録できない' do
    it 'memoが空では登録できない' do
      @event.memo = nil
      @event.valid?
      expect(@event.errors.full_messages).to include("メモを入力してください")
    end
    it 'start_dateが空では登録できない' do
      @event.start_date = nil
      @event.valid?
      expect(@event.errors.full_messages).to include("開始日時を入力してください")
    end
    it 'start_dateが範囲外では登録できない' do
      @event.start_date = @park.start_time - 15.minutes
      @event.valid?
      expect(@event.errors.full_messages).to include("開始日時は期間内を選択してください")
    end
    it 'end_dateが空では登録できない' do
      @event.end_date = nil
      @event.valid?
      expect(@event.errors.full_messages).to include("終了日時を入力してください")
    end
    it 'end_dateが範囲外では登録できない' do
      @event.end_date = @park.end_time + 15.minutes
      @event.valid?
      expect(@event.errors.full_messages).to include("終了日時は期間内を選択してください")
    end
    it 'end_dateはstart_dateと同じ時刻では登録できない' do
      @event.end_date = @event.start_date
      @event.valid?
      expect(@event.errors.full_messages).to include("終了日時は開始時刻より遅い時間を選択してください")
    end
    it 'carが登録されていないユーザーは登録できない' do
      @event.car_id = nil
      @event.valid?
      expect(@event.errors.full_messages).to include("Carを入力してください")
    end
  end
end
