require 'rails_helper'

RSpec.describe 'Users', type: :system do
  it 'display test' do
    visit pages_index_path
    expect(page).to have_content "Find me"
  end
end
