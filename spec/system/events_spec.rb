require 'rails_helper'

RSpec.describe "駐車場借用登録", type: :system do
  before do
    driven_by(:rack_test)
    @user1 = FactoryBot.create(:user)
    @park1 = FactoryBot.create(:park, user_id: @user1.id ,city: "豊田市", street: "西町")
    @car1 = FactoryBot.create(:car, user_id: @user1.id)
    @event1 = FactoryBot.build(:event, user_id: @user1.id, car_id: @car1.id, park_id: @park1.id)
    @event1.start_date = Faker::Time.between(from: @park1.start_time + 15.minutes, to: @park1.end_time - 15.minutes).ceil_to(15.minutes)
    @event1.end_date = @event1.start_date + 15.minutes
    
    @user2 = FactoryBot.create(:user)
    @park2 = FactoryBot.create(:park, user_id: @user2.id ,city: "豊田市", street: "西町")
    @car2 = FactoryBot.create(:car, user_id: @user2.id)
    @event2 = FactoryBot.build(:event, user_id: @user2.id, car_id: @car2.id, park_id: @park1.id)
    @event2.start_date = Faker::Time.between(from: @park1.start_time + 15.minutes, to: @park1.end_time - 15.minutes).ceil_to(15.minutes)
    @event2.end_date = @event2.start_date + 15.minutes
    
    @user3 = FactoryBot.create(:user)
    @park3 = FactoryBot.create(:park, user_id: @user3.id ,city: "豊田市", street: "西町")
    sleep 0.1
  end
  context '駐車場を借用できるとき'do
    it '駐車場を作成したユーザでない場合は借用できる' do
      # ログインする
      sign_in(@user2)
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('レンタル一覧')
      # 駐車場を検索ワードを入力して検索をクリックする
      fill_in 'search_word' , with: @park1.city + @park1.street
      find('input[value="検索"]').click
      # 新規作成ボタンがあることを確認する
      expect(page).to have_content(@park1.name)
      # 駐車場詳細に遷移する
      visit park_path(@park1)
      # 「レンタル」ボタンがあることを確認する
      expect(page).to have_link 'レンタル', href: new_park_event_path(@park1)
      # レンタル新規登録に遷移する
      visit new_park_event_path(@park1)
      # フォームを入力する
      select_datetime(@event2.start_date, "start_date", "event")
      select_datetime(@event2.end_date, "end_date", "event")
      select @car2.vehicle_type, from: "event[car_id]"
      fill_in 'メモ', with: @event2.memo

      # 送信するとモデルのカウントが1上がることを確認する
      expect{
        find('input[value="rental create!"]').click
      }.to change { Event.count }.by(1)
      # 投稿完了ページに遷移することを確認する
      expect(current_path).to eq(events_path)
      # 特定の文字と投稿した文字・画像があることを確認する
      expect(page).to have_content(@event2.memo)
    end
    it '駐車場を作成したユーザでも「貸出停止時間」として登録できる' do
      # ログインする
      sign_in(@user1)
      # 駐車場詳細に遷移する
      visit park_path(@park1)
      # 「レンタル」ボタンがあることを確認する
      expect(page).to have_link '貸出停止日時設定', href: new_park_event_path(@park1)
      # レンタル新規登録に遷移する
      visit new_park_event_path(@park1)
      # フォームを入力する
      select_datetime(@event1.start_date, "start_date", "event")
      select_datetime(@event1.end_date, "end_date", "event")
      select @car1.vehicle_type, from: "event[car_id]"
      fill_in 'メモ', with: @event1.memo
      # 送信するとモデルのカウントが1上がることを確認する
      expect{
        find('input[value="rental create!"]').click
      }.to change { Event.count }.by(1)
      # 投稿完了ページに遷移することを確認する
      expect(current_path).to eq(park_path(@park1))
      # 登録されているページに遷移する
      # visit "/parks/#{@park1.id}?start_date=#{@event1.start_date.strftime("%Y-%m-%d")}"
      # 特定の文字と投稿した文字・画像があることを確認する
      # expect(page).to have_link "#{@event1.start_date.strftime('%H:%M')}〜#{@event1.end_date.strftime('%H:%M')}", href: park_event_path(park_id: @park1.id, event_id: @event1.id)
      expect(page).to have_content(@event1.start_date.strftime('%H:%M'))
      expect(page).to have_content(@event1.end_date.strftime('%H:%M'))
    end
  end
  context '借用ができないとき'do
    it 'ログインしていないユーザーは借用ページに遷移できない' do
      # 投稿ページに移動する
      visit new_park_event_path(@park1)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it 'マイカーを保有しないユーザーは借用ページに遷移できない' do
      # ログインする
      sign_in(@user3)
      # 投稿ページに移動する
      visit new_park_event_path(@park2)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(park_path(@park2))
    end
  end
end

