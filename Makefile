DRAFT	:= draft-ellacott-historical-rdap

SRC	:= $(DRAFT).md
TXT	:= $(DRAFT).txt
XML	:= $(DRAFT).xml
HTML	:= $(DRAFT).html

all:	$(XML) $(TXT) $(HTML)

docs: $(HTML)
	git checkout gh-pages
	cp $(HTML) index.html
	git diff-index --quiet HEAD || ( git add index.html ; git commit -m"Updated docs from build" ; git push )
	git checkout master

%.txt: %.xml
	docker run --rm -v ${PWD}:/rfc --user=$(id -u) paulej/rfctools xml2rfc --text $<

%.html: %.xml
	docker run --rm -v ${PWD}:/rfc --user=$(id -u) paulej/rfctools xml2rfc --html $<

%.xml: %.md
	docker run --rm -v ${PWD}:/rfc paulej/rfctools mmark -xml2 -page $< > $@

clean:
	rm -f $(TXT) $(HTML) $(XML)
