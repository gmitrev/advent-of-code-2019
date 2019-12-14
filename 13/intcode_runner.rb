require 'logger'

class IntcodeRunner
  attr_reader :output
  attr_accessor :instructions

  def initialize(instructions, inputs=[], debug: false)
    @instructions = instructions.dup
    @inputs = inputs
    @position = 0
    @relative_base = 0
    @output = []
    @stop = false
    @halted = false
    @debug = debug
    @log_level = debug ? Logger::DEBUG : Logger::INFO
  end

  class << self
    def run(*options)
      new(*options).run
    end
  end

  def halted?
    !!@halted
  end

  def feed_input(input)
    @inputs << input
  end

  def start
    @stop = false
    @halted = false
    @output = []
    run
  end

  def run
    until @stop do
      logger.debug '=' * 40
      opcode = @instructions[@position]
      logger.debug "##{@position} with opcode: #{opcode}"

      code_1 = ->(a, b, target) {
        sum = a + b
        logger.debug "writing sum of #{a}+#{b} #{sum} to ##{target}"
        @instructions[target] = sum
        advance(4)
      }

      code_2 = ->(a, b, target) {
        product = a * b
        logger.debug "writing product #{a}*#{b} #{product} to ##{target}"
        @instructions[target] = product
        advance(4)
      }

      code_3 = ->(address) {
        logger.debug "writing #{@inputs.inspect}{1} to ##{address}"
        @instructions[address] = @inputs.shift
        advance(2)
      }

      code_4 = ->(val) {
        @output << val
        @stop = true if @output.size == 3

        logger.debug "output: #{@output}"
        advance(2)
      }

      code_5 = ->(a, b) {
        logger.debug "Comparing #{a} != #{0}"
        if a != 0
          logger.debug "Setting position to #{b}"
          set_position(b)
        else
          logger.debug "Advancing by 3"
          advance(3)
        end
      }

      code_6 = ->(a, b) {
        logger.debug "Comparing #{a} == #{0}"
        if a == 0
          logger.debug "Setting position to #{b}"
          set_position(b)
        else
          logger.debug "Advancing by 3"
          advance(3)
        end
      }

      code_7 = ->(a, b, t) {
        logger.debug "Comparing if #{a} < #{b}"
        if a < b
          logger.debug "Setting #{t} to 1"
          @instructions[t] = 1
        else
          logger.debug "Setting #{t} to 0"
          @instructions[t] = 0
        end

        logger.debug "Advancing by 4"
        advance(4)
      }

      code_8 = ->(a, b, t) {
        logger.debug "Comparing if #{a} == #{b}"
        if a == b
          logger.debug "Setting #{t} to 1"
          @instructions[t] = 1
        else
          logger.debug "Setting #{t} to 0"
          @instructions[t] = 0
        end
        logger.debug "Advancing by 4"
        advance(4)
      }

      code_9 = ->(a) {
        @relative_base += a
        logger.debug "Changing relative base by #{a} to #{@relative_base}"
        advance(2)
      }

      code_big = ->() {
        new_opcode, _, *modes = opcode.digits
        logger.debug "Opcode: #{new_opcode}"
        logger.debug "Modes: #{modes}"
        mode_a, mode_b, mode_t = modes
        logger.debug "mode_a: #{mode_a}, mode_b: #{mode_b}, mode_t: #{mode_t}"

        case new_opcode
        when 1
          a = read_value(@position + 1, mode_a.to_i)
          b = read_value(@position + 2, mode_b.to_i)
          t = write_value(@position + 3, mode_t.to_i)
          code_1.(a, b, t)
        when 2
          a = read_value(@position + 1, mode_a.to_i)
          b = read_value(@position + 2, mode_b.to_i)
          t = write_value(@position + 3, mode_t.to_i)
          code_2.(a, b, t)
        when 3
          a = write_value(@position + 1, mode_a.to_i)
          # a = read_value(@position + 1, mode_a.to_i)
          code_3.(a)
        when 4
          a = read_value(@position + 1, mode_a.to_i)
          code_4.(a)
        when 5
          a = read_value(@position + 1, mode_a.to_i)
          b = read_value(@position + 2, mode_b.to_i)
          code_5.(a, b)
        when 6
          a = read_value(@position + 1, mode_a.to_i)
          b = read_value(@position + 2, mode_b.to_i)
          code_6.(a, b)
        when 7
          a = read_value(@position + 1, mode_a.to_i)
          b = read_value(@position + 2, mode_b.to_i)
          t = write_value(@position + 3, mode_t.to_i)
          code_7.(a, b, t)
        when 8
          a = read_value(@position + 1, mode_a.to_i)
          b = read_value(@position + 2, mode_b.to_i)
          t = write_value(@position + 3, mode_t.to_i)
          code_8.(a, b, t)
        when 9
          a = read_value(@position + 1, mode_a.to_i)
          code_9.(a)
        when 99
          @halted = true
          break
        else
          logger.debug "OUTPUT: #{@output}"

          raise "MEGA KOR: unexpected opcode #{new_opcode}"
        end
      }

      case opcode
      when 99
        @halted = true
        break
      else
        code_big.()
      end
    end

    dump(size: @instructions.size) if @debug
    @output
  end

  private

  def advance(with)
    @position += with
  end

  def set_position(to)
    @position = to
  end

  def read_value(position, mode)
    case mode
    when 0
      @instructions[@instructions[position]].to_i
    when 1
      @instructions[position].to_i
    when 2
      @instructions[@instructions[position] + @relative_base].to_i
    end
  end

  def write_value(position, mode)
    case mode
    when 0
      @instructions[position]
    when 2
      @instructions[position] + @relative_base
    end
  end

  def get_parameter(position, offset)
    @instructions[@instructions[position + offset]]
  end

  def get_immediate(position, offset)
    @instructions[position + offset]
  end

  def dump(size: 50)
    puts "Position: #{@position}; Relative base: #{@relative_base}"
    @instructions.take(size).each_with_index do |i, position|
      logger.info "#{position}: #{i}"
    end
  end

  def logger
    @logger ||=
      begin
        logger = Logger.new(STDOUT)
        logger.level = @log_level
        logger.formatter = ->(_severity, _datetime, _progname, msg) { "#{msg}\n" }
        logger
      end
  end
end