RSpec.describe "駐車場借用キャンセル", type: :system do
  before do
    driven_by(:rack_test)
    @user1 = FactoryBot.create(:user)
    @park1 = FactoryBot.create(:park, user_id: @user1.id ,city: "豊田市", street: "西町")
    @car1 = FactoryBot.create(:car, user_id: @user1.id)
    start_date1 = Faker::Time.between(from: @park1.start_time + 15.minutes, to: @park1.end_time - 15.minutes).ceil_to(15.minutes)
    end_date1 = start_date1 + 15.minutes
    @event1 = FactoryBot.create(:event, user_id: @user1.id, car_id: @car1.id, park_id: @park1.id, start_date: start_date1, end_date: end_date1)
    
    @user2 = FactoryBot.create(:user)
    @park2 = FactoryBot.create(:park, user_id: @user2.id ,city: "豊田市", street: "西町")
    @car2 = FactoryBot.create(:car, user_id: @user2.id)
    start_date2 = Faker::Time.between(from: @park1.start_time + 15.minutes, to: @park1.end_time - 15.minutes).ceil_to(15.minutes)
    end_date2 = start_date2 + 15.minutes
    @event2 = FactoryBot.create(:event, user_id: @user2.id, car_id: @car2.id, park_id: @park1.id, start_date: start_date2, end_date: end_date2)

    @user3 = FactoryBot.create(:user)
    @park3 = FactoryBot.create(:park, user_id: @user3.id ,city: "豊田市", street: "西町")
    sleep 0.1
  end
  context '駐車場予約編集（キャンセル）できるとき'do
    it '駐車場を借用したユーザは編集（キャンセル）できる' do
      # ログインする
      sign_in(@user2)
      # レンタル一覧に遷移する
      visit events_path
      # レンタル詳細ページに遷移する
      visit park_event_path(@park1, @event2)
      # 「キャンセル」ボタンがあることを確認する
      expect(page).to have_link '編集', href: edit_park_event_path(@park1, @event2)
      # 予約編集ページに遷移
      visit edit_park_event_path(@park1, @event2)
      # 編集
      fill_in 'メモ', with: @event2.memo + "（編集）"
      # 「キャンセル」をクリックしてもモデルのカウントは変化しないことを確認する
      expect{
        find('input[value="更新"]').click
      }.to change { Event.count }.by(0)
      # 駐車場の詳細ページに遷移することを確認
      expect(current_path).to eq(park_event_path(@park1, @event2))
      # 特定の文字と投稿した文字・画像があることを確認する
      expect(page).to have_content(@event2.memo + "（編集）")
      # 予約編集ページに遷移
      visit edit_park_event_path(@park1, @event2)
      # 編集
      check 'キャンセル'
      # 「キャンセル」をクリックしてもモデルのカウントは変化しないことを確認する
      expect{
        find('input[value="更新"]').click
      }.to change { Event.count }.by(0)
      # 駐車場の詳細ページに遷移することを確認
      expect(current_path).to eq(events_path)
      visit "/parks/#{@park1.id}?start_date=#{@event2.start_date.strftime("%Y-%m-%d")}"

      # 特定の文字と投稿した文字があることを確認する
      expect(page).to have_no_content(@event2.start_date.strftime('%H:%M'))
      expect(page).to have_no_content(@event2.end_date.strftime('%H:%M'))
      # レンタル一覧に遷移する
      visit events_path
      # 編集した文字とキャンセル料の負担割合が表示されていることを確認
      expect(page).to have_content(@event2.memo + "（編集）")
      if (@event2.start_date.to_date - @event2.updated_at.to_date).to_i < 1
        expect(page).to have_no_content('100%負担')
      elsif (@event2.start_date.to_date - @event2.updated_at.to_date).to_i <= 3
        expect(page).to have_no_content('50%負担')
      else
        expect(page).to have_no_content('0%負担')
      end
    end
    it '駐車場を登録したユーザであれば「貸出停止時間」を編集（キャンセル）できる' do
      # ログインする
      sign_in(@user1)
      # 駐車場詳細に遷移する
      visit park_path(@park1)
      # simple calendarの週を変更する
      visit "/parks/#{@park1.id}?start_date=#{@event1.start_date.strftime("%Y-%m-%d")}"
      # 駐車場に登録された時間があることを確認する
      expect(page).to have_content(@event1.start_date.strftime('%H:%M'))
      expect(page).to have_content(@event1.end_date.strftime('%H:%M'))
      # 「レンタル」ボタンがあることを確認する
      expect(page).to have_link '貸出停止日時設定', href: new_park_event_path(@park1)
      # レンタル新規登録に遷移する
      visit edit_park_event_path(@park1, @event1)
      # 編集
      fill_in 'メモ', with: @event1.memo + "（編集）"
      # 「キャンセル」をクリックしてもモデルのカウントは変化しないことを確認する
      expect{
        find('input[value="更新"]').click
      }.to change { Event.count }.by(0)
      # 駐車場の詳細ページに遷移することを確認
      expect(current_path).to eq(park_event_path(@park1, @event1))
      # 特定の文字と投稿した文字・画像があることを確認する
      expect(page).to have_content(@event1.memo + "（編集）")
      # 予約編集ページに遷移
      visit edit_park_event_path(@park1, @event1)
      # 編集
      check 'キャンセル'
      # 「キャンセル」をクリックしてもモデルのカウントは変化しないことを確認する
      expect{
        find('input[value="更新"]').click
      }.to change { Event.count }.by(0)
      # 投稿完了ページに遷移することを確認する
      expect(current_path).to eq(park_path(@park1))
      # simple calendarの週を変更する
      visit "/parks/#{@park1.id}?start_date=#{@event1.start_date.strftime("%Y-%m-%d")}"
      # 登録していた時間が表示されていないことを確認
      expect(page).to have_no_content(@event1.start_date.strftime('%H:%M'))
      expect(page).to have_no_content(@event1.end_date.strftime('%H:%M'))
    end
  end
  context '編集（キャンセル）ができないとき'do
    it 'ログインしていない場合借用編集ページに遷移できない' do
      # 投稿ページに移動する
      visit edit_park_event_path(@park1, @event2)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '借用予約をしたユーザーでない場合借用編集ページに遷移できない' do
      # ログインする
      sign_in(@user3)
      # 投稿ページに移動する
      visit edit_park_event_path(@park1, @event2)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(top_page_parks_path)
    end
  end
