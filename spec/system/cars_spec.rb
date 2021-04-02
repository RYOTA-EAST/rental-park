require 'rails_helper'

RSpec.describe "マイカー新規登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @car = FactoryBot.build(:car)
  end
  context 'マイカーが新規登録ができるとき'do
    it 'ログインしたユーザーは新規登録できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('マイカー')
      # 投稿ページに移動する
      visit new_car_path
      # フォームに情報を入力する
      fill_in '車種', with: @car.vehicle_type
      fill_in '地域', with: @car.city
      fill_in '分類番号', with: @car.class_number
      fill_in '登録種別', with: @car.registration_type
      fill_in 'ナンバー', with: @car.designated_number
      
      # 添付する画像を定義する
      number_image_path = Rails.root.join('public/images/number.jpeg')
      vehicle_image_path = Rails.root.join('public/images/vehicle.jpeg')
      # 画像選択フォームに画像を添付する
      attach_file('car[number_image]', number_image_path, make_visible: true)
      attach_file('car[vehicle_image]', vehicle_image_path, make_visible: true)

      # 送信するとCarモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Car.count }.by(1)
      # 投稿完了ページに遷移することを確認する
      expect(current_path).to eq(cars_path)
      # 「投稿が完了しました」の文字があることを確認する
      expect(page).to have_content('マイカー一覧')
      expect(page).to have_selector("img[src$='vehicle.jpeg']")
      # トップページには先ほど投稿した内容のマイカーが存在することを確認する（テキスト）
      expect(page).to have_content(@car.vehicle_type)
    end
  end
  context '新規登録ができないとき'do
    it 'ログインしていないユーザーは新規登録ページに遷移できない' do
      # 投稿ページに移動する
      visit new_car_path
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'マイカー情報編集', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @car1 = FactoryBot.create(:car, user_id: @user1.id)
    @user2 = FactoryBot.create(:user)
    @car2 = FactoryBot.create(:car)
  end
  context '編集ができるとき' do
    it 'ログインユーザーは自分が登録した車両情報の編集ができる' do
      # ログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user1.email
      fill_in 'パスワード', with: @user1.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページに遷移する
      visit car_path(@car1)
      # car1に「編集」ボタンがあることを確認する
      expect(page).to have_link '編集', href: edit_car_path(@car1)
      # 編集ページへ遷移する
      visit edit_car_path(@car1)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(
        find('#car_vehicle_type').value
      ).to eq(@car1.vehicle_type)
      # 車両内容を編集する
      fill_in 'car_vehicle_type', with: "#{@car1.vehicle_type}(編集)"
      # 編集してもcarモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Car.count }.by(0)
      # 車両一覧画面に遷移したことを確認する
      expect(current_path).to eq(cars_path)
      # 変更した内容の車両が存在することを確認する（テキスト）
      expect(page).to have_content("#{@car1.vehicle_type}(編集)")
    end
  end
  context '編集ができないとき' do
    it '登録していないユーザは編集画面には遷移できない' do
      # car1を投稿していないユーザーでログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user2.email
      fill_in 'パスワード', with: @user2.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページへ遷移する
      visit car_path(@car1)
      # 車両１に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '編集', href: edit_car_path(@car1)
      # 編集ページへ遷移しようとする
      visit edit_car_path(@car1)
      # トップページに遷移させる
      expect(current_path).to eq(top_page_parks_path)
    end
    it 'ログインしていないユーザーは編集画面に遷移できない' do
      # トップページにいる
      visit edit_car_path(@car1)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'マイカー利用停止', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @car1 = FactoryBot.create(:car, user_id: @user1.id)
    @user2 = FactoryBot.create(:user)
    @car2 = FactoryBot.create(:car, user_id: @user2.id)
  end
  context '利用停止できるとき' do
    it '登録したユーザーはマイカー利用停止ができる' do
      # ログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user1.email
      fill_in 'パスワード', with: @user1.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 編集ページへ遷移する
      visit edit_car_path(@car1)
      # 車両内容を編集する
      check '利用停止'
      # 編集してもcarモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Car.count }.by(0)
      # 車両一覧画面に遷移したことを確認する
      expect(current_path).to eq(cars_path)
      # 変更した内容の車両が存在することを確認する（テキスト）
      expect(page).to have_content("利用停止")
    end
  end
  context '利用停止ができないとき' do
    it '登録していないユーザーは情報編集（利用停止）画面には遷移できない' do
      # car1を投稿していないユーザーでログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user2.email
      fill_in 'パスワード', with: @user2.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 編集ページへ遷移しようとする
      visit edit_car_path(@car1)
      # トップページに遷移させる
      expect(current_path).to eq(top_page_parks_path)
    end
    it 'ログインしていないとマイカー編集（利用停止）画面に遷移できない' do
      # 編集ページへ遷移しようとする
      visit edit_car_path(@car1)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
RSpec.describe 'マイカー詳細', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @car1 = FactoryBot.create(:car, user_id: @user1.id)
    @user2 = FactoryBot.create(:user)
    @car2 = FactoryBot.create(:car, user_id: @user2.id)
  end
  context '詳細が確認できるとき' do
    it '登録したユーザーはマイカー詳細ページに遷移して「編集」ボタンが表示される' do
      # ログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user1.email
      fill_in 'パスワード', with: @user1.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページに遷移する
      visit car_path(@car1)
      # 詳細ページに車両の内容が含まれている
      expect(page).to have_content("#{@car1.vehicle_type}")
      # 「編集」ボタンがあることを確認する
      expect(page).to have_link '編集', href: edit_car_path(@car1)
    end
    it '登録していないユーザーでも詳細ページに遷移できるものの「編集」ボタンは表示されない' do
      # user2でログインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @user2.email
      fill_in 'パスワード', with: @user2.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページに遷移する
      visit car_path(@car1)
      # 詳細ページに車両の内容が含まれている
      expect(page).to have_content("#{@car1.vehicle_type}")
      # 「編集」ボタンがあることを確認する
      expect(page).to have_no_link '編集', href: edit_car_path(@car1)
    end
  end
  context '詳細が確認できないとき' do
    it 'ログインしていないとマイカー詳細画面に遷移できない' do
      # 編集ページへ遷移しようとする
      visit car_path(@car1)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end