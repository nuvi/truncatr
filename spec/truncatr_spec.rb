require 'spec_helper'

describe Truncatr::Client do

  LINK = "http://www.google.com"
  LOREM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  it 'does not truncate text with message length < max' do
    parts = []
    parts << LOREM[0,50]
    parts << LINK
    message = parts.join(" ")
    truncated_message = Truncatr::Client.truncate(message, 140)
    expect(truncated_message).to eq(message)
  end

  it 'truncates text with no link' do
    message = LOREM[0,250]
    truncated_message = Truncatr::Client.truncate(message, 140)
    expect(truncated_message).to eq("#{LOREM[0, 137]}...")
  end

  it 'truncates text with link at end' do
    parts = []
    parts << LOREM[0,130]
    parts << LINK
    message = parts.join(" ")
    truncated_message = Truncatr::Client.truncate(message, 140)
    expect(truncated_message).to eq("#{LOREM[0, 114]}... #{LINK}")
  end

  it 'truncates text with two links at end drops last link' do
    parts = []
    parts << LOREM[0,100].strip
    parts << LINK
    parts << LINK
    message = parts.join(" ")
    truncated_message = Truncatr::Client.truncate(message, 140)
    expect(truncated_message).to eq("#{LOREM[0, 100].strip} #{LINK}")
  end

  it 'truncates text with link in the middle' do
    message = "Over this weekend, I spent a few hours using http://c9.io and am very pleased. Rails development on windows became possible, simple, and enjoyable!"
    truncated_message = Truncatr::Client.truncate(message, 140)
    expect(truncated_message).to eq("#{LOREM[0,100].strip} http://www.google.com #{LOREM[0,15].strip}...")
  end

  it 'drops final link with link at end of links and text' do
    parts = []
    parts << LOREM[0,50].strip
    parts << "http://www.google.com"
    parts << LOREM[51,50].strip
    parts << "http://www.google.com"
    parts << LOREM[101,50].strip
    message = parts.join(" ")
    truncated_message = Truncatr::Client.truncate(message, 140)
    expect(truncated_message).to eq("#{LOREM[0,50].strip} http://www.google.com #{LOREM[51,38].strip} ... http://www.google.com")
  end
end
