class Public::FaqsController < ApplicationController
  def index
    @faqs = Faq.all.order(created_at: :desc)
  end
end
