From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 20:19:41 -0500
Message-ID: <1516843181.27592.110.camel@redhat.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
         <20180123152142.GB30619@mellanox.com> <1516723456.3339.3.camel@wdc.com>
         <20180123185732.GA1393@mtr-leonro.local> <1516746607.3339.47.camel@wdc.com>
         <1516833393.27592.108.camel@redhat.com> <1516833624.3987.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gWWz5qUJoX6as/8V6MYN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516833624.3987.19.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-gWWz5qUJoX6as/8V6MYN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-24 at 22:40 +0000, Bart Van Assche wrote:
> On Wed, 2018-01-24 at 17:36 -0500, Doug Ledford wrote:
> > Can you please resend this as an official patch with SOB so we can pull
> > this in?  Thanks.
>=20
> Hello Doug,
>=20
> Can you have a look at this patch and see whether this needs any further
> adjustments: https://marc.info/?l=3Dlinux-rdma&m=3D151677697120770.
>=20
> Thanks,
>=20
> Bart.

That's good.  I just missed it in my email client because the time/date
sorting of the threads had this thread later in my list and that lone
patch sitting by itself out of sight-out of mind.  Thanks for the
pointer ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-gWWz5qUJoX6as/8V6MYN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlppMK0ACgkQuCajMw5X
L92H7A/+JMF405wlrsN+qQ4gIF7YZC8s1uqexAXmGNcWcz/QeqBq0NJt0pFZkWlx
yxmcyBs3hTftCGdWJLAW+RFlO0XtlsO48QeAZh4mUoSd1g/gNfjjGm1cEXVE8mXp
QXrhaq+SgEqi95AMTpitfdGCtDxQSfdtKEyApSKcBqmAZ5eLVfa5gnh1B1/QCWRC
j0JmUw077G63siWpbI/q6Vbw/dlsgccq9ZYk0GYVqCWBoX59Y+Zgtt2HUcpwr1+Q
gIkjHXJ60KxemM24MHIwi3uQwc78NMG9j6fXOxeLOnTYOruJzzoDJrWELALmxzRP
cirsFtncpV6fYsR9M8/kzUEzwUlYpipL7xvNt7pMp/PWe3rw6mIFw5PIaVhbM1gu
c83KQY1SaVqwOguOjOsEu9gC2G1LeYC4wYdJhPGQlq1E7v2Ukt+IxsZa3GTM8vOr
DtvxWt3C03fwY72nalcLd+R/F8XomrUV190uE2VRr8azrldfvuNekufJodI1o6a6
AN9aXanTE05b/BCTJ51++VCcTQj1P3bQ9TpL1F3ZUa7ZPRsydTcrtTOX3beKNlf0
/aOnhROsXHxjviyA5YMRcZckUe7xB5FOlhzFq5ZZyx1EwS54RtGgfETGtWZBsR2j
GUi82XbjdMM+44uX1f+qgIHAIOAxCF4kd0prUdLEbUVOZwoWJks=
=1Pot
-----END PGP SIGNATURE-----

--=-gWWz5qUJoX6as/8V6MYN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
