require 'rails_helper'

RSpec.describe "駐車場新規登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @park = FactoryBot.build(:park)
  end
  context 'マイカーが新規登録ができるとき'do
    it 'ログインしたユーザーは新規登録できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('駐車場一覧')
      # 駐車場一覧ページに移動する
      visit parks_path
      # 新規作成ボタンがあることを確認する
      expect(page).to have_content('新規作成')
      # 駐車場新規作成画面に遷移する
      visit new_park_path
      # 郵便番号を入力し、郵便番号検索を実行
      fill_in 'postal_change', with: "4710025"
      find('input[value="郵便番号検索"]').click
      # 郵便番号から住所を自動入力しているか確認
      expect(
        find('#park_street').value
      ).to eq("西町")
      # フォームに情報を入力する
      fill_in 'その他', with: @park.explosive
      fill_in '名前', with: @park.name
      fill_in '単価', with: @park.unit_price

      select_datetime(@park.start_time, "start")
      select_datetime(@park.end_time, "end")
      
      # 添付する画像を定義する
      park_image_path = Rails.root.join('public/images/park.png')
      # 画像選択フォームに画像を添付する
      attach_file('park[park_image]', park_image_path, make_visible: true)

      # 送信するとモデルのカウントが1上がることを確認する
      expect{
        find('input[value="park create"]').click
      }.to change { Park.count }.by(1)
      # 投稿完了ページに遷移することを確認する
      expect(current_path).to eq(park_path(Park.find_by(name:@park.name).id))
      # 特定の文字と投稿した文字・画像があることを確認する
      expect(page).to have_content('詳細ページ')
      expect(page).to have_selector("img[src$='park.png']")
      expect(page).to have_content(@park.name)
    end
  end
  context '新規登録ができないとき'do
    it 'ログインしていないユーザーは新規登録ページに遷移できない' do
      # 投稿ページに移動する
      visit new_park_path
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '駐車場情報編集（利用停止）', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @park1 = FactoryBot.create(:park, user_id: @user1.id)
    @user2 = FactoryBot.create(:user)
    @park2 = FactoryBot.create(:park, user_id: @user2.id)
  end
  context '編集ができるとき' do
    it 'ログインユーザーは自分が登録した車両情報の編集ができる' do
      # ログインする
      sign_in(@user1)
      # 詳細ページに遷移する
      visit park_path(@park1)
      # 「編集」ボタンがあることを確認する
      expect(page).to have_link '編集', href: edit_park_path(@park1)
      # 編集ページへ遷移する
      visit edit_park_path(@park1)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(
        find('#park_name').value
      ).to eq(@park1.name)
      # 車両内容を編集する
      fill_in 'park_name', with: "#{@park1.name}(編集)"
      # 編集してもモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Park.count }.by(0)
      # 車両一覧画面に遷移したことを確認する
      expect(current_path).to eq(park_path(@park1.id))
      # 変更した内容の車両が存在することを確認する（テキスト）
      expect(page).to have_content("#{@park1.name}(編集)")
      
      # 編集ページへ遷移する
      visit edit_park_path(@park1)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(
        find('#park_name').value
      ).to eq(@park1.name + "(編集)")
      # 借用停止にチェックを入れる
      check "park_rending_stop"
      # 編集してもモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Park.count }.by(0)
      # 車両一覧画面に遷移したことを確認する
      expect(current_path).to eq(park_path(@park1.id))
      # 変更した内容の車両が存在することを確認する（テキスト）
      expect(page).to have_content("貸出停止")
    end
  end
  context '編集ができないとき' do
    it '登録していないユーザは編集画面には遷移できない' do
      # park1を投稿していないユーザーでログインする
      sign_in(@user2)
      # 詳細ページへ遷移する
      visit park_path(@park1)
      # 車両１に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '編集', href: edit_park_path(@park1)
      # 編集ページへ遷移しようとする
      visit edit_park_path(@park1)
      # トップページに遷移させる
      expect(current_path).to eq(top_page_parks_path)
    end
    it 'ログインしていないユーザーは編集画面に遷移できない' do
      # 編集ページに遷移
      visit edit_park_path(@park1)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '駐車場詳細表示', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @park1 = FactoryBot.create(:park, user_id: @user1.id)
    @user2 = FactoryBot.create(:user)
    @park2 = FactoryBot.create(:park, user_id: @user2.id)
    @car2 = FactoryBot.create(:car, user_id: @user2.id)
  end
  context '詳細が確認できるとき' do
    it '登録したユーザーは詳細ページに遷移して「編集」ボタンが表示される' do
      # ログインする
      sign_in(@user1)
      # 駐車場詳細表示
      visit park_path(@park1)
      # 詳細ページに車両の内容が含まれている
      expect(page).to have_content(@park1.name)
      # 「編集」ボタンがあることを確認する
      expect(page).to have_link '編集', href: edit_park_path(@park1)
    end
    it '登録していないユーザーは詳細ページに遷移して「レンタル」ボタンが表示される' do
      # ログインする
      sign_in(@user2)
      # 駐車場詳細表示
      visit park_path(@park1)
      # 詳細ページに車両の内容が含まれている
      expect(page).to have_content(@park1.name)
      # 「編集」ボタンがないことを確認する
      expect(page).to have_no_link '編集', href: edit_park_path(@park1)
      # 「レンタル」ボタンがあることを確認する
      expect(page).to have_link 'レンタル', href: new_park_event_path(@park1)
    end
    it 'ログインしていない場合は「ログインと車両登録でレンタル」を表示' do
      # 編集ページへ遷移しようとする
      visit park_path(@park1)
      # 詳細ページに車両の内容が含まれている
      expect(page).to have_content(@park1.name)
      # 「編集」ボタンがあることを確認する
      expect(page).to have_link 'ログインと', href: new_park_event_path(@park1)
      expect(page).to have_link '車両登録で', href: new_park_event_path(@park1)
      expect(page).to have_link 'レンタル', href: new_park_event_path(@park1)
    end
  end
end