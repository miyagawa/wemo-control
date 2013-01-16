use lib "lib";

use Mojolicious::Lite;
use Wemo;

get '/' => sub {
    my $self = shift;
    my @wemos = Wemo->discover;
    $self->render('index', wemos => \@wemos);
};

get '/toggle' => sub {
    my $self = shift;

    my $ip = $self->param('ip');
    my $wemo = Wemo->find($ip);
    $wemo->device->toggleSwitch;

    $self->render(json => { ip => $ip });
};

get '/refresh' => sub {
    my $self = shift;
    Wemo->discover(1);
    $self->redirect_to('/');
};

app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head>
    <title>Wemo Control</title>
    <style type="text/css" media="screen">@import "/themes/jqtouch.css";</style>
    <script src="/src/lib/zepto.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/src/jqtouch.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
    var jQT = $.jQTouch({});
    $(function(){
      $('.refresh').bind('tap', function(){
        location.href = $(this).data('link')
      });
      $('.tapme').bind('tap', function(){
        var container = $(this).parent();
        $.ajax({
          url: "/toggle",
          data: { ip: $(this).data('ip') },
          success: function(data) {
            var status = $('.on-off', container);
            status.text(status.text() == "ON" ? "OFF" : "ON");
          }
        });
      });
    });
    </script>
    <style type="text/css">

    /* Switch status */
    .switch-on  { color: #0a0 }
    .switch-off { color: #a00 }
    </style>
  </head>
  <body>
    <div id="jqt">
      <div id="home" class="current">
        <div class="toolbar">
          <h1>Switches</h1>
          <a class="button refresh" data-link="/refresh">Refresh</a>
        </div>
        <ul class="plastic scroll">
        % for my $wemo (@$wemos) {
          <li class="arrow">
            <a class="tapme" data-ip="<%= $wemo->ip %>" href="#">
            <%= $wemo->device->getFriendlyName %>
            <small class="on-off"><%= $wemo->device->isSwitchOn ? "ON" : "OFF" %></small>
            </a>
          </li>
        % }
        </ul>
      </div>
    </div>
    <script src="//code.jquery.com/jquery-1.9.0.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
  </body>
</html>
