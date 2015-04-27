From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipath: use arch_phys_wc_add() and require PAT
 disabled
Date: Mon, 27 Apr 2015 14:38:52 -0400
Message-ID: <1430159932.44548.20.camel@redhat.com>
References: <1429730795-6721-1-git-send-email-mcgrof@do-not-panic.com>
	 <CAB=NE6UHnEuMHfFaXBNr4F=RcDcEC3z6rX8-B_10Sbpr7kHkiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-EsqiffAx5gd7MINrgaaO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB=NE6UHnEuMHfFaXBNr4F=RcDcEC3z6rX8-B_10Sbpr7kHkiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-EsqiffAx5gd7MINrgaaO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-04-27 at 09:46 -0700, Luis R. Rodriguez wrote:
> On Wed, Apr 22, 2015 at 12:26 PM, Luis R. Rodriguez
> <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:
> > From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
> >
> > We are burrying direct access to MTRR code support on
> > x86 in order to take advantage of PAT. In the future we
> > also want to make the default behaviour of ioremap_nocache()
> > to use strong UC, use of mtrr_add() on those systems
> > would make write-combining void.
> >
> > In order to help both enable us to later make strong
> > UC default and in order to phase out direct MTRR access
> > code port the driver over to arch_phys_wc_add() and
> > annotate that the device driver requires systems to
> > boot with PAT disabled, with the nopat kernel parameter.
> >
> > This is a worthy compromise given that the ipath device
> > driver powers the old HTX bus cards that only work in
> > AMD systems, while the newer IB/qib device driver
> > powers all PCI-e cards. The ipath device driver is
> > obsolete, hardware hard to find and because of this
> > this its a reasonable compromise to make to require
> > users of ipath to boot with nopat.
>=20
> Hey folks, I realize its being discussed whether or not to remove the
> driver entirely from the kernel but in the meantime, is this a
> reasonable compromise ?

[ trimmed Cc: list to probably the only people that care ]

I would think so.  I think we might as well mark this driver as
deprecated and put a tentative date on removal while we are at it.

Mike, any specific input here?  I would suggest mark it deprecated with
a planned removal sometime in late 2015/early 2016.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-EsqiffAx5gd7MINrgaaO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVPoI8AAoJELgmozMOVy/deCUQAJ+LDHINt6Hj3TiM3NAT8q9m
IzO5sIIkwzr2zovuuqYeSPMqkflGAY8Sz9+pU/+k+TLCZ5CSfhRdBhAav6ubneOv
6ng/omRtWcUp2FpAINQezECuSKBy4C5McL3k4EQgzRK0NqAKQcWAhfWy3WUpFOdW
g2T6ECwo6JlViB9HbqdJ3BRftPp3hZnxL00qtqvKMLuRA0KzemnhqrEktg+Gfdnx
trxbuZsk0Okcsz5CJGShZcGS6Fpdh8toyJLlKxr4bsdBnZsOGSoOAHNTyu7P3tLa
5T1g4++2gwJjh6s+HkgJqIJMhj7oiQ8/3t27V638cpaH3o4yHX0xpGtesiK6BVWh
Nc4RCfTmoUHZvzJWmE9DCRPkDujPnoZzUnn7S/Unz7m9eDE1oOGxF6H2hGcWJSbG
bAfaNs4ClVrc+2QDP8CnN2M4nRRskKN0y1JOvZZ1DvWx8IJ93kJtFJy1nGC+zJUj
w92bBuyqTTxKI2A4gL0reCFaVnMotWbo//LgNTcmjwnYIlObIGDXPofgrmGPj7w1
ggX88iQ+k3ULFqlxwRJEZA2kSIxpm7m5Ty9ODUUIzZt94X/PswN1Tv7vGJhzdgVL
TzYpj21ByPPHTMX1+0yBA+Z4Un65kB16iUGfdz4r8tDoQ1tEJBAzf7VCFoWpfqqF
LuXamWtN8OhYJONrSQe7
=gE1T
-----END PGP SIGNATURE-----

--=-EsqiffAx5gd7MINrgaaO--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
