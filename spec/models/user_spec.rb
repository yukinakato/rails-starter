require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    it "successful user build" do
      user = build(:user, name: "user01", email: "user01")
      expect(user).to be_valid
    end
    it "duplicated email is invalid" do
      FactoryBot.create(:user, name: "user01", email: "user01")
      user = FactoryBot.build(:user, name: "user02", email: "user01")
      expect(user).not_to be_valid
    end
  end
end
