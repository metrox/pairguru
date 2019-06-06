class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    title = record.title

    if title.count("(") != title.count(")") || title =~ regexp
      record.errors[:title] << "invalid amount/order of brackets"
    end
  end

  private

  def regexp
    /^(?:.*?\[(?!.*?\])[^\]]*|[^\[\r\n]*\].*?|.*?\((?!.*?\))[^)]*|[^(\r\n]*\).*?)|\(\)$/i
  end
end
