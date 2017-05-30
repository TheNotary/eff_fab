def scrape_procedure
  debug_mode = true

  # Clear out existing users.
  User.delete_all
  Team.delete_all
  Fab.delete_all

  # Create admin user
  u = CreateAdminService.new.call
  u.name = "Admin"
  u.save
  puts 'CREATED ADMIN USER: ' << u.email


  import_sample_users_and_teams(debug_mode)


=begin
  profiles = get_staff_profiles

  profiles.each do |profile|
    u = create_user_from_profile(profile)
    build_fabs(u) if debug_mode
  end

  delete_other_team_if_not_needed
=end
end







# The dogs create the other team, but don't count as real users... thus this func
def delete_other_team_if_not_needed
  t = Team.find_by(name: 'Other')
  t.delete if t && t.users.count == 0
end

# This is an updated stub just to help populate sample data
def export_users()
  users = User.all.map do |u|
    {
      name: u.name,
      team: u.team && u.team.name,
      title: u.title,
      email: u.email,
      avatar: u.avatar.url
    }
  end
end

def import_sample_users_and_teams(debug_mode)
  sample_users.map do |u|
    u[:password] = User.generate_password
    u[:team] = get_team(u[:team])
    u = User.create(u)
    build_fabs(u) if debug_mode
    u
  end
end

