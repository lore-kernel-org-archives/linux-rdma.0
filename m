From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 1/1] drivers/infiniband/core/verbs.c: fix build with
 gcc-4.4.4
Date: Wed, 14 Mar 2018 17:12:19 -0400
Message-ID: <1521061939.18703.126.camel@redhat.com>
References: <20180313215157.GL3mSm-p6%akpm@linux-foundation.org>
         <1521060060.18703.111.camel@redhat.com>
         <20180314140817.8d1b8854af509981ff6562bd@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-DLdkohL7q5ZQsvvkSMbH"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180314140817.8d1b8854af509981ff6562bd@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bart.vanassche@wdc.com, jgg@mellanox.com, linux-rdma@vger.kernel.org, sagi@grimberg.me, stable@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org


--=-DLdkohL7q5ZQsvvkSMbH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-03-14 at 14:08 -0700, Andrew Morton wrote:
> On Wed, 14 Mar 2018 16:41:00 -0400 Doug Ledford <dledford@redhat.com> wro=
te:
>=20
> > On Tue, 2018-03-13 at 14:51 -0700, akpm@linux-foundation.org wrote:
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: drivers/infiniband/core/verbs.c: fix build with gcc-4.4.4
> > >=20
> > > gcc-4.4.4 has issues with initialization of anonymous unions.
> >=20
> > That compiler was released in April of 2010, almost a full 8 years ago.=
=20
> > What still uses it, and do we seriously care?
>=20
> Documentation/Changes still says gcc-3.2.  A few people are using the
> older versions.  There's talk going around about requiring something
> more recent but nothing has happened yet.

OK, count this as a grumble about the outdated compiler requirement :-/.=
=20
The code this patches looks nice and clean, this patch uglies it up.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-DLdkohL7q5ZQsvvkSMbH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqpkDMACgkQuCajMw5X
L93BVQ//eDBupo7M/d+9ZG0FhDApmcX9A9KJstUQs771W6WDiuIGCbtID+qICCXg
IKr4Em0WybfC6dCLnISTwR8tL33grE2SVB/gBlFPC9P7qeprSFtxpR0bBDmoyzHb
+VXmtDHEoLvz8PNCTnGIoP2cXx/pnLMtJJy2f2smgyIOfurZdojEf4iXuZjCGW5s
xYo8wbF94BEzv4SW0ZhX4sBpnBKUHVBunzkjc+iYOPYwBUHFvP2QnmRpadCUih9r
hrtUADaTpEEtjFTvK2PIBMJFJv7AUUNedD+B6p4Fhr9uQIZF7eOCu/fCGKh5w1mw
RIsylT8JdZ8x0mGHpud0SSYkJzGJ5vZ8O/50vL7xja2UdTr0a9fnVz5v8DAIssEM
5HyoyjHihf/dK6X42PXh0v+EZp0EX8m1dowOFrN7FuQ9QE+6DXv+T0QXAJhhxZA7
a2Db+mDF/N9oMUV0ohKYE4GFIPf1ws8EPpc2Xdfh69BYK1Zw0tTfVE/vJkhs/Bc4
2HAwdnpyK/aBiRbAc7BIhlpsWEYUQ5gucnoWLd0U52xt0QOcoo97UnQd92pJKdvR
Awh5H9LD/AbGhoDSjpyESD5g4mB+fFYyJuVGJKfHAE+XvTQ3lKkFcm7xKOv4qslp
lX0UW1i5HzfokQvvD2ypQbM3eC1Yp8cLyeod5QFbnwfbWNdH9aU=
=RqFo
-----END PGP SIGNATURE-----

--=-DLdkohL7q5ZQsvvkSMbH--
