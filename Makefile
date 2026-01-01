.PHONY: up build test coverage lint format security type-check all-checks clean install

install:
	pip install --upgrade pip
	pip install -r requirements-dev.txt

up:
	docker compose up -d

build:
	docker compose build --no-cache

clean:
	docker compose down -v --remove-orphans
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -exec rm -r {} +

test:
	python -m unittest discover tests

coverage:
	coverage run -m unittest discover tests
	coverage report -m

lint:
	ruff check --fix .

format:
	ruff format .

security:
	bandit -r .

type-check:
	mypy .

# This target now runs the checks locally
all-checks:
	ruff check .
	bandit -r .
	mypy .
	-coverage run -m unittest discover tests
