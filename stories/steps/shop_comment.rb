factories :products

steps_for :shop_comment do

  When "the user clicks on 'Details' of a product" do
    When "the user fills in the form with his name, email and comment"
    And "the user clicks the 'Submit comment' button"
    Comment.delete_all
    @comment = Comment.find(:first)
  end
  
  When "the user posts a comment which Akismet thinks is $result" do |result|
    result = result == 'ham'
    # TODO this is just a quickfix
    # For some reason mock call causes method not found error on ubuntu
    akismet_mock = Spec::Mocks::Mock.new('akismet', :check_comment => result)
    Viking.stub!(:connect).and_return(akismet_mock)
    When "the user posts a comment to the shop product"
  end
  
  When "the user fills in the form with his name, email and comment" do
    fills_in 'name', :with => 'an anonymous name'
    fills_in 'e-mail', :with => 'anonymous@email.org'
    fills_in 'comment_body', :with => 'the comment body'
  end
  
  Then "the page has a comment creation form" do
    response.should have_form_posting_to(comments_path)
    @form = css_select 'form[action=?]', '/comments'
  end
end
