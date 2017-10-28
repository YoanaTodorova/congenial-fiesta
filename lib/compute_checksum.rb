class ComputeChecksum
  def self.call(**args)
    new(args).call
  end

  attr_reader :original_string, :modified_string

  def initialize(string:)
    @original_string = string
    @modified_string = string.dup

    raise ArgumentError, 'Missing required argument string' unless string
  end

  def call
    apply_modifications_to_string

    {
      count_of_original_words: selected_substrings_count.call(original_string, WORD_REGEXP),
      count_of_newly_created_words: selected_substrings_count.call(modified_string, WORD_REGEXP),
      count_of_upper_case_vowels: selected_substrings_count.call(modified_string, UPPER_CASE_VOWELS_REGEXP),
      count_of_consonants: selected_substrings_count.call(modified_string, CONSONANTS_REGEXP),
      length_of_original_string: original_string.length,
    }
  end

  WORD_REGEXP = /[a-zA-Z]+/
  UPPER_CASE_VOWELS_REGEXP = /[AEIOU]/
  CONSONANTS_REGEXP = /[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]/

  def selected_substrings_count
    lambda { |string, regexp| string.scan(regexp).count }
  end

  def apply_modifications_to_string
    remove_non_english_alphabet_characters
    split_into_limited_characters_strings
    capitalize_each_word
    upcase_vowel_after_consonants_and_upcase_vowel
  end

  def remove_non_english_alphabet_characters
    @modified_string.gsub!(/[^a-zA-Z ]/, '')
  end

  def split_into_limited_characters_strings(word_length: 10)
    @modified_string = @modified_string.gsub(/ /, '').scan(/.{1,#{word_length}}/).join(' ')
  end

  def capitalize_each_word
    @modified_string.gsub!(/\b[a-z]/, &:upcase)
  end

  CONSONANTS = 'b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z'
  VOWELS = 'aeiouAEIOU'

  def upcase_vowel_after_consonants_and_upcase_vowel(number_of_preceeding_consonants: 2)
    regexp = /(?<=[AEIOU])(?:[^VOWELS]*?)(?<=[#{CONSONANTS}]{2})([aeiou])/

    while regexp.match @modified_string
      @modified_string.gsub!(regexp) { |match| match.gsub(/\w$/, &:upcase) }
    end

    @modified_string
  end
end
