# coding: utf-8

class NUMPRE
  ROWS  = 9
  COLS  = 9
  BLOCK_ROWS = 3
  BLOCK_COLS = 3
  CELLS = ROWS * COLS
  NUMBERS  = 9
  BLANK = 0

  def initialize(data)
    @error = 0
    @out = Time.now + 1
    f = open(data,"r:utf-8").read.strip!
    data = f.split("").delete_if{|a| a == "\n"}.map{|a| a.to_i} unless f.nil?
    if !data.nil? && data.count == 81
      solve(data, 0)
      anwer_file
    else
      error_write
    end
  end
  
  # コンソールへ表示&テキストへ出力
  def display_and_output(data)
    File.open("./texts/answer.txt", "w") {|file|
      CELLS.times { |i|
        file.write(data[i])
        print(data[i])
        if i % NUMBERS == NUMBERS - 1
          file.write("\n")
          print("\n")
        end
      }
      print("\n")
    }
  end
  
  def anwer_file
    f = open("./texts/answer.txt","r:utf-8").read.strip!
    answer_data = f.split("").delete_if{|a| a == "\n"}.map{|a| a.to_i} unless f.nil?
    if answer_data.nil?
      error_write
    elsif answer_data.count != 81
      error_write
    else
      if file_check(answer_data, 0)
        error_write
      end
    end
  end
  
  def file_check(data, number)
    if data.include?(0)
      @error += 1
    end
    if data[number] != BLANK
      (1..9).each{ |a|
        unless overlap?(data, number, a)
          @error += 1
        end
      }
    end
    if @error > 0
      true
    end
  end
  
  def error_write
    File.open("./texts/answer.txt", "w") {|file|
      file.write("NOT ANSWER")
    }
  end
  
  # 数字重複チェック
  def overlap?(data, number_c, number_r)
    col = number_c % COLS
    ROWS.times{ |a| return true if data[col + a * COLS] == number_r }
    row = number_c / COLS
    COLS.times{ |b| return true if data[b + row * COLS] == number_r }
    block_row = (row / BLOCK_ROWS) * BLOCK_ROWS
    block_col = (col / BLOCK_COLS) * BLOCK_COLS
    BLOCK_ROWS.times{ |a|
      BLOCK_COLS.times{ |b|
        return true if data[(block_col + b)+(block_row + a) * COLS] == number_r
      }
    }
    return false
  end

  # 解読
  def solve(data, number)
    if Time.now > @out
      return false
    end
    
    if number >= CELLS
      display_and_output(data)
      return
    end

    if data[number] == BLANK
      (1..9).each{ |a|
        unless overlap?(data, number, a)
          data[number] = a
          solve(data, number + 1)
          data[number] = BLANK
        end
      }
    else
      solve(data, number + 1)
    end
  end
end

puts NUMPRE.new("./texts/question.txt")