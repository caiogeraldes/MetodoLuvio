aulassrc := "./"
aulaspdfs := "./pdfs/"

default:
    just --list

all: (build "apostila") (build "livro") biblio

build target:
    cd {{aulassrc}}{{target}} && lualatex --interaction=batchmode --draftmode main.tex 
    cd {{aulassrc}}{{target}} && biber --quiet main
    cd {{aulassrc}}{{target}} && lualatex --interaction=batchmode --draftmode main.tex 
    cd {{aulassrc}}{{target}} && lualatex --interaction=batchmode main.tex
    mv {{aulassrc}}{{target}}"/main.pdf"  {{aulaspdfs}}{{target}}".pdf"

debug target:
    cd {{aulassrc}}{{target}} && rm -f main.aux main.bbl main.bcf *.log main.blg main.log main.out main.run.xml main.lof main.synctex.gz main.toc
    cd {{aulassrc}}{{target}} && lualatex --halt-on-error --draftmode main.tex
    rm -rdf debug/
    mkdir -p debug/
    cp -r {{aulassrc}}{{target}}/main.pdf debug/.
    cp -r {{aulassrc}}{{target}}/main.log debug/.
    cd {{aulassrc}}{{target}} && biber main
    cd {{aulassrc}}{{target}} && lualatex --halt-on-error --draftmode main.tex
    rm -rdf debug/
    mkdir -p debug/
    cp -r {{aulassrc}}{{target}}/main.pdf debug/.
    cp -r {{aulassrc}}{{target}}/main.log debug/.
    cd {{aulassrc}}{{target}} && lualatex --halt-on-error main.tex
    rm -rdf debug/
    mkdir -p debug/
    cp -r {{aulassrc}}{{target}}/main.pdf debug/.
    cp -r {{aulassrc}}{{target}}/main.log debug/.

biblio:
    cd "bibliografia/" && rm -f main.aux main.bbl main.bcf *.log main.blg main.log main.out main.run.xml main.lof main.synctex.gz main.toc
    cd "bibliografia/" && lualatex --interaction=batchmode --draftmode main.tex 
    cd "bibliografia/" && biber --quiet main 
    cd "bibliografia/" && lualatex --interaction=batchmode --draftmode main.tex 
    cd "bibliografia/" && lualatex --interaction=batchmode main.tex
    mv "bibliografia/main.pdf" "bibliografia/bibliografia.pdf" 
    cp "bibliografia/bibliografia.pdf" "pdfs/bibliografia.pdf"

mapa:
    cd "scripts/R/" && R CMD BATCH mapa.R

clean target:
    cd {{aulassrc}}{{target}} && rm -f main.aux main.bbl main.bcf *.log main.blg main.log main.out main.run.xml main.lof main.synctex.gz main.toc

clean-all: (clean "apostila") (clean "livro")
  rm pdfs/*

zip:
  ouch compress {{aulaspdfs}}/* $(jq --raw-output ".[\"version\"]" proj.json).zip

release: all zip

init: clean-all all
