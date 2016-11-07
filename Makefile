all:	draft-apnic-historical-rdap.txt draft-apnic-historical-rdap.html

%.txt: %.xml
	docker run --rm -v ${PWD}:/rfc --user=$(id -u) paulej/rfctools xml2rfc --text $<

%.html: %.xml
	docker run --rm -v ${PWD}:/rfc --user=$(id -u) paulej/rfctools xml2rfc --html $<

draft-apnic-historical-rdap.xml: draft-apnic-historical-rdap.md
	docker run --rm -v ${PWD}:/rfc paulej/rfctools mmark -xml2 -page $< > $@

clean:
	rm -f draft-apnic-historical-rdap.{txt,html,xml}
