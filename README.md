# Wemo-Control

wemo-control is a web app that scans Wemo Switch in your network via UPnP and control it via SOAP.

## Installation

```
git submodule init
cpanm ./Perl-Belkin-WeMo-API
cpanm --installdeps .
```

## Run

```
perl wemo-control.pl daemon -l http://0:5000/
```

