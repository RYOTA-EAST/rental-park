require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  context '登録できる' do
    it '全て揃っていれば登録できる' do
      expect(@user).to be_valid
    end

    it 'explosiveは空でも登録できる' do
      @user.explosive = nil
      @user.valid?
      expect(@user).to be_valid
    end
  end

  context '登録できない' do
    it 'nicknameが空では登録できない' do
      @user.nickname = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("ニックネームを入力してください")
    end

    it 'emailが空では登録できない' do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("メールアドレスを入力してください")
    end

    it 'emailに＠が含まれないと登録できない' do
      @user.email = 'ryo.gmail.com'
      @user.valid?
      expect(@user.errors.full_messages).to include("メールアドレスは不正な値です")
    end

    it 'emailが同じものは登録できない' do
      @user.save
      another_user = FactoryBot.build(:user ,email: @user.email)
      another_user.valid?
      expect(another_user.errors.full_messages).to include("メールアドレスはすでに存在します")
    end

    it 'passwordが空では登録できない' do
      @user.password = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワードを入力してください")
    end

    it 'password_confirmationが空では登録できない' do
      @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("確認用パスワードとパスワードの入力が一致しません")
    end

    it 'passwordとpassword_confirmationが一致しないと登録できない' do
      @user.password = 'abc123'
      @user.password_confirmation = 'abc321'
      @user.valid?
      expect(@user.errors.full_messages).to include("確認用パスワードとパスワードの入力が一致しません")
    end

    it 'passwordとpassword_confirmationが一致しても5文字以下だと登録できない' do
      @user.password = 'abc12'
      @user.password_confirmation = 'abc12'
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
    end
    
    it 'first_nameが空だと登録できない' do
      @user.first_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("名前を入力してください")
    end
    
    it 'first_nameが全角文字でないと登録できない' do
      @user.first_name = 'Tanaka'
      @user.valid?
      expect(@user.errors.full_messages).to include("名前は全角文字を使用してください")
    end
    
    it 'last_nameが空だと登録できない' do
      @user.last_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("苗字を入力してください")
    end
    
    it 'last_nameが全角文字でないと登録できない' do
      @user.last_name = 'Taro'
      @user.valid?
      expect(@user.errors.full_messages).to include("苗字は全角文字を使用してください")
    end
    
    it 'first_name_kanaが空だと登録できない' do
      @user.first_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("名前(全角カナ)を入力してください")
    end
    
    it 'first_name_kanaは全角カナでないと登録できない' do
      @user.first_name_kana = 'ﾀﾅｶ'
      @user.valid?
      expect(@user.errors.full_messages).to include("名前(全角カナ)は全角カタカナを使用してください")
    end
    
    it 'last_name_kanaが空だと登録できない' do
      @user.last_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("苗字(全角カナ)を入力してください")
    end
    
    it 'last_name_kanaが全角カナでないと登録できない' do
      @user.last_name_kana = 'ﾀﾛｳ'
      @user.valid?
      expect(@user.errors.full_messages).to include("苗字(全角カナ)は全角カタカナを使用してください")
    end
    
    it 'postal_codeが空だと登録できない' do
      @user.postal_code = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("郵便番号を入力してください")
    end
    
    it 'postal_codeが7文字でも全角数字だと登録できない' do
      @user.postal_code = '１１１１１１１'
      @user.valid?
      expect(@user.errors.full_messages).to include("郵便番号は半角数字を7文字入力してください")
    end
    
    it 'postal_codeが半角数字でも7文字でないと登録できない' do
      @user.postal_code = '123456'
      @user.valid?
      expect(@user.errors.full_messages).to include("郵便番号は半角数字を7文字入力してください")
    end
    
    it 'prefecture_idが空だと登録できない' do
      @user.prefecture_id = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("都道府県を入力してください")
    end
    
    it 'prefecture_idが1だと登録できない' do
      @user.prefecture_id = 1
      @user.valid?
      expect(@user.errors.full_messages).to include("都道府県は1以外の値にしてください")
    end
    
    it 'cityが空だと登録できない' do
      @user.city = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("市町村を入力してください")
    end
    
    it 'streetが空だと登録できない' do
      @user.street = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("番地を入力してください")
    end
    
    it 'phone_numberが空だと登録できない' do
      @user.phone_number = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("電話番号を入力してください")
    end
    
    it 'phone_numberが全角数字だと登録できない' do
      @user.phone_number = '０８０１２３４５６７８'
      @user.valid?
      expect(@user.errors.full_messages).to include("電話番号は半角数字を11文字以内で入力してください")
    end
    
    it 'phone_numberが半角数字でも11文字より多いと登録できない' do
      @user.phone_number = '080123456789'
      @user.valid?
      expect(@user.errors.full_messages).to include("電話番号は半角数字を11文字以内で入力してください")
    end
  end
end
