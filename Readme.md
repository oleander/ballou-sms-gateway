# Ballou SMS Gateway

Unofficial API for [Ballou's SMS Gateway](http://www.ballou.se/tj%C3%A4nster/sms-verktyg).

Follow me on [Twitter](http://twitter.com/linusoleander) or [Github](https://github.com/oleander/) for more info and updates.

## How to use

### Send a message

``` ruby
BallouSmsGateway.new.username("u").password("p").from("Github").to("070XXXXXXX").message("Hello world!").send!
```

### Send a message to multiply receivers

``` ruby
BallouSmsGateway.new.username("u").password("p").from("Github").to("070XXXXXXX", "070YYYYYYY").message("Hello world!").send!
```

### Send a very long message

Add the `long` method to the chain to send up to *918* characters.

``` ruby
BallouSmsGateway.new.username("u").password("p").from("Github").to("070XXXXXXX").message("A very long message ...").long.send!
```

### Options

The list below is a set of methods that can be chained, like above. **Order doesn't matter.**

- **id** (String) (CR) (Optimal) A unique ID for the text message. Used for statics. Default is a [UUID string](http://en.wikipedia.org/wiki/Universally_unique_identifier).
- **username** (String) (UN) Ballou username.
- **password** (String) (PW) Ballou password.
- **from** (String) (O) Who is the SMS from? Up to 10 character using text or up to 15 character using only numbers.
- **to** (String or Array< String >) (D) SMS receiver(s). May begin with a plus sign, otherwise just integers.
- **message** (String) (M) Message to be send. Max 160 character, if the `long` flag isn't set.
- **long** (No argument) (LONGSMS) Makes it possible to send a long message, up to *918* character.
- **request_id** (String) (RI) (Optimal) Default is a [UUID string](http://en.wikipedia.org/wiki/Universally_unique_identifier).

Take a look at the [official (swedish) site](http://www.ballou.se/exempel/) for more information.

### The send! method

When you're done buildning your query the final thing todo is to apply the `send!` method.
It'll fire the request or raise an error if something was wrong.

The `send!` method returns a request object with the following methods.

- **id** (String) A unique ID generated Ballou.
- **request_id** (String) Request ID defined by you using the `request_id` method, or an auto-generated UUID string.
- **sms_id** (String) ID defined by you using the `id` method, or an auto-generated UUID string.
- **to** (String) Receiver specified by you using the `to` method.
- **send?** (Boolean) Was the SMS send?
- **valid?** (Boolean) Alias for `send?`.
- **error** (Fixnum) Error code. `0` if everything went okay.
- **status** (Fixnum) Status code. `-1` means that the SMS was added to Ballou's queue.

Take a look at the [status code page](http://www.ballou.se/exempel/) for more information about the diffrent status codes.

## How to install

    [sudo] gem install ballou_sms_gateway

## Requirements

*Ballou SMS gateway* is tested in *OS X 10.7.2* using Ruby *1.9.2*.

## License

*Ballou SMS gateway* is released under the *MIT license*.