module ApplicationHelper
  def partially_hidden_email(email)
    email.split('@').map do |string|
      string.split('.').map do |letters|
        partially_hidden_string(letters)
      end.join('.')
    end.join('@')
  end

  def partially_hidden_string(string)
    string.length < 3 ? string.gsub(/./, '*') : "#{string[0..1]}#{'*' * string[2..].length}"
  end
end
