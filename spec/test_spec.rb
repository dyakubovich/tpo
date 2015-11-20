
describe "On1RspecWd" do

  before(:each) do
    default_profile = Selenium::WebDriver::Firefox::Profile.from_name "default"
    default_profile.native_events = true
    @driver =  Sel_drive('firefox')
    @base_url = "http://catalog.onliner.by"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @searh_params = ["Apple iPhone 6 Plus 16GB Space Gray", "Samsung Galaxy S6 edge (32GB) (G925)"]
    @email = 'test@example.com'
    @pass = '1234'
  end
  
  after(:each) do
    @driver.quit
    expect(@driver.verification_errors).to  eq([])
  end
  
  it "test_on1_rspec_wd" do
    @driver.get(@base_url + "/")

    @driver.find_element(:name, "query").clear
    @driver.find_element(:name, "query").send_keys @searh_params[0]
    sleep(3)
    @driver.switch_to.frame @driver.find_elements(:tag_name, "iframe")[0]
    @driver.find_element(:link, @searh_params[0]).click
    @driver.switch_to.default_content
    verify { (expect(@driver.find_element(:css, "h2.catalog-masthead__title").text)).to  eql('Смартфон Apple iPhone 6 Plus 16GB Space Gray') }
  end
  

  it "test_on2_rspec_wd" do
    @driver.get(@base_url + "/")
    @driver.find_element(:css, "div.g-top-i").click
    @driver.find_element(:name, "query").clear
    @driver.find_element(:name, "query").send_keys @searh_params[0]
    @driver.switch_to.frame @driver.find_elements(:tag_name, "iframe")[0]
    @driver.find_element(:link, @searh_params[0]).click
    @driver.switch_to.default_content
    @driver.find_element(:css, "span.i-checkbox__faux").click
    verify { expect(@driver.find_element(:css, "a.compare-button__sub.compare-button__sub_main > span").text).to eql("1 товар") }
    @driver.find_element(:css, "input.i-checkbox__real").click
  end

  it "test_on3_rspec" do
    @driver.get(@base_url + "/")
    @driver.find_element(:name, "query").clear
    @driver.find_element(:name, "query").send_keys @searh_params[0]
    @driver.switch_to.frame @driver.find_elements(:tag_name, "iframe")[0]
    @driver.find_element(:link, @searh_params[0]).click
    @driver.switch_to.default_content
    @driver.find_element(:css, "span.i-checkbox__faux").click
    @driver.find_element(:name, "query").clear
    @driver.find_element(:name, "query").send_keys @searh_params[1]
    @driver.switch_to.frame @driver.find_elements(:tag_name, "iframe")[5]
    @driver.find_element(:link, @searh_params[1]).click
    @driver.switch_to.default_content
    @driver.find_element(:css, "span.i-checkbox__faux").click
    verify { expect(@driver.find_element(:link, "2 товара в сравнении").text).to  eql("2 товара в сравнении") }
    @driver.find_element(:link, "2 товара в сравнении").click
    @driver.find_element(:css, "h1.b-offers-title").click
    verify { expect(@driver.find_element(:css, "h1.b-offers-title").text).to  eql("Сравнение товаров") }
    @driver.find_element(:link, "Очистить сравнение").click
  end

  it "test_on4_rspec_wd" do
    @driver.get(@base_url + "/")
    @driver.find_element(:css, "div.auth-bar__item.auth-bar__item--text").click
    @driver.find_element(:xpath, "//div[@id='auth-container__forms']/div/div/div[2]").click
    @driver.find_element(:css, "div.auth-box__part.is-active > div.auth-box__line > input.auth-box__input").clear
    @driver.find_element(:css, "div.auth-box__part.is-active > div.auth-box__line > input.auth-box__input").send_keys @email
    @driver.find_element(:xpath, "(//input[@type='password'])[2]").clear
    @driver.find_element(:xpath, "(//input[@type='password'])[2]").send_keys "12345678"
    @driver.find_element(:xpath, "(//input[@type='password'])[3]").clear
    @driver.find_element(:xpath, "(//input[@type='password'])[3]").send_keys "12345678"
    @driver.find_element(:xpath, "(//button[@type='submit'])[3]").click
    @driver.find_element(:xpath, "//div[@id='auth-container__forms']/div/div[2]/form/div[5]/div").click
    verify { expect(@driver.find_element(:xpath, "//div[@id='auth-container__forms']/div/div[2]/form/div[5]/div").text).to  eql("Текст, указанный на картинке, введен неверно") }
  end

  it "test_on5_rspec" do
    @driver.get(@base_url + "/")
    @driver.find_element(:css, "div.auth-bar__item.auth-bar__item--text").click
    @driver.find_element(:css, "input.auth-box__input").clear
    @driver.find_element(:css, "input.auth-box__input").send_keys "test@example.com"
    @driver.find_element(:xpath, "(//button[@type='submit'])[2]").click
    verify { expect(@driver.find_element(:xpath, "//div[@id='auth-container__forms']/div/div[2]/form/div[4]/div").text).to eql("Неверный ник или e-mail") }
  end
  
  it "test_on6" do
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Планшеты").click
    @driver.find_element(:xpath, "//input[@value='apple']").click
    @driver.find_element(:css, "div.schema-product__title > a > span").click
    expect(@driver.current_url).to match(/^[\s\S]*tabletpc\/apple\/ipadair16gbsg$/)
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