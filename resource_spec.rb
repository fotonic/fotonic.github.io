require 'rails_helper'

describe ResourceCenter::Resource, type: :model do

  after(:each) do
    FileUtils.rm_r(Dir.glob(Rails.root.join("public/api/v1/test/resources/*")))
  end
  before(:each) do
    Setting.create name: 'cut_off_age', value: '90'
  end

  describe "model attributes" do
    # Accessible Attributes
    context "fields" do
      it { should respond_to(:title) }
      it { should respond_to(:description) }
      it { should respond_to(:author) }
      it { should respond_to(:start_date) }
      it { should respond_to(:end_date) }
      it { should respond_to(:duration)}
      it { should respond_to(:file) }
      it { should respond_to(:searchable) }
      it { should respond_to(:tags) }
      it { should respond_to(:categorizations) }
      it { should respond_to(:status) }
      it { should respond_to(:status_date) }
      it { should respond_to(:featured) }
      it { should respond_to(:deleted) }
      it { should respond_to(:published) }
      it { should respond_to(:confidential) }
      it { should respond_to(:duration) }
    end

    # Validations
    context "validations" do
      let(:resource) { FactoryGirl.create(:resource_center_resource) }
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:start_date) }
      it { should validate_presence_of(:status) }
      it { expect(resource).to validate_uniqueness_of(:title).case_insensitive }
    end

    # Associations
    context "association" do
      # LMS
      it { should have_many(:course_activities) }
      it { should have_many(:courses).through(:course_activities) }

      # Comments
      it { should have_many(:comments)}

      # Categorizations
      it { should have_many(:resource_cats).dependent(:destroy)}
      it { should have_many(:categorizations).through(:resource_cats) }

      # Tags
      it { should have_many(:resource_tags).dependent(:destroy) }
      it { should have_many(:tags).through(:resource_tags) }

      # Views
      it { should have_many(:view_tracking).dependent(:destroy) }
      it { should have_many(:views).through(:view_tracking) }

      # Downloads
      it { should have_many(:download_tracking).dependent(:destroy) }
      it { should have_many(:downloads).through(:download_tracking) }

      # Ratings
      it { should have_many(:ratings).dependent(:destroy)}

      # Created by User
      it { should belong_to(:author) }

      # Ratings
      it { should have_many(:links) }

      # Comments
      it { should have_many(:comments).dependent(:destroy) }

      # User Principals
      it { should have_many(:user_principal_entries).dependent(:destroy)}
      it { should have_many(:user_principals).through(:user_principal_entries) }

      # Group Principals
      it { should have_many(:group_principal_entries).dependent(:destroy)}
      it { should have_many(:group_principals).through(:group_principal_entries) }
    end
  end

  context "Linking" do
    it "Saving Links" do
      user      = FactoryGirl.create(:user, email: 'unique@domain.com')
      resource  = FactoryGirl.create(:resource_center_resource, author: user)
      resource2 = FactoryGirl.create(:resource_center_resource, author: user)
      resource3 = FactoryGirl.create(:resource_center_resource, author: user)

      resource.links = [resource2, resource3]
      resource.save
    end
    it "Resource.links" do
      user      = FactoryGirl.create(:user, email: 'unique@domain.com')
      resource2 = FactoryGirl.create(:resource_center_resource, author: user)
      resource3 = FactoryGirl.create(:resource_center_resource, author: user)
      resource  = FactoryGirl.create(:resource_center_resource, author: user, links: [resource2, resource3])

      resource.links.to_a.should == [resource2, resource3]
    end
  end

  context "Sharing" do
    let!(:from_email_setting) {FactoryGirl.create(:setting, name: 'from_email', value: 'email@example.com')}
    it "Should recieve email" do
      user     = FactoryGirl.create(:user, email: 'unique@domain.com')
      resource = FactoryGirl.create(:resource_center_resource, author: user)
      message  = FactoryGirl.create(:setting, name: 'resource_share_message', value: 'Hey!<br/><br/>Thought you would like this Resource.<br/><br/>Enjoy!')
      reset_email
      resource.share(user, ["mlynch@topgunhq.com","test@user.com"],"huh", user)

      # Verify email delivered and it was delivered to the correct person
      email_count == 1
      last_email.to == "test@user.com"
    end
  end

  describe "Paperclip" do
    let!(:user_one)    { FactoryGirl.create(:user, email: 'unique@domain.com') }
    let(:resource_pdf) { FactoryGirl.create(:resource_center_resource, author: user_one) }
    let(:resource_jpg) { FactoryGirl.create(:resource_center_resource, file: File.new("#{Rails.root}/spec/fixtures/photo.jpg"),  author: user_one) }
    # let(:resource_avi) { FactoryGirl.create(:resource_center_resource, file: File.new("#{Rails.root}/spec/fixtures/sample.avi"), author: user_one) }

    it "Resource should contain attachment" do
      expect(resource_jpg.file_file_name).to eq("photo.jpg")
    end

    it "Resource should contain file previews for PDF" do
      expect(resource_pdf.file.url(:preview)).to include("preview.jpg")
    end

    it "Resource should contain file previews for JPEG" do
      expect(resource_jpg.file.url(:preview)).to include("preview.jpg")
    end

    # Temporarily remove AVI Thumbnail Test as it fails on TravisCI due to lack of FFMpeg Support
    # it "Resource should contain file previews for AVI" do
    #   expect(resource_avi.file.url(:preview)).to include("preview.jpg")
    # end
  end

  # context "Workflow" do
  #   let!(:user)     { FactoryGirl.create(:user) }
  #   let!(:resource) { FactoryGirl.create(:resource_center_resource, status: 'pending', author: user, created_at: 4.days.ago) }
  #   let!(:from_email_setting) {FactoryGirl.create(:setting, name: 'from_email', value: 'email@example.com')}
  #
  #   it "Pending -> Approved" do
  #     resource.approve!
  #     resource.status.should == 'approved'
  #   end
  #   it "Pending -> Declined" do
  #     resource.decline!
  #     resource.status.should == 'declined'
  #   end
  #   it "Approved -> Pending" do
  #     resource.approve!
  #     resource.pending!
  #     resource.status.should == 'pending'
  #   end
  #   it "Declined -> Pending" do
  #
  #     resource.decline!
  #     resource.pending!
  #     resource.status.should == 'pending'
  #   end
  #
  #   context "#process_state" do
  #     it "should approve the status" do
  #       resource.status == 'pending'
  #       expect(resource.approve!).to eql(true)
  #     end
  #   end
  #
  #   context "#delete!" do
  #     it "should set deleted to false" do
  #       resource_deleted = FactoryGirl.create(:resource_center_resource, deleted: true)
  #       resource_deleted.delete!
  #       expect(resource_deleted.deleted).to eql(false)
  #     end
  #
  #     it "should set deleted to true" do
  #       resource_undeleted = FactoryGirl.create(:resource_center_resource, deleted: false)
  #       resource_undeleted.delete!
  #       expect(resource_undeleted.deleted).to eql(true)
  #     end
  #   end
  #
  #   context "#feature!" do
  #     it "should set featured to false" do
  #       resource_featured = FactoryGirl.create(:resource_center_resource, featured: true)
  #       resource_featured.feature!
  #       expect(resource_featured.featured).to eql(false)
  #     end
  #
  #     it "should set featured to true" do
  #       resource_unfeatured = FactoryGirl.create(:resource_center_resource, featured: false)
  #       resource_unfeatured.feature!
  #       expect(resource_unfeatured.featured).to eql(true)
  #     end
  #   end
  #
  #   context "#unpublish! && #publish!" do
  #     it "should set published to false" do
  #       resource_published = FactoryGirl.create(:resource_center_resource, published: true)
  #       resource_published.unpublish!
  #       expect(resource_published.published).to eql(false)
  #     end
  #
  #     it "should set published to true" do
  #       resource_unpublished = FactoryGirl.create(:resource_center_resource, published: false)
  #       resource_unpublished.publish!
  #       expect(resource_unpublished.published).to eql(true)
  #     end
  #   end
  #
  #   context "#descriptive_status" do
  #     it "should return status Approved" do
  #       approved = FactoryGirl.create(:resource_center_resource)
  #       approved.start_date = 1.day.from_now
  #
  #       expect(approved.descriptive_status).to eql("Approved")
  #     end
  #
  #     it "should return status Archived" do
  #       archived = FactoryGirl.create(:resource_center_resource)
  #       archived.end_date = 1.day.ago
  #
  #       expect(archived.descriptive_status).to eql("Archived")
  #     end
  #
  #     it "should return status Live" do
  #       live = FactoryGirl.create(:resource_center_resource)
  #       live.start_date = Time.now
  #
  #       expect(live.descriptive_status).to eql("Live")
  #     end
  #
  #     it "should return status Rejected" do
  #       rejected = FactoryGirl.create(:resource_center_resource, status: "declined")
  #
  #       expect(rejected.descriptive_status).to eql("Rejected")
  #     end
  #
  #     it "should return status Pending" do
  #       expect(resource.descriptive_status).to eql("Pending")
  #     end
  #   end
  #
  #   context "categories" do
  #
  #     it "should return the categories of the resource" do
  #       cat_group = FactoryGirl.create(:resource_center_categorization_group, name: "Cat Group")
  #       cat1 = FactoryGirl.create(:resource_center_categorization, name: 'catty', categorization_group_id: cat_group.id)
  #       cat2 = FactoryGirl.create(:resource_center_categorization, name: 'catty2', categorization_group_id: cat_group.id)
  #
  #       resource.categorizations.push(cat1, cat2)
  #
  #       expect(resource.categories).to match_array(["name"=>cat_group.name, "list"=> [cat1, cat2]])
  #     end
  #   end
  #
  #   context "build_tags" do
  #     it "should build tags" do
  #       ResourceCenter::Resource.build_tags(["intern_tag1"])
  #       built_tag = Core::Tag.find_by(name: "intern_tag1")
  #       expect(built_tag).not_to eql(nil)
  #     end
  #   end
  #
  #   context "associations that have dependent: :destroy" do
  #     it "should remove all assoiciations" do
  #       tag = FactoryGirl.create(:tag, name: 'robot')
  #       cat_group = FactoryGirl.create(:resource_center_categorization_group, name: "Cat Group")
  #       cat1 = FactoryGirl.create(:resource_center_categorization, name: 'catty', categorization_group_id: cat_group.id)
  #       resource_view = FactoryGirl.create(:resource_center_view_tracking, user: user, resource: resource)
  #       comment = FactoryGirl.create(:resource_center_comment, body: "foo bar", user: user, resource: resource)
  #       rating = FactoryGirl.create(:resource_center_rating, user: user, resource: resource)
  #       download_tracking = FactoryGirl.create(:resource_center_download_tracking, user: user, resource: resource)
  #       user_group = FactoryGirl.create(:user_group, user_id: user.id)
  #       resource_group_principals = FactoryGirl.create(:resource_group_principals, user_group_id: user_group.id, resource_id: resource.id)
  #       resource_user_principals = FactoryGirl.create(:resource_user_principals, user_id: user.id, resource_id: resource.id)
  #
  #       resource.categorizations.push(cat1)
  #       resource.tags.push(tag)
  #
  #       expect(resource.categories).to match_array(["name"=>cat_group.name, "list"=> [cat1]])
  #       expect(resource.tags).to match_array([tag])
  #       expect(resource.view_tracking).to match_array([resource_view])
  #       expect(resource.comments).to match_array([comment])
  #       expect(resource.ratings).to match_array([rating])
  #       expect(resource.download_tracking).to match_array([download_tracking])
  #       expect(resource.group_principal_entries).to match_array([resource_group_principals])
  #       expect(resource.user_principal_entries).to match_array([resource_user_principals])
  #
  #       resource.destroy
  #
  #       expect(ResourceCenter::ResourceCat.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::ResourceTag.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::ViewTracking.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::Comment.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::Rating.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::DownloadTracking.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::ResourceGroupPrincipal.find_by(resource_id: resource.id)).to eql(nil)
  #       expect(ResourceCenter::ResourceUserPrincipal.find_by(resource_id: resource.id)).to eql(nil)
  #     end
  #   end
  # end

  describe "Scopes / Associations / Search" do
    # context "Searching" do
    #   it "Term" do
    #     user         = FactoryGirl.create(:user, email: 'trandz@domain.com', first_name: 'Timz', last_name: 'Randz') # Used name that would never conflict with Faker
    #     user_two     = FactoryGirl.create(:user, email: 'uniq@domain.com')
    #     tag          = FactoryGirl.create(:tag, name: 'robot')
    #     resource_one = FactoryGirl.create(:resource_center_resource, title: "foo", description: "awesome", tags: [tag], author: user, created_at: 4.days.ago)
    #     resource_two = FactoryGirl.create(:resource_center_resource, title: "bar", description: "woot", file: File.new("#{Rails.root}/spec/fixtures/photo.jpg"), author: user_two, created_at: 2.days.ago)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({term: 'foo'},                      user, 'start_date', 'desc').results.to_a.should == [resource_one] # Title
    #     ResourceCenter::Resource.full_search({term: 'foo', search_on: 'title'},  user, 'start_date', 'desc').results.to_a.should == [resource_one] # Title (Searching On: Title)
    #     ResourceCenter::Resource.full_search({term: 'tap', search_on: 'title'},  user, 'start_date', 'desc').results.to_a.should == []             # Title (Searching On: Title)
    #     ResourceCenter::Resource.full_search({term: 'foo', search_on: 'author'}, user, 'start_date', 'desc').results.to_a.should == []             # Title (Searching On: Author)
    #     ResourceCenter::Resource.full_search({term: 'awesome'},                  user, 'start_date', 'desc').results.to_a.should == [resource_one] # Description
    #     ResourceCenter::Resource.full_search({term: 'robot'},                    user, 'start_date', 'desc').results.to_a.should == [resource_one] # Tag
    #     ResourceCenter::Resource.full_search({term: 'generic'},                  user, 'start_date', 'desc').results.to_a.should == [resource_one] # File (field: Searchable)
    #     ResourceCenter::Resource.full_search({term: 'photo'},                    user, 'start_date', 'desc').results.to_a.should == [resource_two] # File (field: Searchable)
    #     ResourceCenter::Resource.full_search({term: 'Timz Randz', search_on: 'author'},        user, 'start_date', 'desc').results.to_a.should == [resource_one] # Author Name
    #     ResourceCenter::Resource.full_search({term: 'trandz@domain.com', search_on: 'author'}, user, 'start_date', 'desc').results.to_a.should == [resource_one] # Author Email
    #   end
    #   it "Deleted" do
    #     user         = FactoryGirl.create(:user)
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user, deleted: true)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({}, user, 'start_date', 'desc').results.to_a.should == [resource_one]
    #   end
    #   it "Archived" do
    #     user         = FactoryGirl.create(:user)
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user, start_date: 2.days.ago)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user, start_date: 4.days.ago, end_date: Date.yesterday)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({archived: 'none'}, user, 'start_date', 'desc').results.to_a.should == [resource_one]
    #     ResourceCenter::Resource.full_search({archived: 'include'}, user, 'start_date', 'desc').results.to_a.should == [resource_one, resource_two]
    #   end
    #   it "Start Date" do
    #     user         = FactoryGirl.create(:user)
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user, start_date: 2.months.ago)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user, start_date: 4.months.ago)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({pub_date: 3}, user, 'start_date', 'desc').results.to_a.should == [resource_one]
    #   end
    #   it "Tags" do
    #     user         = FactoryGirl.create(:user)
    #     robot        = FactoryGirl.create(:tag, name: 'robot')
    #     human        = FactoryGirl.create(:tag, name: 'human')
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user, tags: [robot], start_date: 2.days.ago)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user, tags: [human], start_date: 4.days.ago)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({tags: [robot.id]}, user, 'start_date', 'desc').results.to_a.should == [resource_one]
    #     ResourceCenter::Resource.full_search({tags: [human.id]}, user, 'start_date', 'desc').results.to_a.should == [resource_two]
    #   end
    #   it "Title" do
    #     user = FactoryGirl.create(:user)
    #     a    = FactoryGirl.create(:resource_center_resource, author: user, title: 'a')
    #     b    = FactoryGirl.create(:resource_center_resource, author: user, title: 'b')
    #     c    = FactoryGirl.create(:resource_center_resource, author: user, title: 'c')
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({}, user, 'title', 'asc').results.to_a.should  == [a,b,c]
    #     ResourceCenter::Resource.full_search({}, user, 'title', 'desc').results.to_a.should == [c,b,a]
    #   end
    # end

    # context "Status" do
    #   let!(:user)        { FactoryGirl.create(:user) }
    #   let!(:resource_one) { FactoryGirl.create(:resource_center_resource, status: 'pending', author: user, created_at: 4.days.ago, start_date: 4.days.ago) }
    #   let!(:resource_two) { FactoryGirl.create(:resource_center_resource, status: 'approved', author: user, created_at: 2.days.ago, start_date: 2.days.ago) }
    #   let!(:resource_thr) { FactoryGirl.create(:resource_center_resource, status: 'declined', author: user) }
    #
    #   it "Searching by Status" do
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({}, user, 'start_date', 'desc').results.to_a.should == [resource_two]
    #     ResourceCenter::Resource.full_search({status: 'pending'},  user, 'start_date', 'desc').results.to_a.should == [resource_one]
    #     ResourceCenter::Resource.full_search({status: 'declined'}, user, 'start_date', 'desc').results.to_a.should == [resource_thr]
    #   end
    # end
    # context "Featured" do
    #   it "Searching Featured" do
    #     user         = FactoryGirl.create(:user)
    #     not_featured = FactoryGirl.create(:resource_center_resource, featured: false, author: user)
    #     featured_one = FactoryGirl.create(:resource_center_resource, featured: true,  author: user, start_date: 2.days.ago)
    #     featured_two = FactoryGirl.create(:resource_center_resource, featured: true,  author: user, start_date: 4.days.ago)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({filter: 'featured'}, user, 'start_date', 'desc').results.to_a.should == [featured_one, featured_two]
    #   end
    # end
    # context "Authoring" do
    #   it "Searching by Author" do
    #     author_one   = FactoryGirl.create(:user)
    #     author_two   = FactoryGirl.create(:user, email: 'unique@domain.com')
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: author_one)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: author_two)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({author: author_one.id}, author_one, 'start_date', 'desc').results.to_a.should == [resource_one]
    #     ResourceCenter::Resource.full_search({author: author_two.id}, author_one, 'start_date', 'desc').results.to_a.should == [resource_two]
    #   end
    # end
    # context "Downloads" do
    #   it "Resource.downloads" do
    #     user_one     = FactoryGirl.create(:user)
    #     user_two     = FactoryGirl.create(:user, email: 'unique@domain.com')
    #     resource     = FactoryGirl.create(:resource_center_resource, author: user_one)
    #     download_one = FactoryGirl.create(:resource_center_download_tracking, resource: resource, user: user_one)
    #     download_two = FactoryGirl.create(:resource_center_download_tracking, resource: resource, user: user_one, created_at: 60.days.ago)
    #     download_thr = FactoryGirl.create(:resource_center_download_tracking, resource: resource, user: user_two, created_at: 120.days.ago)
    #
    #     expect(resource.downloads.to_a).to match_array([user_one, user_two])
    #     resource.downloads.to_a.count.should == 2
    #   end
    #   it "Searching: Sort by Number of Downloads" do
    #     user_one     = FactoryGirl.create(:user)
    #     user_two     = FactoryGirl.create(:user, email: 'unique@domain.com')
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user_one)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user_two)
    #     download_one = FactoryGirl.create(:resource_center_download_tracking, resource: resource_one, user: user_one)
    #     download_two = FactoryGirl.create(:resource_center_download_tracking, resource: resource_one, user: user_two)
    #     download_thr = FactoryGirl.create(:resource_center_download_tracking, resource: resource_two, user: user_one)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({}, user_one, 'num_downloads', 'desc').results.to_a.should == [resource_one, resource_two]
    #     ResourceCenter::Resource.full_search({}, user_one, 'num_downloads', 'asc').results.to_a.should  == [resource_two, resource_one]
    #   end
    #   it "Searching: My Downloads" do
    #     user_one     = FactoryGirl.create(:user)
    #     user_two     = FactoryGirl.create(:user, email: 'unique@domain.com')
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user_one, start_date: 1.day.ago )
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user_two, start_date: 2.days.ago)
    #     download_one = FactoryGirl.create(:resource_center_download_tracking, resource: resource_one, user: user_one)
    #     download_two = FactoryGirl.create(:resource_center_download_tracking, resource: resource_one, user: user_two)
    #     download_thr = FactoryGirl.create(:resource_center_download_tracking, resource: resource_two, user: user_one)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({filter: 'downloaded'}, user_one, 'start_date', 'desc').results.to_a.should == [resource_one, resource_two]
    #     ResourceCenter::Resource.full_search({filter: 'downloaded'}, user_two, 'start_date', 'desc').results.to_a.should  == [resource_one]
    #   end
    # end
    # context "Rating" do
    #   it "Resource.rating" do
    #     user_one     = FactoryGirl.create(:user, email: 'unique@domain.com')
    #     user_two     = FactoryGirl.create(:user, email: 'unique2@domain.com')
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user_one)
    #     rating_one   = FactoryGirl.create(:resource_center_rating, resource: resource_one, user: user_one, rating: 4)
    #     rating_two   = FactoryGirl.create(:resource_center_rating, resource: resource_one, user: user_two, rating: 3)
    #
    #     rating = resource_one.rating(user_one.id)
    #     expect(rating[:mine]).to eq(4)
    #     expect(rating[:average]).to eq(3.5)
    #   end
    #   it "Searching: Sort by Average Rating" do
    #     user_one     = FactoryGirl.create(:user, email: 'unique@domain.com')
    #     user_two     = FactoryGirl.create(:user, email: 'unique2@domain.com')
    #     resource_one = FactoryGirl.create(:resource_center_resource, author: user_one, created_at: 20.seconds.ago)
    #     resource_two = FactoryGirl.create(:resource_center_resource, author: user_one, created_at: 15.seconds.ago)
    #     resource_thr = FactoryGirl.create(:resource_center_resource, author: user_one, created_at: 10.seconds.ago)
    #     resource_fou = FactoryGirl.create(:resource_center_resource, author: user_one, created_at: 5.seconds.ago)
    #     rating_one   = FactoryGirl.create(:resource_center_rating, resource: resource_one, user: user_one, rating: 4)
    #     rating_two   = FactoryGirl.create(:resource_center_rating, resource: resource_one, user: user_two, rating: 5)
    #     rating_thr   = FactoryGirl.create(:resource_center_rating, resource: resource_thr, user: user_one, rating: 4)
    #     rating_fou   = FactoryGirl.create(:resource_center_rating, resource: resource_thr, user: user_two, rating: 4)
    #
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({}, user_one, 'average_rating', 'desc').results.to_a.should == [resource_one, resource_thr, resource_fou, resource_two] # 4.5, 4, nil, nil
    #     ResourceCenter::Resource.full_search({}, user_one, 'average_rating', 'asc').results.to_a.should ==  [resource_two, resource_fou, resource_thr, resource_one] # nil, nil, 4, 4.5
    #   end
    # end
    # context "Time" do
    #   let!(:test_user)    { FactoryGirl.create(:user) }
    #   let(:resource)      { FactoryGirl.create(:resource_center_resource, author: test_user, end_date: Date.tomorrow) }
    #   let!(:resource_exp)  { FactoryGirl.create(:resource_center_resource, author: test_user, end_date: 3.days.ago) }
    #   let!(:resource_act)  { FactoryGirl.create(:resource_center_resource, author: test_user, end_date: Date.tomorrow) }
    #
    #   it "Resource.archive!" do
    #     resource.archive!(test_user)
    #     expect([resource_exp, resource]).to match_array(ResourceCenter::Resource.where("end_date <= ?", Time.now).to_a)
    #   end
    #   it "Searching with expired" do
    #     ResourceCenter::Resource.reindex
    #     ResourceCenter::Resource.full_search({archived: 'none'}, test_user, 'end_date', 'desc').results.to_a.should == [resource_act]
    #     ResourceCenter::Resource.full_search({archived: 'include'}, test_user, 'end_date', 'desc').results.to_a.should == [resource_act, resource_exp]
    #   end
    # end
  end
end