def sample_users
  users = [{:name=>"Jennifer Lynch", :team=>"Legal", :title=>"Senior Staff Attorney", :email=>"jlynch@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/183/original/jen_lynch_eff3-small.jpg?1460499483"},
{:name=>"Dave Maass", :team=>"Activism", :title=>"Investigative Researcher", :email=>"dm@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/184/original/zombies_copy.jpg?1460499485"},
    {:name=>"Aaron Mackey", :team=>"Legal", :title=>"Frank Stanton Legal Fellow", :email=>"amackey@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/185/original/amackey.jpg?1460499489"},
{:name=>"Jeremy Malcolm", :team=>"International", :title=>"Senior Global Policy Analyst", :email=>"jmalcolm@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/186/original/grt_7195.jpg?1460499492"},
    {:name=>"Tammy McMillen", :team=>"Development", :title=>"Data Processing Assistant", :email=>"tammy@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/187/original/tammymcmillen.jpg?1460499495"},
{:name=>"Corynne McSherry", :team=>"Legal", :title=>"Legal Director", :email=>"corynne@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/188/original/corynne_huge.jpg?1460499497"},
    {:name=>"Madeleine Mulkern", :team=>"Legal", :title=>"Legal Secretary", :email=>"madeleine@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/189/original/madeleine-mulkern.jpg?1460499498"},
{:name=>"Daniel Nazer", :team=>"Legal", :title=>"Staff Attorney and Mark Cuban Chair to Eliminate Stupid Patents", :email=>"daniel@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/190/original/daniel_nazer_photo_1.jpg?1460499499"},
    {:name=>"Danny O'Brien", :team=>"International", :title=>"International Director", :email=>"danny@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/191/original/danny-final-color.jpg?1460499501"},
{:name=>"Camille Ochoa", :team=>"Operations", :title=>"Operations Assistant", :email=>"camille@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/192/original/camille_amul.jpg?1460499502"},
    {:name=>"Soraya Okuda", :team=>"Press/Graphics", :title=>"Designer", :email=>"soraya@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/193/original/screen_shot_2015-08-26_at_2.07.29_am.png?1460499503"},
{:name=>"Kurt Opsahl", :team=>"Executive", :title=>"Deputy Executive Director and General Counsel", :email=>"kurt@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/194/original/kurtopsahlheadshot.jpg?1460499505"},
    {:name=>"Nicole Puller", :team=>"Development", :title=>"Donor Relations Coordinator", :email=>"nicole@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/195/original/done.jpg?1460499506"},
{:name=>"Cooper Quintin", :team=>"Tech Projects", :title=>"Staff Technologist", :email=>"cooperq@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/196/original/cooper_quintin_vert.png?1460499508"},
    {:name=>"Vera Ranieri", :team=>"Legal", :title=>"Staff Attorney", :email=>"vera@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/197/original/vera2.png?1460499509"},
{:name=>"Rainey Reitman", :team=>"Activism", :title=>"Activism Director", :email=>"rainey@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/198/original/rainey_2.jpg?1460499511"},
    {:name=>"Katitza Rodriguez", :team=>"International", :title=>"International Rights Director", :email=>"katitza@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/199/original/img_4103_1.jpg?1460499512"},
    {:name=>"Cristina Rosales", :team=>"Development", :title=>"Grant Writer", :email=>"cristina@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/200/original/cristina.jpg?1460499514"},
{:name=>"Mark Rumold", :team=>"Legal", :title=>"Senior Staff Attorney", :email=>"mark@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/202/original/mark_rumold_mug.jpg?1460499518"},
    {:name=>"Seth Schoen", :team=>"Tech Projects", :title=>"Senior Staff Technologist", :email=>"schoen@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/203/original/seth_thumb.jpg?1460499519"},
{:name=>"Adam Schwartz", :team=>"Legal", :title=>"Senior Staff Attorney", :email=>"adam@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/204/original/adam_schwartz.png?1460499520"},
    {:name=>"David Sobel", :team=>"Legal", :title=>"Senior Counsel", :email=>"sobel@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/205/original/sobel_thumb2_1.jpg?1460499522"},
{:name=>"Mitch Stoltz", :team=>"Legal", :title=>"Senior Staff Attorney", :email=>"mitch@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/206/original/mitch_stoltz_254.jpg?1460499523"},
    {:name=>"Noah Swartz", :team=>"Tech Projects", :title=>"Staff Technologist", :email=>"noah@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/207/original/14808581940_3ad5b2fbef_k.jpg?1460499525"},
{:name=>"William Theaker", :team=>"Tech Ops", :title=>"Technology Generalist", :email=>"william@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/208/original/image.jpg?1460499526"},
    {:name=>"Lee Tien", :team=>"Legal", :title=>"Senior Staff Attorney and Adams Chair for Internet Rights", :email=>"lee@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/209/original/lee_tien_-_mug.jpg?1460499528"},
{:name=>"Jeremy Tribby", :team=>"Web Development", :title=>"Front-End Engineer/Designer", :email=>"tribby@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/210/original/jeremy.jpg?1460499529"},
    {:name=>"Maggie Utgoff", :team=>"Finance/HR", :title=>"Employee Experience Manager", :email=>"mutgoff@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/211/original/maggie_utgoff.jpg?1460499530"},
{:name=>"Kit Walsh", :team=>"Legal", :title=>"Staff Attorney", :email=>"kit@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/212/original/kit_pixel_portrait.png?1460499532"},
    {:name=>"Barak Weinstein", :team=>"Executive", :title=>"Executive Assistant", :email=>"barak@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/213/original/barak.jpg?1460499533"},
{:name=>"Jamie Lee Williams", :team=>"Legal", :title=>"Frank Stanton Legal Fellow", :email=>"jamie@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/214/original/jamie_lee_williams_-_mug.png?1460499535"},
    {:name=>"Lisa Wright", :team=>"Tech Ops", :title=>"Technologist General", :email=>"leez@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/215/original/leez_trapped.jpeg?1460499537"},
{:name=>"Jillian C. York", :team=>"International", :title=>"Director for International Freedom of Expression", :email=>"jillian@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/216/original/dsc01111.jpg?1460499538"},
    {:name=>"Squiggy Rubio", :team=>"Web Development", :title=>"Web Developer", :email=>"squiggy@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/201/original/screen_shot_2015-11-05_at_3.12.49_pm.png?1460499516"},
{:name=>"Aaron Jue", :team=>"Development", :title=>"Senior Membership Advocate", :email=>"aaron@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/178/original/eff_staff_photo2.jpg?1460499475"},
    {:name=>"Amul Kalia", :team=>"Legal", :title=>"Intake Coordinator", :email=>"amul@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/179/original/amul_kalia.jpg?1460499476"},
{:name=>"Magdalena Kazmierczak", :team=>"Development", :title=>"Membership Coordinator", :email=>"maggie@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/180/original/img_0368_2.jpg?1460499478"},
    {:name=>"Rocket Lee", :team=>"Tech Ops", :title=>"Technology Generalist", :email=>"rocket@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/181/original/img_1701_copy.jpg?1460499479"},
{:name=>"Laura Lemus", :team=>"Operations", :title=>"Operations Coordinator", :email=>"laura@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/182/original/feb.png?1460499481"},
    {:name=>"Mark Burdett", :team=>"Web Development", :title=>"Senior Engineer", :email=>"mfb@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/150/original/2012-04-29_15-57-43_787.jpg?1460499412"},
{:name=>"Admin", :team=>nil, :title=>nil, :email=>"user@example.com", :avatar=>"/images/original/missing.png"},
{:name=>"David Bogado", :team=>"International", :title=>"Latin American Community Development Coordinator", :email=>"davidbogado@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/146/original/bogado_-_medium.jpg?1460499404"},
{:name=>"Ben Burke", :team=>"Tech Ops", :title=>"System Administrator", :email=>"ben@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/151/original/nothingtohide.png?1460499414"},
{:name=>"Shahid Buttar", :team=>"Activism", :title=>"Director of Grassroots Advocacy", :email=>"shahid@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/152/original/shahid_formal_photo.jpg?1460499416"},
{:name=>"Nate Cardozo", :team=>"Legal", :title=>"Senior Staff Attorney", :email=>"nate@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/153/original/cardozo.jpg?1460499417"},
{:name=>"Kim Carlson", :team=>"International", :title=>"International Project Manager", :email=>"kim@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/154/original/kim-vert.jpg?1460499419"},
{:name=>"Andrea Chiang", :team=>"Finance/HR", :title=>"Accounting Manager", :email=>"andrea@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/155/original/andrea_thumb.jpg?1460499421"},
{:name=>"Cindy Cohn", :team=>"Executive", :title=>"Executive Director", :email=>"cindy@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/156/original/cindy-cohn_0.jpg?1460499424"},
{:name=>"Sophia Cope", :team=>"Legal", :title=>"Staff Attorney", :email=>"sophia@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/157/original/sophia_cope_thumb.jpg?1460499426"},
{:name=>"Keri Crist", :team=>"Operations", :title=>"Operations Assistant", :email=>"keri@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/158/original/scarlet-rosemallow_thumb.jpg?1460499427"},
{:name=>"Andrew Crocker", :team=>"Legal", :title=>"Staff Attorney", :email=>"andrew@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/159/original/crocker.jpg?1460499429"},
{:name=>"Joanna Cullom", :team=>"Operations", :title=>"Director of Operations", :email=>"joanna@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/160/original/joanna_0.jpg?1460499431"},
{:name=>"Caroline Bokman", :team=>"Finance/HR", :title=>"Staff Accountant", :email=>"caroline@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/147/original/cb_bls_0.jpg?1460499406"},
{:name=>"Vivian Brown", :team=>"Web Development", :title=>"Web Developer", :email=>"vivian@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/148/original/red_sweater_0.jpg?1460499408"},
{:name=>"William Budington", :team=>"Tech Projects", :title=>"Software Engineer", :email=>"bill@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/149/original/bill_budington_vert.png?1460499410"},
{:name=>"Hugh D'Andrade", :team=>"Press/Graphics", :title=>"Art Director", :email=>"hugh@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/161/original/hugh-mural-2.jpg?1460499432"},
{:name=>"Cynthia Dominguez", :team=>"Legal", :title=>"Legal Secretary", :email=>"cynthia@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/162/original/profpic.jpeg?1460499434"},
{:name=>"Peter Eckersley", :team=>"Tech Projects", :title=>"Chief Computer Scientist", :email=>"pde@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/163/original/pde-440.jpg?1460499436"},
{:name=>"Kelly Esguerra", :team=>"Finance/HR", :title=>"Finance Director", :email=>"kelly@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/164/original/img_4037.jpg?1460499438"},
{:name=>"Richard Esguerra", :team=>"Development", :title=>"Development Director", :email=>"richard@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/165/original/withstuff_square_195x195_0.jpg?1460499439"},
{:name=>"Ernesto Omar Falcon", :team=>"Legal", :title=>"Legislative Counsel", :email=>"ernesto@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/166/original/ernesto_bio_photo.png?1460499443"},
{:name=>"Eva Galperin", :team=>"International", :title=>"Global Policy Analyst", :email=>"eva@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/167/original/eva_galperin_staff_photo.jpg?1460499446"},
{:name=>"Jeremy Gillula", :team=>"Tech Projects", :title=>"Staff Technologist", :email=>"jeremy@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/168/original/jeremy.jpg?1460499448"},
{:name=>"Starchy Grant", :team=>"Tech Ops", :title=>"Systems Administrator", :email=>"starchy@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/169/original/535862_10151395213962708_1410686887_n.jpg?1460499450"},
{:name=>"David Greene", :team=>"Legal", :title=>"Civil Liberties Director", :email=>"davidg@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/170/original/green4.jpg?1460499453"},
{:name=>"Karen Gullo", :team=>"Press/Graphics", :title=>"Analyst, Media Relations Specialist", :email=>"karen@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/171/original/karen_gullo_tall.jpg?1460499455"},
{:name=>"Elliot Harmon", :team=>"Activism", :title=>"Activist", :email=>"elliot@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/172/original/elliot-mug.jpg?1460499458"},
{:name=>"Parker Higgins", :team=>"Activism", :title=>"Director of Copyright Activism", :email=>"parker@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/173/original/gph-profile-20141205.jpg?1460499460"},
{:name=>"Jacob Hoffman-Andrews", :team=>"Tech Projects", :title=>"Senior Staff Technologist", :email=>"jsha@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/174/original/jacob.jpg?1460499461"},
{:name=>"Max Hunter", :team=>"Web Development", :title=>"Web Development Team Lead", :email=>"max@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/175/original/mhunter_profile.jpg?1460499464"},
{:name=>"Mark M. Jaycox", :team=>"Legal", :title=>"Civil Liberties Legislative Lead", :email=>"jaycox@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/176/original/untitled_3_0.png?1460499468"},
{:name=>"Rebecca Jeschke", :team=>"Press/Graphics", :title=>"Media Relations Director and Digital Rights Analyst", :email=>"rebecca@eff.org", :avatar=>"https://eff-fab.s3.amazonaws.com/users/avatars/000/000/177/original/rebecca_verticalcrop.jpg?1460499472"}]
end


