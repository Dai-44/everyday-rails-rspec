require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
  end

  # 名前のあるプロジェクトは有効な状態であること
  it "is valid with a name" do
    project = @user.projects.new(
      name: "Named Project",
    )
    expect(project).to be_valid
  end

  # 名前のないプロジェクトは無効な状態であること
  it "is invalid without a name" do
    project_without_name = @user.projects.build(
      name: nil,
    )
    project_without_name.valid?
    expect(project_without_name.errors[:name]).to include("can't be blank")
  end

  # 重複したプロジェクト名を付ける
  describe "name same project name to two projects" do
    before do
      @project = @user.projects.create(
        name: "Test Project",
      )
    end

    # 一人のユーザーが同じ名前を使うとき
    context "when one user use same project name to two project" do
      # 許可されないこと
      it "does not allow" do
        second_project = @user.projects.build(
          name: "Test Project",
        )
    
        second_project.valid?
        expect(second_project.errors[:name]).to include("has already been taken")
      end
    end

    # 二人のユーザーが同じ名前を使うとき
    context "when two user use same project name to their own project" do
      # 許可されること
      it "allow" do
        other_user = User.create(
          first_name: "Jane",
          last_name: "Tester",
          email: "janetester@example.com",
          password: "dottle-nouveau-pavilion-tights-furze",
        )
    
        other_project = other_user.projects.build(
          name: "Test Project",
        )
    
        expect(other_project).to be_valid
      end
    end
  end
end
