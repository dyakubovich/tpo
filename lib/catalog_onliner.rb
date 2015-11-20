require 'page-object'
require 'selenium-webdriver'

class CatalogOnliner
  include PageObject

  page_url('http://catalog.onliner.by')

  text_field(:search, name: 'query')
  checkbox(:add_to_cart, class: 'i-checkbox__faux')
  link(:click_basket, name: '2 товара в сравнении')
  link(:destroy_compare, name: 'Очистить сравнение')
  link(:tablet, name: 'Планшеты')
  text_field(:email, css: "div.auth-box__part.is-active > div.auth-box__line > input.auth-box__input")
  text_field(:pass, xpath: "(//input[@type='password'])[2]")
  text_field(:pass_conf, xpath: "(//input[@type='password'])[3]")
  text_field(:login, css: "input.auth-box__input")
  button(:sign_in, xpath: "(//button[@type='submit'])[2]")


  def search_product(product, frame = 0)
    @browser.get('http://catalog.onliner.by')
    self.search = product
    @browser.switch_to.frame @browser.find_elements(:tag_name, "iframe")[0]
    @browser.find_element(:link, product).click
    @browser.switch_to.default_content
    @browser.find_element(:css, "h2.catalog-masthead__title").text
  end

  def current_url
    @browser.current_url
  end

  def get_name_chairs
    @browser.find_element(:css, "div.schema-product__title > a > span").text
  end

  def click_shema_pun
    @browser.find_element(:css, "div.schema-product__title > a > span").click
  end

  def check_name_pan
    @browser.get('http://catalog.onliner.by')
    @browser.find_element(:css, "div.widget-118 > a.b-tile-main").click
    @browser.find_element(:css, "span.schema-order__text").click
    @browser.find_element(:xpath, "//div[@id='schema-order']/div/div/div[2]/span").click
    @browser.find_element(:css, "div.schema-product__title > a > span").text
  end

  def click_to_shema
    @browser.find_element(:xpath, "//div[@id='schema-products']/div/div/div[2]/div[2]/div[3]/div/a/span[2]/span[2]").click
  end

  def go_to_tablet
    @browser.get('http://catalog.onliner.by')
    @browser.find_element(:link, "Планшеты").click
  end

  def  click_filters
    @browser.find_element(:css, "span.i-checkbox__faux").click
    @browser.find_element(:css, "input.i-checkbox__real").click
  end

  def go_to_chairs
    @browser.find_element(:xpath, "//div[@id='container']/div/div[2]/div/div/div/ul/li[6]/span").click
    @browser.find_element(:link, "Офисные кресла и стулья").click
  end

  def check_sign_in
    @browser.find_element(:xpath, "//div[@id='auth-container__forms']/div/div[2]/form/div[4]/div").text
  end

  def click_apple
    @browser.find_element(:xpath, "//input[@value='apple']").click
    @browser.find_element(:css, "div.schema-product__title > a > span").click
  end

  def check_registration
    @browser.find_element(:xpath, "//div[@id='auth-container__forms']/div/div[2]/form/div[5]/div").text
  end

  def default_content
    @browser.switch_to.default_content
  end

  def registration_click
    @browser.find_element(:xpath, "(//button[@type='submit'])[3]").click
  end

  def go_to_registration
    @browser.get('http://catalog.onliner.by')
    @browser.find_element(:css, "div.auth-bar__item.auth-bar__item--text").click
    @browser.find_element(:xpath, "//div[@id='auth-container__forms']/div/div/div[2]").click
  end

  def go_to_authorize
    @browser.get('http://catalog.onliner.by')
    @browser.find_element(:css, "div.auth-bar__item.auth-bar__item--text").click
  end

  def add_to_cart
    check_add_to_cart
  end

  def remove_from_cart
    uncheck_add_to_cart
  end

  def click_link_basket
    @browser.find_element(:link, "2 товара в сравнении").click 
  end

  def click_destroyr_compare
    @browser.find_element(:link, "Очистить сравнение").click
  end

  def get_basket_title
    @browser.find_element(:css, "h1.b-offers-title").text
  end

  def check_cart
    @browser.find_element(:link, "2 товара в сравнении").text
  end

end
