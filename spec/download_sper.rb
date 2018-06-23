require 'spec_helper'

describe '申込フロー', type: :feature, js: true do
  before do
    # 開発環境の申込画面にアクセスする
    visit 'http://localhost:8000/order/order.php'
  end

  describe 'サービスを申し込む' do
    let(:user_id)   { 'tkengo' }
    let(:nick_name) { 'tkengo-chop' }

    before do
      fill_in 'user_id', user_id
      fill_in 'nick_name', nick_name
      select plan, from: 'plan_id'

      click_on '申し込む'

      @order = Order.where(user_id: user_id)
    end

    it '申込みデータができていること' do
      expect(@order.nick_name).to eq nick_name
    end

    it '申込完了画面が表示されている' do
      expect(page).to have_title 'お申し込み完了'
      expect(page).to have_text "#{plan_id}のお申し込みが完了しました！"
    end

    context '無料プランの場合' do
      let(:plan_id) { '無料プラン' }

      it '無料なので料金は0円であること' do
        expect(@order.charge).to eq 0
      end
    end

    context 'プランAの場合' do
      let(:plan_id) { 'プランA' }

      it '料金は1000円であること' do
        expect(@order.charge).to eq 1000
      end
    end

    context 'プランBの場合' do
      let(:plan_id) { 'プランB' }

      it '料金は2000円であること' do
        expect(@order.charge).to eq 2000
      end

      it 'オプションプランのデータができていること' do
        expect(@order.option).not_to be_nil
      end
    end
  end
end
