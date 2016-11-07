all:	draft-apnic-historical-rdap.txt draft-apnic-historical-rdap.html

docs: draft-apnic-historical-rdap.html
	git checkout gh-pages
	cp draft-apnic-historical-rdap.html index.html
	git diff-index --quiet HEAD || ( git add index.html ; git commit -m"Updated docs from build" ; git push )
	git checkout master

%.txt: %.xml
	docker run --rm -v ${PWD}:/rfc --user=$(id -u) paulej/rfctools xml2rfc --text $<

%.html: %.xml
	docker run --rm -v ${PWD}:/rfc --user=$(id -u) paulej/rfctools xml2rfc --html $<

draft-apnic-historical-rdap.xml: draft-apnic-historical-rdap.md
	docker run --rm -v ${PWD}:/rfc paulej/rfctools mmark -xml2 -page $< > $@

clean:
	rm -f draft-apnic-historical-rdap.{txt,html,xml}
