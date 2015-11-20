require './lib/catalog_onliner'


describe "On1RspecWd" do

  before(:each) do
    default_profile = Selenium::WebDriver::Firefox::Profile.from_name "default"
    default_profile.native_events = true
    @driver =  Sel_drive('firefox')
    # @base_url = "http://catalog.onliner.by"
    # @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @search_params = ["Apple iPhone 6 Plus 16GB Space Gray", "Samsung Galaxy S6 edge (32GB) (G925)"]
    @email = 'test@example.com'
    @pass = '1234'
  end
  
  after(:each) do
    @driver.quit
    expect(@verification_errors).to  eq([])
  end
  
  it "test_on1_rspec_wd" do
    catalog_page = CatalogOnliner.new(@driver)
    verify { expect(catalog_page.search_product(@searh_params[0])).to eql('Смартфон Apple iPhone 6 Plus 16GB Space Gray')}
  end
  

  it "test_on2_rspec_wd" do
    catalog_page = CatalogOnliner.new(@driver)
    catalog_page.search_product(@search_params[0])
    catalog_page.default_content
    catalog_page.add_to_cart
    verify { expect(catalog_page.check_cart).to eql("1 товар") }
    catalog_page.remove_from_cart
    # @driver.find_element(:css, "input.i-checkbox__real").click
  end

  it "test_on3_rspec" do
    catalog_page = CatalogOnliner.new(@driver)
    catalog_page.search_product(@search_params[0])
    catalog_page.default_content
    catalog_page.add_to_cart
    catalog_page.search_product(@search_params[1], 5)
    catalog_page.default_content
    catalog_page.add_to_cart
    verify { expect(catalog_page.check_cart).to  eql("2 товара в сравнении") }
    catalog_page.click_link_basket
    # @driver.find_element(:css, "h1.b-offers-title").click
    verify { expect(catalog_page.get_basket_title).to  eql("Сравнение товаров") }
    catalog_page.get_basket_title
  end

  it "test_on4_rspec_wd" do
    catalog_page = CatalogOnliner.new(@driver)
    catalog_page.go_to_registration
    catalog_page.email = @email
    catalog_page.pass = '12345678'
    catalog_page.pass_conf = '12345678'
    catalog_page.registration_click
    # @driver.find_element(:xpath, "//div[@id='auth-container__forms']/div/div[2]/form/div[5]/div").click
    verify { expect(catalog_page.check_registration).to  eql("Текст, указанный на картинке, введен неверно") }
  end

  it "test_on5_rspec" do
    catalog_page = CatalogOnliner.new(@driver)
    catalog_page.go_to_authorize
    catalog_page.login =  @email
    catalog_page.sign_in
    # @driver.find_element(:xpath, "(//button[@type='submit'])[2]").click
    verify { expect(catalog_page.check_sign_in).to eql("Неверный ник или e-mail") }
  end
  
  it "test_on6" do
    catalog_page = CatalogOnliner.new(@driver)
    catalog_page.go_to_tablet
    catalog_page.click_apple
    expect(catalog_page.current_url).to match(/^[\s\S]*tabletpc\/apple\/ipadair16gbsg$/)
  end
  
  it "test_r7" do
    catalog_page = CatalogOnliner.new(@driver)
    catalog_page.goto
    catalog_page.go_to_chairs
    catalog_page.click_filters
    catalog_page.click_to_shema
    expect(catalog_page.current_url).to match(/^[\s\S]*office_chair\/metta\/lk11ch\/reviews$/)
  end

  it "test_sort_pan" do
    catalog_page = CatalogOnliner.new(@driver)
    verify { (catalog_page.check_name_pan).should == "Peterhof PH-15390" }
    catalog_page.click_shema_pun
    catalog_page.current_url.should =~ /^[\s\S]*pan\/peterhof\/ph15390$/
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    # ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @dirver.switch_to.alert
    # ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end

  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end

  def Sel_drive(drive_type)
    case drive_type
    when "firefox"
      return Selenium::WebDriver.for :firefox
    when "ie"
      return Selenium::WebDriver.for :ie
    when "chrome"
      return Selenium::WebDriver.for :chrome
    else
      puts "Not a valid driver"
    end
  end
end