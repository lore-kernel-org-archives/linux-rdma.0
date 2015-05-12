From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: fix test of unsigned variable
Date: Tue, 12 May 2015 12:21:53 -0400
Message-ID: <1431447713.43876.44.camel@redhat.com>
References: <20150511121315.21044.78464.stgit@phlsvslse11.ph.intel.com>
	 <1431348365.25060.31.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-6P7iS0ZiW8VQbToyaynE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431348365.25060.31.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-6P7iS0ZiW8VQbToyaynE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-11 at 14:46 +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le lundi 11 mai 2015 =C3=A0 08:13 -0400, Mike Marciniszyn a =C3=A9crit :
> > Commit d4988623cc60 ("IB/qib: use arch_phys_wc_add()")
> > adjusted mtrr inititialization to use the new interface.
> >=20
> > Unfortunately, the new interface returns a signed
> > value and the patch tested the unsigned wc_cookie.
> >=20
> > Fix the issue by using 'ret' and only assigning
> > wc_cookie from ret when ret >=3D 0.   Additionally, insure
> > ret is 0 on success.
> >=20
> > Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Cc: Luis R. Rodriguez <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
> Cc: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
>=20
> > ---
> >  drivers/infiniband/hw/qib/qib_wc_x86_64.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infini=
band/hw/qib/qib_wc_x86_64.c
> > index 6d61ef9..85525be 100644
> > --- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> > +++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> > @@ -116,9 +116,11 @@ int qib_enable_wc(struct qib_devdata *dd)
> >  	}
> > =20
> >  	if (!ret) {
> > -		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
> > -		if (dd->wc_cookie < 0)
> > -			ret =3D -EINVAL;
> > +		ret =3D arch_phys_wc_add(pioaddr, piolen);
> > +		if (ret >=3D 0) {
> > +			dd->wc_cookie =3D ret;
> > +			ret =3D 0;
> > +		}

This fix is broken.  Luis and I discussed this at some length with his
original patch.  You're right that the code is broken because wc_cookie
is unsigned and that needs fixed, but once qib_enable_wc returns an
error, we don't fail the adapter init, we print out a warning about poor
performance and move on.  Later, we test wc_cookie !=3D 0 in order to
determine if we used PAT.  It doesn't matter if our return was positive
or negative, we only try to enable wc via arch_phys_wc_add() when we
didn't use PAT, and so we need to capture the return value whether it's
a valid cookie or an error return in order to make sure we don't attempt
to use PAT later on.

So, the matrix of what the driver does now looks like this:

dd->wc_cookie =3D=3D 0: PAT was used
dd->wc_cookie > 0: wc was used successfully
dd->wc_cookie < 0: neither PAT nor wc was used

I've fixed up the change to simply switch wc_cookie from unsigned long
to plain long and left the original code as it was, and it is now staged
for 4.1-rc.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-6P7iS0ZiW8VQbToyaynE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUiihAAoJELgmozMOVy/d3vsQAJChpDEIrI6Xx1oadhK/SiEd
9xVjFtYCBwgTJc8vcmD5Ll9xe9xbK9SjIIK/+fa/9rqBlYeBT08Q9nPj+GAMS0wL
TJTSDTbhsg+eEFQQ0G97bfI0b+YNfVlGpGf8JCHIKuxgtLDdt41NTJoc8UTVwVqo
SMYWGS5axQyQCagkCf3/wVI7TdXzw/d8Pc6GvKHwPgnjFVP7NhcafufOkxLyCof5
ZlM4LyeGTB2ffdLxu7WC/h+I/E/GKz0eiKVY9Lni844YdryW1zGPhGIuYXaCUsLx
WF3sEth2NBw42lHkbTo4QpZvPjlRNDGCsAq+Q8OPSap2Tq+C6OJ73ySVeTNda+iZ
Z2XC3foz0IoJT8S57C1zOA0bBc1nszU8t1I/QMqO4+WTJPKO7KDEcxQTj1ng8ZeI
FnNI/fCRH+LHDZPjAGxWccx24twYvdd2W8F7DMHg6y15soZ47R+Vo/2viydjdDF8
er8wJugaCjGPSi1uhuNLw56vcF/GsGNtFHcdPo9cKq0L1w/ZyhoTIvOcTSAUq36q
mU9Bf59gvfd0zhTJWlT6S8OWDlM4yNcih6+aiygoOWnv88ebdvAq4bUawJRQQdI1
tZ3gIUuMKP8ahoJ8Uhpayg2+5EeoyvKVfQdQT4+ZEGhF4eroABcoYK61IR6izvEM
dUYJUXz0HujO1oiXMojB
=4WEK
-----END PGP SIGNATURE-----

--=-6P7iS0ZiW8VQbToyaynE--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
