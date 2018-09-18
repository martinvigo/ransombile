# Ransombile

Ransombile is a tool that automates the password reset process and allows you to perform the entire flow automatically for multiple sites at the same time. The aim is to automate the three steps that take the longest in our proposed attack vector.

This tool serves just as a PoC to proof that password reset can be automated effectivaly. Consider it an Alpha version. Things will fail and some sites I added won't work for various reasons (UI in a language different than English, A/B testing, timming issues, etc.).

For details and demos please check: [https://www.martinvigo.com/ransombile](https://www.martinvigo.com/ransombile)

## Installation

Ransombile is a rails app. It should work on any version but I wrote and tested it on Ruby 2.4 and Rails 5.0

## Setup

You need an email inbox to which you will be sending emails from the Victim;s device to retrieve the victim;s email address. Add the credentials information to the *ransombile_controller* file.

You can change the selenium plugin to use any browser but it comes configured to use Firefox by default to make development and testing easier. In fact, if you would "deploy" Ransombile, you probably want to use a headless browsers like PhantomJS.

## Usage

Launch the server and run the webapp on any browser. It is optimized for mobile device screen sizes.

```rails server```

## Adding websites

I left a tempate under */controllers/website_templates_controller*. It will give you an skeleton with the basic functions and implementation. Just add the missing code were indicated.

You can create a new controller with the new website name

```rails generate controller Websitename```

Next, you need to update the UI, file *index.html.erb*. Just copy paste what's already there for any other site. Don't forget to update the function *initiatePasswordReset()*!

Last, update the routes file

## Authors

Martin Vigo - @martin_vigo - [martinvigo.com](https://www.martinvigo.com)