require 'rails_helper'

RSpec.describe "Projects", type: :system do
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    }.to change(user.projects, :count).by(1)
  end

  # プロジェクトの編集作業
  context "edit a project" do
    before do
      @user = FactoryBot.create(:user)
      FactoryBot.create(:project, name: "My Project", owner: @user)
  
      visit root_path
      click_link "Sign in"
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
    end

    # ユーザーは自分のプロジェクトを編集できる
    scenario "user edits his project" do
      expect {
        click_link "My Project"
        within "h1" do
          click_link "Edit"
        end
        fill_in "Name", with: "Updated Project"
        click_button "Update Project"
  
        expect(page).to have_content "Project was successfully updated."
        expect(page).to have_content "Updated Project"
        expect(page).to have_content "Owner: #{@user.name}"
      }.to_not change(@user.projects, :count)
    end
  
    # 空の値で更新することはできない
    scenario "user can't edit his project with nil" do
      expect {
        click_link "My Project"
        within "h1" do
          click_link "Edit"
        end
        fill_in "Name", with: nil
        click_button "Update Project"
  
        expect(page).to have_content "1 error prohibited this project from being saved"
        expect(page).to have_content "Name can't be blank"
        expect(page).to have_content "Editing project"
        expect(page).to have_button "Update Project"
      }.to_not change(@user.projects, :count)
    end
  end
end
