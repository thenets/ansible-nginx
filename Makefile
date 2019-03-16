test:
	. .venv/bin/activate && \
		molecule test

create-virtualenv:
	rm -rf .venv
	virtualenv -p python3 .venv
	. .venv/bin/activate && \
		pip install molecule docker ansible pyOpenSSL