end

RSpec.describe "駐車場借用一覧", type: :system do
  before do
    driven_by(:rack_test)
    @user1 = FactoryBot.create(:user)
    @park1 = FactoryBot.create(:park, user_id: @user1.id ,city: "豊田市", street: "西町")
    @car1 = FactoryBot.create(:car, user_id: @user1.id)
    start_date1 = Faker::Time.between(from: @park1.start_time + 15.minutes, to: @park1.end_time - 15.minutes).ceil_to(15.minutes)
    end_date1 = start_date1 + 15.minutes
    @event1 = FactoryBot.create(:event, user_id: @user1.id, car_id: @car1.id, park_id: @park1.id, start_date: start_date1, end_date: end_date1)
    
    @user2 = FactoryBot.create(:user)
    @park2 = FactoryBot.create(:park, user_id: @user2.id ,city: "豊田市", street: "西町")
    @car2 = FactoryBot.create(:car, user_id: @user2.id)
    start_date2 = Faker::Time.between(from: @park1.start_time + 15.minutes, to: @park1.end_time - 15.minutes).ceil_to(15.minutes)
    end_date2 = start_date2 + 15.minutes
    @event2 = FactoryBot.create(:event, user_id: @user2.id, car_id: @car2.id, park_id: @park1.id, start_date: start_date2, end_date: end_date2)

    @user3 = FactoryBot.create(:user)
    @park3 = FactoryBot.create(:park, user_id: @user3.id ,city: "豊田市", street: "西町")
    sleep 0.1
  end
  context '表示できる場合' do
    it 'ログインしたユーザは借用一覧ページで一覧を確認できる' do
      # ログインする
      sign_in(@user2)
      # 一覧ページに遷移する
      visit events_path
      # 一覧ページに遷移できている確認する
      expect(current_path).to eq(events_path)
      # レンタルの情報がある確認する
      expect(page).to have_content(@event2.car.vehicle_type)
      expect(page).to have_content(@event2.start_date.strftime("%Y年%m月%d日%H:%M"))
      expect(page).to have_content(@event2.end_date.strftime("%Y年%m月%d日%H:%M"))
      expect(page).to have_content(@event2.memo)
      # ステータスを確認する
      expect(page).to have_content("借用予定")
      # 編集ページに遷移する
      visit edit_park_event_path(@park1, @event2)
      # キャンセルを選択する
      check 'キャンセル'
      # 更新をクリックする
      expect{
        find('input[value="更新"]').click
      }.to change { Event.count }.by(0)
      # 遷移先を確認する
      expect(current_path).to eq(events_path)
      # 編集した文字とキャンセル料の負担割合が表示されていることを確認
      expect(page).to have_content(@event2.memo)
      if (@event2.start_date.to_date - @event2.updated_at.to_date).to_i < 1
        expect(page).to have_no_content('100%負担')
      elsif (@event2.start_date.to_date - @event2.updated_at.to_date).to_i <= 3
        expect(page).to have_no_content('50%負担')
      else
        expect(page).to have_no_content('0%負担')
      end
    end
  end
  context '表示できない場合' do
    it 'ログインしていないユーザは借用一覧ページを確認できない' do
      # 投稿ページに移動する
      visit events_path
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end