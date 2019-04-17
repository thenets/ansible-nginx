# Molecule tests
test:
	. .venv/bin/activate && \
		molecule test

test-debug:
	. .venv/bin/activate && \
		molecule --debug test

# venv
create-virtualenv:
	rm -rf .venv
	virtualenv -p python3 .venv
	. .venv/bin/activate && \
		pip install molecule docker ansible
