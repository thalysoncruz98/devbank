class MovementsController < ApplicationController
  before_action :set_movement, only: %i[ show edit update destroy ]

  # GET /movements or /movements.json
  def index
    @movements = Movement.all
  end

  # GET /movements/1 or /movements/1.json
  def show
  end

  # GET /movements/new
  def new
    @movement = Movement.new
  end

  # GET /movements/1/edit
  def edit
  end

  # POST /movements or /movements.json
  def create
    @movement = Movement.new(movement_params)

      # Get balance from logged in user.
      @valor = current_user

      # Check if cashout is a valid number
      begin
        Float(params[:movement][:cashout])
      rescue ArgumentError
        flash[:error] = "Valor inválido para saque"
        respond_to do |format|
          format.html { redirect_to request.referrer, notice: "Digite um valor válido para saque" }
        end
        return
      end

      # Logic to peform the cashout
      if @movement.movement_type == "Saque"
        if @movement.cashout.nil?
          flash[:error] = "Saldo insuficiente para realizar o saque"
          respond_to do |format|
              format.html { redirect_to request.referrer, notice: "Digite um valor para saque" }
          end
        elsif @movement.cashout > @valor.cash
          flash[:error] = "Saldo insuficiente para realizar o saque"
          respond_to do |format|
          format.html { redirect_to request.referrer, notice: "Saldo insuficiente para saque" }
          end
        else
          # if no error, perform calculation and redirect page
          new_cash = @valor.cash - @movement.cashout
          User.update(cash: new_cash)
          
          respond_to do |format|
            if @movement.save
              format.html { redirect_to request.referrer, notice: "Saque realizado com sucesso" }
              format.json { render :show, status: :created, location: @movement }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @movement.errors, status: :unprocessable_entity }
            end
          end
        end
      end

  end

  # PATCH/PUT /movements/1 or /movements/1.json
  def update
    respond_to do |format|
      if @movement.update(movement_params)
        format.html { redirect_to movement_url(@movement), notice: "Movement was successfully updated." }
        format.json { render :show, status: :ok, location: @movement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movements/1 or /movements/1.json
  def destroy
    @movement.destroy

    respond_to do |format|
      format.html { redirect_to movements_url, notice: "Movement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement
      @movement = Movement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movement_params
      params.require(:movement).permit(:cashout, :movement_type, :destiny, :date_current, :hour_current, :day_current)
    end
end
