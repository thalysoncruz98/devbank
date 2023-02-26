class MovementsController < ApplicationController
  before_action :set_movement, only: %i[ show edit update destroy ]

  # GET /movements or /movements.json
  def index
    @movements = Movement.all
  end

  # GET /movements/1 or /movements/1.json
  def show
  end

  # SEARCH FOR MOVEMENTS
  def search
    start_date = Date.strptime(params[:q], "%d/%m/%Y")
    end_date = Date.strptime(params[:i], "%d/%m/%Y")
    @movements = Movement.where("to_date(date_current, 'DD/MM/YYYY') BETWEEN ? AND ?", start_date, end_date)
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

      # Logic to peform the cashout
      if @movement.movement_type == "Saque"
        # Check if cash is a valid number
        begin
          Float(params[:movement][:cashout])
        rescue ArgumentError
          flash[:error] = "Valor inválido para saque"
          respond_to do |format|
            format.html { redirect_to request.referrer, notice: "Digite um valor válido para saque" }
          end
          return
        end
        # Check if value is null
        if @movement.cashout.nil?
          flash[:error] = "Saldo insuficiente para realizar o saque"
          respond_to do |format|
              format.html { redirect_to request.referrer, notice: "Digite um valor para saque" }
          end
        # Check if amount is greater than balance
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
      # Logic to peform the deposit
      elsif @movement.movement_type == "Deposito"
        # Check if cash is a valid number
        begin
          Float(params[:movement][:cashout])
        rescue ArgumentError
          flash[:error] = "Valor inválido para saque"
          respond_to do |format|
            format.html { redirect_to request.referrer, notice: "Digite um valor válido para deposito" }
          end
          return
        end
        # Check if value is null
        if @movement.cashout.nil?
          flash[:error] = "Saldo insuficiente para realizar o saque"
          respond_to do |format|
              format.html { redirect_to request.referrer, notice: "Digite um valor para o deposito" }
          end
        else
          # if no error, perform calculation and redirect page
          new_cash = @valor.cash + @movement.cashout
          User.update(cash: new_cash)

          respond_to do |format|
            if @movement.save
              format.html { redirect_to request.referrer, notice: "Deposito realizado com sucesso" }
              format.json { render :show, status: :created, location: @movement }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @movement.errors, status: :unprocessable_entity }
            end
          end
        end
      # Logic to perform the transfer
      else
        # Check if value is null
        if @movement.cashout.nil?
          flash[:error] = "Saldo insuficiente para realizar a transferência"
          respond_to do |format|
              format.html { redirect_to request.referrer, notice: "Digite um valor para a transferência" }
          end
        # Check if amount is greater than balance
        elsif @movement.cashout > @valor.cash
          flash[:error] = "Saldo insuficiente para realizar transferência"
          respond_to do |format|
          format.html { redirect_to request.referrer, notice: "Saldo insuficiente para transferência" }
          end
        else
          # Checking if the recipient field is empty
          if @movement.destiny == ""
            flash[:error] = "Digite o email do destinatário"
            respond_to do |format|
                format.html { redirect_to request.referrer, notice: "Digite o email do destinatário" }
            end
          else
            if @movement.day_current != "Saturday"
              flash[:error] = "Digite o email do destinatário"
              respond_to do |format|
                  format.html { redirect_to request.referrer, notice: "Transferência apenas de segunda a sexta" }
              end
            else
              # Check if number is greater than 1000 to charge 10 reais more
              if @valor.cash > 1000
                # Check if the time of movement is between 9 and 18 to charge 5 more. If not... charge 7 reais more
                if @movement.hour_current >= "09" && @movement.hour_current <= "18"
                  # Check if the transfer amount added to the fee amount is greater than the current balance
                  if (@movement.cashout + 15) > @valor.cash
                    flash[:error] = "Saldo insuficiente para realizar transferência"
                    respond_to do |format|
                    format.html { redirect_to request.referrer, notice: "Saldo insuficiente para transferência" }
                    end
                  else
                    new_cash = @valor.cash - (@movement.cashout + 15)
                    User.update(cash: new_cash)
                    User.where(email: @movement.destiny).update_all(cash:@valor.cash + @movement.cashout)
                    respond_to do |format|
                      if @movement.save
                        format.html { redirect_to request.referrer, notice: "Transferência realizado com sucesso" }
                        format.json { render :show, status: :created, location: @movement }
                      else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @movement.errors, status: :unprocessable_entity }
                      end
                    end
                  end
                else
                  # Check if the transfer amount added to the fee amount is greater than the current balance
                  if (@movement.cashout + 17) > @valor.cash
                    flash[:error] = "Saldo insuficiente para realizar transferência"
                    respond_to do |format|
                    format.html { redirect_to request.referrer, notice: "Saldo insuficiente para transferência" }
                    end
                  else
                    new_cash = @valor.cash - (@movement.cashout + 17)
                    User.update(cash: new_cash)
                    User.where(email: @movement.destiny).update_all(cash:@valor.cash + @movement.cashout)
                    respond_to do |format|
                      if @movement.save
                        format.html { redirect_to request.referrer, notice: "Transferência realizado com sucesso" }
                        format.json { render :show, status: :created, location: @movement }
                      else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @movement.errors, status: :unprocessable_entity }
                      end
                    end
                  end
                end
              else
                # Check if the time of movement is between 9 and 18 to charge 5 more. If not... charge 7 reais more
                if @movement.hour_current >= "09" && @movement.hour_current <= "18"
                  # Check if the transfer amount added to the fee amount is greater than the current balance
                  if (@movement.cashout + 5) > @valor.cash
                    flash[:error] = "Saldo insuficiente para realizar transferência"
                    respond_to do |format|
                    format.html { redirect_to request.referrer, notice: "Saldo insuficiente para transferência" }
                    end
                  else
                    new_cash = @valor.cash - (@movement.cashout + 5)
                    User.update(cash: new_cash)
                    User.where(email: @movement.destiny).update_all(cash:@valor.cash + @movement.cashout)
                    respond_to do |format|
                      if @movement.save
                        format.html { redirect_to request.referrer, notice: "Transferência realizado com sucesso" }
                        format.json { render :show, status: :created, location: @movement }
                      else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @movement.errors, status: :unprocessable_entity }
                      end
                    end
                  end
                else
                  # Check if the transfer amount added to the fee amount is greater than the current balance
                  if (@movement.cashout + 7) > @valor.cash
                    flash[:error] = "Saldo insuficiente para realizar transferência"
                    respond_to do |format|
                    format.html { redirect_to request.referrer, notice: "Saldo insuficiente para transferência" }
                    end
                  else
                    new_cash = @valor.cash - (@movement.cashout + 7)
                    User.update(cash: new_cash)
                    User.where(email: @movement.destiny).update_all(cash:@valor.cash + @movement.cashout)
                    respond_to do |format|
                      if @movement.save
                        format.html { redirect_to request.referrer, notice: "Transferência realizado com sucesso" }
                        format.json { render :show, status: :created, location: @movement }
                      else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @movement.errors, status: :unprocessable_entity }
                      end
                    end
                  end
                end
              end
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
      params.require(:movement).permit(:cashout, :movement_type, :destiny, :date_current, :hour_current, :day_current, :user)
    end
end