def get_staff_profiles()
  page = Nokogiri::HTML(open("https://www.eff.org/about/staff/"))
  profiles = page.css('.view-staff-staff-profiles-page-view .views-row')
end



def create_user_from_profile(profile)
  attrs = {}
  attrs[:name] = profile.css('h2').text.strip
  attrs[:title] = profile.css('h3').text.strip
  attrs[:email] = profile.css('.email').text.strip
  attrs[:team] = get_team(profile.css('.views-field-field-profile-team').text.strip)
  attrs[:password] = User.generate_password

  save_user(attrs)
end

def save_user(attrs)
  # Save each user and their photo.
  if not attrs[:email].blank?
    u = User.create(attrs)

    img_path = profile.css('img').attr('src').to_s
    cleaned_path = img_path.sub('staff_thumb', 'medium').split('?').first
    save_user_photo(u, cleaned_path)

    # Provide some status updates.
    puts attrs[:name]
    if u.errors.messages.count > 0
      puts u.errors.messages
    end
    return u
  end
end

def get_team(team_name)
  team_name = 'Other' if team_name.blank?

  if t = Team.find_by(name: team_name)
    return t
  else
    return Team.create(name: team_name, weight: get_weight(team_name))
  end
end

# Just going to stop my refactoring at this point now that I see what was taking place...
def save_user_photo(user, img_path)
  user.avatar = URI.parse(cleaned_path)
  user.save
end

def build_fabs(u)
  return if u.nil?

  this_monday = Fab.get_start_of_current_fab_period
  last_monday = this_monday - 7.days

  f = u.fabs.create(period: last_monday)
  f.notes.delete_all
  3.times { f.notes.create(body: "I did a thing", forward: false) }
  3.times { f.notes.create(body: "I will do a thing", forward: true) }

  f = u.fabs.create(period: this_monday)
  f.notes.delete_all
  3.times { f.notes.create(body: "I was SUPER", forward: false) }
  3.times { f.notes.create(body: "I will be more super", forward: true) }
end

def get_weight(name)
  teams_and_weight[name]
end

def teams_and_weight
  # The team names were generated via the command...
  # Team.select(:name).map {|t| t.name }.to_json
  { "Activism" => 10,
    "International" => 15,

    "Web Development" => 20,
    "Tech Projects" => 22,
    "Tech Ops" => 25,

    "Press/Graphics" => 30,

    "Legal" => 40,

    "Development" => 50,
    "Finance/HR" => 55,

    "Operations" => 60,
    "Executive" => 65,
    "Other" => 999 }
end
