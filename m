From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Computer issues...
Date: Thu, 09 Nov 2017 11:44:21 -0500
Message-ID: <1510245861.12910.26.camel@redhat.com>
References: <CA+mK3=-v-nMb-cRO2hGEmirxbNnRuW-OZWGC8d+sUoTcxKmt7w@mail.gmail.com>
         <1509363152.2295.5.camel@redhat.com>
         <5b0fbfd7-6747-da76-91a9-3fa4dc173bb0@redhat.com>
         <d6ab43f7-9698-7164-441b-02c1f5560abd@redhat.com>
         <CAKkHt7W_Cv_qGRs_R3zn6_PaXd7xAE0+D_Qghn7KUq+bzRHHjg@mail.gmail.com>
         <f3a0d17b-1a5c-b97c-e544-5b4524e71424@redhat.com>
         <783cf656-3cd7-c40d-48cf-a749f022a161@redhat.com>
         <e4fc7d4e-5295-caf9-be5b-6ac5a57a5d2d@redhat.com>
         <36640bfe-850b-a857-1cc9-58939ac50946@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-w1rygCX02bAe/q7NSmIA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36640bfe-850b-a857-1cc9-58939ac50946-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-w1rygCX02bAe/q7NSmIA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-10-31 at 10:32 -0400, Doug Ledford wrote:
> Fortunately, I keep backups and what not, but I am currently
> sending this email from my laptop and I will likely loose the next day
> to two days to the task of reinstalling from scratch, then restoring
> from backup (even as I write this, my laptop is writing a Fedora 27 Beta
> USB boot key).  Joy!

The story of what I had to do this last week is worthy of telling over a
beer some time.  Suffice it to say, I'm mostly back up and operational
at this point.

The "I have backups" turned out to be "I have backups that are looking
right now like they are 2 years old" until I found the root cause and
was finally able to get to the current backups.

And there was another incident and another drive got fried (I will never
buy mixed brands of modular power supplies ever again).

And I shipped the two drives that were actual rotational drives (I
originally said four SSDs, I was incorrect in that, I had forgotten that
the 4 drive caddy that got fried was actually 3 SSDs and one laptop hard
drive, then the 5th drive to get fried was a 3 1/2" internal sata drive)
off for possible controller replacement (not to the manufacturer, but to
a company that specializes in replacing bad controller boards for a flat
rate fee), but they didn't have any spare boards to fit my 3 1/2" drive,
they said it was too new and there was no inventory on its controller
yet.  Still waiting to hear on the other one.

And even if they have a controller board, there's no guarantee that any
data on the drive will be retrievable, thanks to my 4 year old.  He was
home sick with strep throat last Thursday, but I'd given him some
tylenol and his antibiotic and even treated him to a small mocha from
starbucks (yes, he likes chocolate flavored coffee), and I had
inadvertently forgotten to get him decaf, so he was full of energy and
happy, and I was sitting at my computer printing out the paperwork to
ship off the two rotational drives, and he says to me "Daddy, these work
really well here!" and I look over and he's got two magnets off of the
kitchen refrigerator and each hard drive has one magnet sitting on its
metal top cover.  So who knows if those things are even recoverable at
all at this point.  This happened *before* I found the root cause to my
missing backups.  So you can imagine how happy I was when I saw those
magnets :-/.

Anyway, I'm going to be processing patches over the next few days.  I
didn't want people thinking that I wasn't aware of the time and the
upcoming merge window, I'm still tracking it as best as I can while I
rebuild everything ;-)
--=-w1rygCX02bAe/q7NSmIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloEheUACgkQuCajMw5X
L90g2g//cLappMkq7naPMU3no1A/PKvor4H9xtF+82ATxITBtDaGJNTGEW1+kfvB
wR0nwIuwvSU1gBOAdiPX2524+te5O/tugpDGrD01nXBbAcEifbB7O9hlR6b74tM9
QGiXpwFpykWKX/A/AdRAzBNf1ri6OyVEryvVqOZD6JJH6cPFmiCxIPm9i7abL4bW
4g+TQTe6pf7hL1SjbzwVtrJlcsXyPEO/t3pT5UlBo6ZC/vwSK5qWxVvCuWyr9lHL
wM9SIFssKj34iG5Za7RpI+Nupuhyh7tE6oxhJmF8D/H6W37rHqJSzn8reFYcHwC9
kCzE26vgYMtBZX2zP17RB1NhK53J8NQJEOV2DNCpOZfFqdcmKZDMtpEjZCxKnnXd
2u+fK6EcUkuMFTxe4T7BNhNjqUawnSgUdWX8cUAFGMlrzLcGkN3UqlG3g2W4to9X
9h6y5LphC+rZ7uyznpnTgBazDHBzTVzCWibXpY2NAHjv8qC6QVI27w9CbR7rrE3u
AEG4nUGTlEXA1InLqi8u5862LOiDQl0ihTxcQ5qA7NJm7zsOYzCGa52rPFQH/kSu
7wlLQMXoDh8l+X29IUQjd5F2xvSzImgkV/KADkucGqk2h2EHhZm09VUIf0mpL/EP
5dmFxF/VioWYN3p7evbs+6IMC+q/jrFY5n5vIMcaG/7BXwxA4sE=
=OdDd
-----END PGP SIGNATURE-----

--=-w1rygCX02bAe/q7NSmIA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
