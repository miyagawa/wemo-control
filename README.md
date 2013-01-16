# Wemo-Control

wemo-control is a web app that scans Wemo Switch in your network via UPnP and control it via SOAP.

## Screenshot

<img src="http://pbs.twimg.com/media/BAwpsRQCYAAwPKn.png" height="250">

## Installation

```
git submodule init && git submodule update
cpanm ./Perl-Belkin-WeMo-API
cpanm --installdeps .
```

## Run

```
perl wemo-control.pl daemon -l http://0:5000/
```

