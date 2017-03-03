unit module MyApp;
use Sixatra;

get '/users/:name', -> $c {
    $c.render(
        './templates/user.tm', {
            :name($c.params<name>)
        }
    );
};

post '/entries', -> $c {
    $c.redirect('/', 303);
};

get '/', -> $c {
    $c.render('./templates/index.tm');
};

get '/403', -> $c {
    403;
}
