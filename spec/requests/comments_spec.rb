require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)

    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(current_path).to_not eq(root_path)

    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    expect(current_path).to eq(root_path)
    expect(current_path).to_not eq(new_user_session_path)
    expect(page).to have_content('Signed in successfully')
  end

  describe 'GET #index' do
    describe 'valid: ' do
      it 'should return a list of comments' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
      end
    end
  end

  describe 'GET #show' do
    describe 'valid: ' do
      it 'should return a comment' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content(@comment.message)
        click_link "Show"
        expect(page).to have_content(@comment.message)
        expect(page).to have_content(@comment.user.email)
        expect(page).to have_content(@comment.article.title)
      end
    end

    describe 'invalid: ' do
      it 'should not return a coment if one does not exist' do
        visit comment_path(10000000)
        expect(current_path).to eq(comments_path)
        expect(page).to have_content("The comment you're looking for cannot be found")
      end
    end
  end

  describe 'GET #new' do
    describe 'valid: ' do
      it 'should create a new comment with valid attributes' do
        @article = FactoryBot.create(:article)
        click_link "Comments"
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)

        fill_in 'comment_message', with: 'I\'m typing alot of stuff here to test the ability to create comments. This will be a very long comment.'
        select @user.email, from: 'comment[user_id]'
        select @article.title, from: 'comment[article_id]'
        click_button 'Create Comment'

        expect(page).to have_content('Comment was successfully created.')
        expect(page).to have_content('I\'m typing alot of stuff here to test the ability to create comments. This will be a very long comment.')
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@article.title)
      end
    end

    describe 'invalid: ' do
      it 'should not create an article with invalid attributes' do
        @article = FactoryBot.create(:article)
        click_link "Comments"
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)

        fill_in 'comment_message', with: ''
        click_button 'Create Comment'

        expect(page).to have_content('Message can\'t be blank')
      end
    end
  end

  describe 'GET #edit' do
    describe 'valid: ' do
      it 'should update a comment with valid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.message)
        expect(page).to have_content(@comment.user.email)
        expect(page).to have_content(@comment.article.title)

        @new_user = FactoryBot.create(:user)

        click_link "Edit"
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: 'A brand new message!'
        select @new_user.email, from: 'comment[user_id]'
        click_button 'Update Comment'

        expect(page).to have_content('Comment was successfully updated.')
        expect(page).to have_content('A brand new message!')
        expect(page).to have_content(@new_user.email)
        expect(current_path).to eq(comment_path(@comment))
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      it 'should not update a comment with invalid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.message)
        expect(page).to have_content(@comment.user.email)
        expect(page).to have_content(@comment.article.title)

        click_link "Edit"
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: ''
        click_button 'Update Comment'

        expect(page).to have_content("Message can't be blank")
        # save_and_open_page
      end
    end
  end

  describe 'GET #destroy' do
    describe 'valid: ' do
      it 'should destroy a comment when destroy is clicked' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
        click_link 'Destroy'

        expect(current_path).to eq(comments_path)
        expect(page).to have_content("Comment was successfully destroyed.")
      end
    end
  end
end
