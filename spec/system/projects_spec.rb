require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, name: "Test project", owner: user) }

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    sign_in user
    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  # ユーザーは既存のプロジェクトを編集する
  scenario "user updates his own project" do
    sign_in user
    visit root_path

    click_link "Test project"
    within "h1" do
      click_link "Edit"
    end
    fill_in "Name", with: "Updated project"
    click_button "Update Project"

    aggregate_failures do
      expect(page).to have_content "Project was successfully updated"
      expect(page).to have_content "Updated project"
      expect(project.reload.name).to eq "Updated project"
    end
  end
end
