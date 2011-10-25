# Ballou SMS Gateway

Unofficial API for [Ballou's SMS Gateway](http://www.ballou.se/tj%C3%A4nster/sms-verktyg).

Follow me on [Twitter](http://twitter.com/linusoleander) or [Github](https://github.com/oleander/) for more info and updates.

## How to use

### Send SMS

``` ruby
BallouSmsGateway.new.username("u").password("p").from("Github").to("070XXXXXXX").message("Hello world!").send!
```

![Hello world](http://i.imgur.com/DMmmt.png)

### Send a very long message

Add the `long` method to the chain to send upto *918* characters.

```` ruby
BallouSmsGateway.new.username("u").password("p").from("Github").to("070XXXXXXX").message("A very long message ...").long.send!
````

### Options

The list below is a list of methods that can be chained, like above.

- **id** (String) (CR) (Optimal) A unique id for the text message. Used for statics. Default is a [UUID string](http://en.wikipedia.org/wiki/Universally_unique_identifier).
- **username** (String) (UN) Ballou username.
- **password** (String) (PW) Ballou password.
- **from** (String) (O) Who is the SMS from? A 10 character string, or a 15 character string containing only numbers.
- **to** (String) (D) SMS receiver. May start start with a plus sign, otherwise just integers.
- **message** (String) (M) Message to be send. Max 160 character, if the `long` flag isn't set.
- **long** (No argument) (LONGSMS) Makes it possible to send a long message, up to *918* character.
- **request_id** (String) (RI) (Optimal) Default is a [UUID string](http://en.wikipedia.org/wiki/Universally_unique_identifier).

Take a look at the [official (swedish) site](http://www.ballou.se/exempel/) for more information.

## How to install

    [sudo] gem install movies

## Requirements

*Movies* is tested in *OS X 10.6.7* using Ruby *1.9.2*.

## License

*Movies* is released under the *MIT license*.