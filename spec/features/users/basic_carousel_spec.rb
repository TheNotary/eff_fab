feature 'users basic_carousel' do

  before :each do
    @user = FactoryGirl.create(:user_with_yesterweeks_fab)
    @current_fab_note = @user.current_period_fab.notes.first.body
    @prior_fab_note = @user.fabs.last.notes.first.body
    @no_fab_msg = "This user hasn't filled out this FAB!"
  end

  # Scenario: Visit the users page
  #   Given I am a visitor
  #   When I click around with the carousel arrows
  #   Then I see that the Fab is updated with the appropriate fab entries
  scenario 'A visitor can press the forward and back buttons to navigate historic fabs', :js => true do
    visit '/users'

    expect(page).to have_content(@current_fab_note)

    find('.fab-forward-btn').click
    expect(page).to have_content(@no_fab_msg)

    find('.fab-backward-btn').click
    find('.fab-backward-btn').click

    expect(page).to have_content(@prior_fab_note)
  end

end
