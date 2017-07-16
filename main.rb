require 'paint'
require 'byebug'

class Main
  def initialize
    @ai_left_current_fingers = 1
    @ai_right_current_fingers = 1

    @player_left_current_fingers = 4
    @player_right_current_fingers = 0
    get_max_fingers("traditional")
    @message = ""
  end

  def get_max_fingers(style)
    if style == "traditional"
      @max = 5
    elsif style == "alternate"
    end
  end

  def display_ai_fingers
    print_line
    puts Paint["O P P O N E N T", :white, :bold]
    print_line
    puts "L E F T  H A N D".ljust(20) + "R I G H T  H A N D"
    print_line
    puts "[ " + @ai_left_current_fingers.to_s + " ]".ljust(20) + "[ " + @ai_right_current_fingers.to_s + " ]"
    print_line
  end

  def display_player_fingers
    print_line
    puts Paint["Y O U", :white, :bold]
    print_line
    puts "L E F T  H A N D".ljust(20) + "R I G H T  H A N D"
    print_line
    puts "[ " + @player_left_current_fingers.to_s + " ]".ljust(20) + "[ " + @player_right_current_fingers.to_s + " ]"
    print_line
  end

  def print_line
    puts "-" * 75
  end

  def main_menu
    continue = false
    while !continue
      system "clear"
      if @message != ""
        print_line
        puts Paint["Event Log: ", :white]
        puts @message
        print_line 
      end
      @message = ""
      display_ai_fingers
      print "\n\n\n"
      puts "What is your action?"
      print_line
      puts Paint["[left to left] [right to left] [ right to right ] [ left to right ] [ split ]", :white]
      print "\n\n\n"
      display_player_fingers
      print "\n\n"
      print "> "
      answer = gets.chomp
      interperate_answer(answer)
      if check_for_max
        system "clear"
        print_line
        puts "Y O U  W I N !!"
        print_line
        break
      end
      if answer.downcase != "split"
        ai_turn
        if check_for_max
          system "clear"
          print_line
          puts "Y O U  L O S E !!"
          print_line
          break
        end
      end

    end
  end

  def check_for_max
    if @player_left_current_fingers > @max
      @player_left_current_fingers = 0
      if @player_right_current_fingers == 0
        return true
        end 
    elsif @player_right_current_fingers > @max
      @player_right_current_fingers = 0
      if @player_left_current_fingers == 0
        return true
        end
    elsif @ai_right_current_fingers > @max 
      @ai_right_current_fingers = 0
      if @ai_left_current_fingers == 0
        return true
        end
    elsif @ai_left_current_fingers > @max  
      @ai_left_current_fingers = 0
      if @ai_right_current_fingers == 0
        return true
        end
    end
    return false
  end

  def check_if_can_kill
    left_to_left = @ai_left_current_fingers + @player_left_current_fingers
    left_to_right = @ai_left_current_fingers + @player_right_current_fingers
    right_to_left = @ai_right_current_fingers + @player_left_current_fingers
    right_to_right = @ai_right_current_fingers + @player_right_current_fingers

    if left_to_left > 5
      @message += "AI chooses left to left."
      @player_left_current_fingers = 0
      return true
    elsif left_to_right > 5
      @message += "AI chooses left to right."
      @player_right_current_fingers = 0
      return true
    elsif right_to_left > 5
      @message += "AI chooses right to left."
      @player_left_current_fingers = 0
      return true
    elsif right_to_right > 5
      @message += "AI chooses right to right."
      @player_right_current_fingers = 0
      return true
    else
      return false
    end
  end

  def check_if_can_split
    if @ai_left_current_fingers == 0
      if @ai_right_current_fingers == 2 || @ai_right_current_fingers == 4
        @ai_left_current_fingers = @ai_right_current_fingers / 2
        @ai_right_current_fingers = @ai_right_current_fingers / 2
        @message = "AI splits"
      end
    elsif @ai_right_current_fingers == 0
      if @ai_left_current_fingers == 2 || @ai_left_current_fingers == 4
        @ai_right_current_fingers = @ai_left_current_fingers / 2
        @ai_left_current_fingers = @ai_left_current_fingers / 2
        @message = "AI splits\n"
      end
    end
  end


  def random_choice(random)
    if random == 1
      # left_to_left
      @message += "AI chooses left to left."
      @player_left_current_fingers = @ai_left_current_fingers + @player_left_current_fingers
    elsif random == 2
      #right_to_left
      @message += "AI chooses right to left."
      @player_left_current_fingers = @ai_right_current_fingers + @player_left_current_fingers
    elsif random == 3
      #left_to_right
      @message += "AI chooses left to right."
      @player_right_current_fingers = @ai_left_current_fingers + @player_right_current_fingers
    elsif random == 4
      #right_to_right
      @message += "AI chooses right to right."
      @player_right_current_fingers = @ai_right_current_fingers + @player_right_current_fingers
    end
  end

  def get_random_number
    if @player_right_current_fingers != 0 && @player_left_current_fingers != 0 &&
       @ai_right_current_fingers != 0 && @ai_left_current_fingers != 0
       # any option open
       random = rand(1..4)
       return random
    elsif @ai_right_current_fingers != 0 && @ai_left_current_fingers != 0
      if @player_right_current_fingers == 0
        #right to left or left to left
        return rand(1..2)
      elsif @player_left_current_fingers == 0
        #right to right or left to right
        return rand(3..4)
      end
    elsif @ai_left_current_fingers == 0
      if @player_right_current_fingers == 0
        #right to left only
        return 2
      elsif @player_left_current_fingers == 0
        #right to right only
        return 4
      else
        return [2,4].sample
      end
    elsif @ai_right_current_fingers == 0
        if @player_right_current_fingers == 0
        #left to left only
        return 1
      elsif @player_left_current_fingers == 0
        #left to right only
        return 3
      else
        return [1,3].sample
      end
    end

  end

  def ai_turn
    check_if_can_split

    random = get_random_number
    # if one hand can kill players, they do it
    if !check_if_can_kill
      random_choice(random)
    end
  end

  def interperate_answer(answer)
    answer = answer.downcase
    continue = false

    while !continue
      if answer == "left to right"
        if @player_left_current_fingers == 0
          puts Paint["\nYou can't use that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        elsif @ai_right_current_fingers == 0
          puts Paint["\nYou can't hit that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        else
          @ai_right_current_fingers += @player_left_current_fingers
          continue = true
        end
      elsif answer == "right to left"
        if @player_right_current_fingers == 0
          puts Paint["\nYou can't use that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        elsif @ai_left_current_fingers == 0
          puts Paint["\nYou can't hit that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        else
          @ai_left_current_fingers += @player_right_current_fingers
          continue = true
        end
      elsif answer == "left to left"
        if @player_left_current_fingers == 0
          puts Paint["\nYou can't use that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        elsif @ai_left_current_fingers == 0
          puts Paint["\nYou can't hit that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        else
          @ai_left_current_fingers += @player_left_current_fingers
          continue = true
        end
      elsif answer == "right to right"
        if @player_right_current_fingers == 0
          puts Paint["\nYou can't use that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        elsif @ai_right_current_fingers == 0
          puts Paint["\nYou can't hit that hand! It has no fingers! :<\n", :white]
          print "> "
          answer = gets.chomp
        else
          @ai_right_current_fingers += @player_right_current_fingers
          continue = true
        end
      elsif answer == "split"
        if @player_right_current_fingers != 0  && @player_left_current_fingers != 0
          puts Paint["\nNot a valid option. You can only split when only have one hand.\n", :white]
          print "> "
          answer = gets.chomp
        elsif @player_right_current_fingers != 2 && @player_right_current_fingers != 4 && @player_left_current_fingers != 2 && @player_left_current_fingers != 4
          puts Paint["\nNot a valid option. You can only split with an even number.\n"]
          print "> "
          answer = gets.chomp
        else
          if @player_right_current_fingers == 0
            @player_right_current_fingers = @player_left_current_fingers / 2
            @player_left_current_fingers = @player_left_current_fingers / 2
          else
            @player_left_current_fingers = @player_right_current_fingers / 2
            @player_right_current_fingers = @player_right_current_fingers / 2
          end
          continue = true
        end
      else
        puts Paint["\nYou did not give a valid answer. Please choose only from the options above.\n", :white]
        print "> "
        answer = gets.chomp
      end
    end
  end
end

game1 = Main.new
game1.main_menu