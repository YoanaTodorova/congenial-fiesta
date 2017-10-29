# Computes checksum for a given string.
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

    [
      :count_of_original_words,
      :count_of_newly_created_words,
      :count_of_upper_case_vowels, :count_of_consonants,
      :length_of_original_string
    ].map { |key| [key, public_send(key)] }.to_h
  end

  WORD_REGEXP = /[a-zA-Z]+/
  CONSONANTS = 'b-df-hj-np-tv-z'.freeze
  VOWELS = 'aeiou'.freeze

  def selected_substrings_count
    -> (string, regexp) { string.scan(regexp).count }
  end

  def count_of_original_words
    selected_substrings_count.call(original_string, WORD_REGEXP)
  end

  def count_of_newly_created_words
    selected_substrings_count.call(modified_string, WORD_REGEXP)
  end

  def count_of_upper_case_vowels
    selected_substrings_count.call(modified_string, /[#{VOWELS.upcase}]/)
  end

  def count_of_consonants
    regexp = /[#{CONSONANTS}#{CONSONANTS.upcase}]/

    selected_substrings_count.call(modified_string, regexp)
  end

  def length_of_original_string
    original_string.length
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
    @modified_string = @modified_string.delete(' ')
                                       .scan(/.{1,#{word_length}}/)
                                       .join(' ')
  end

  def capitalize_each_word
    @modified_string.gsub!(/\b[a-z]/, &:upcase)
  end

  def upcase_vowel_after_consonants_and_upcase_vowel
    regexp = /(?<=[#{VOWELS.upcase}])
              (?:[^#{VOWELS}#{VOWELS.upcase}]*?)
              (?<=[#{CONSONANTS}#{CONSONANTS.upcase}]{2})([#{VOWELS}])/x

    while regexp.match @modified_string
      @modified_string.gsub!(regexp) { |match| match.gsub(/\w$/, &:upcase) }
    end

    @modified_string
  end
end
