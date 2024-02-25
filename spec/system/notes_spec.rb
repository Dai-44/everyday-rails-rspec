require 'rails_helper'

RSpec.describe "Notes", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, name: "My Project", owner: @user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Log in"
  end

  # ノートの作成
  scenario "user create a task" do
    expect {
      click_link "My Project"
      click_link "Add Note"
      fill_in "Message", with: "New Note"
      click_button "Create Note"

      expect(page).to have_content "Note was successfully created."
      expect(page).to have_content "New Note"
    }.to change(@project.notes, :count).by(1)
  end

  # ノートの編集
  scenario "user edit a task" do
    FactoryBot.create(:note, message: "Old Note", project: @project)
    expect {
      click_link "My Project"
      within ".note-info" do
        click_link "Edit"
      end
      fill_in "Message", with: "Updated Note"
      click_button "Update Note"

      expect(page).to have_content "Note was successfully updated."
      expect(page).to have_content "Updated Note"
    }.to_not change(@project.notes, :count)
  end
end
