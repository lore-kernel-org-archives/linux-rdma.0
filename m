From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
Date: Fri, 19 Aug 2016 18:45:37 +0300
Message-ID: <20160819154537.GF18515@leon.nu>
References: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
 <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>
 <20160819154106.GC18515@leon.nu>
 <32E1700B9017364D9B60AED9960492BC2D0AF84E@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D0AF84E@fmsmsx120.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Hefty, Sean" <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2016 at 03:42:29PM +0000, Marciniszyn, Mike wrote:
> > >
> > > The bail_tmp: label is then not needed.
> >=20
> > You still need to free tmp allocation if qib_eeprom_write failed and th=
is is
> > your bail_tmp.
> >=20
>=20
> Typo.   The bail: label is not needed.

Yeah, it makes sense.

Thanks

>=20
> Mike

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtymhAAoJEORje4g2clinyu4P/jvSluufOtw1zj4YU7APWA8u
c8BZaCo3IGhULIciRCWxKC6h3Aje2YJOItcFVTy6phSMZhXfpuPw8qeismAHCbVa
NLs/rV7elULg1C647Y4ZNd2V6J1xo1bKlBnxF5ZSqGcS0qb5dbm+qz2HMJQwky7J
1fFYs769MzbVsQfM9lI82T/xOsq4d+T3DhbfnkNLqe60BpMlY+Ax7C+GdUucT+5/
DBuVzy3VJCBy4qwXlvkndKXvdGIVxwOCCswo2fDb+wrHjUqOmSNZxoM1MqUaN4iK
hES+11yIN/IzvPyGo2v4hMkp7JncDO1xov9mvetKRAdjeyE73iwSNDQQKCwk+uSp
eEDN0hhnmbdITkdcrqWZFBwznP0an80bxHDcqBaHfANuqM6VUuRNk1OcXA73XpYG
uNO8kb3rmNu6T1eeVhUlRGe0sTO+McZn1H7qa0+rJFIl4grClSr8eR+diyE9NMLY
hlYaEG0wS0MSCnXCD6YOxXU2jNe3Mh1mQd22iJHN6xCMADBPCC4hsLAKH1veecaZ
1AGEyAXCA5pJlnmVUSUZkQD5p/Ke5tQQ9FTKKj12yfNluF5DTUNqhCdkcgAQTogq
n59QI+Bfb8sRPGd8I+8gUn0W7yulYd4owa3G12Jhq7F85u5pUfrgCFDgD6DqFsoX
fMUScjBWVoePISst8LPe
=TvhI
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
