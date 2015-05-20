From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Wed, 20 May 2015 12:27:06 -0400
Message-ID: <1432139226.3114.83.camel@redhat.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
	 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
	 <1432044878.5304.1.camel@opteya.com> <1432049804.3114.41.camel@redhat.com>
	 <1432133301.5304.10.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-RBrh1OjXO0AxidWJ14ra"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432133301.5304.10.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-RBrh1OjXO0AxidWJ14ra
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-20 at 16:48 +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le mardi 19 mai 2015 =C3=A0 11:36 -0400, Doug Ledford a =C3=A9crit :
> > On Tue, 2015-05-19 at 16:14 +0200, Yann Droneaud wrote:
> > >=20
> > > Is Doug the maintainer of the userspace library ?
> >=20
> > Libibverbs and the kernel verbs interface are very closely tied, so I
> > did ask Roland if he was OK with me taking over that as well.  It=20
> > would
> > make it easier to keep the two in sync.  Roland was fine with that.=20
> >  If
> > anyone has any objections, please speak now.
> >=20
>=20
>=20
> OK, I think I've missed the memo :)

No, there wasn't a memo yet.  But, Jeff's question followed by your
question was the perfect introduction to bring the issue up.

As I mentioned, I think there is a pretty strong tie between the kernel
stack the libibverbs.  Especially when you consider that things like
verbs extensions need to be synced between the two.  That's why I'm
offering/suggesting that it would be a good idea that I handle it along
with the kernel.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-RBrh1OjXO0AxidWJ14ra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXLXaAAoJELgmozMOVy/dIPAP/1l2Kb/1oxwmuydDWwA9HAeA
B/ppmaixqzkkf72PpxC0JLulZNLOke4r2OQRJQQvNouBXfTyvHR3RY5RLt8IceuI
GTJB+EppnKnG4veN99yTOhphSTd2u0kMg4gMWYuRm9NJFJBDUUrpPQLwzVDYnL0y
wxvGzRMLQwYXFoNkUbfkobMF9mCEzNE2DWZ8tCO7IxGG4nTT6GMu5w17yZUR3R/g
EyhU6FwJGp8Ni48zgoedB/Ce+YCI3roJKZWKVpHfQvzxcz9jUlw6LFcwF4IF3y6B
oMASU24vbwCjowWDvzfynHC0jnmkomOtB4uN/uO2C6/790LmNHL7QK/GeJGpEs2Z
4p4xyLj/78LXbkkiOUck24D6LTCcpj/FbpqIBGaoWpKOMdhStJUINom/d/Jmda42
jXTL5p9KVZlDieuQkbT1fsbxufE1wMKcydxyKnAMsDORo1T5m+kdNl0/+CD5snU0
Qc80aMjd+WInmkqklA0zmu8eFjkYesDJCi56Eqon3Xgd2q+uTSWRt/SZtdYTmDPd
sPd+gH/08dmy33gDKQmluLW0bopnyLvFdK7FbupYYOGoYfvvLC2WSFcCvwvQi2xv
uHQHgyOXcQN20iadiSGln2fB8B8PJey/wTdnPvmwLNBkiKg1QoEPdPG8dXlXAaCw
aOmhU1SQMXCs9/SL3f/F
=pEI4
-----END PGP SIGNATURE-----

--=-RBrh1OjXO0AxidWJ14ra--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
