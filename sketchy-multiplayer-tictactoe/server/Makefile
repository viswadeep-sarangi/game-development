PYTHON := python3
VENV_DIR := .venv
ACTIVATE := . $(VENV_DIR)/bin/activate

# Create a virtual environment and install dependencies
install: $(VENV_DIR)/bin/activate

$(VENV_DIR)/bin/activate: requirements.txt
	$(PYTHON) -m venv $(VENV_DIR)
	$(ACTIVATE) && pip install --upgrade pip
	$(ACTIVATE) && pip install -r requirements.txt
	touch $(VENV_DIR)/bin/activate

# Run the app using the virtual environment
run:
	$(ACTIVATE) && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Deploy to Fly.io
deploy:
	fly deploy

# Set up Fly.io app (only once)
init:
	fly launch --name tictactoe-server

# View logs
logs:
	fly logs

# Open in browser
open:
	fly open

# Clean up virtual environment
clean:
	rm -rf $(VENV_DIR)
