From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/qib: remove redundant setting of any in for-loop
Date: Mon, 13 Nov 2017 16:52:58 -0500
Message-ID: <1510609978.3735.43.camel@redhat.com>
References: <20171020072103.10337-1-colin.king@canonical.com>
         <1508484951.6806.46.camel@perches.com> <1510336823.3735.4.camel@redhat.com>
         <32E1700B9017364D9B60AED9960492BC626823A0@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8dmeFDYWMKRlWFV+cccK"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC626823A0@fmsmsx120.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Joe Perches <joe@perches.com>, Colin King <colin.king@canonical.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-8dmeFDYWMKRlWFV+cccK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-10 at 19:07 +0000, Marciniszyn, Mike wrote:
> > > On Fri, 2017-10-20 at 09:21 +0200, Colin King wrote:
> > > > From: Colin Ian King <colin.king@canonical.com>
> > > >=20
> > > > The variable all is being set but is never read after this
> > > > hence it can be removed from the for loop initialization.
> > > > Cleans up clang warning:
> > >=20
> > > any is really used as bool and is initialized at function
> > > entry.  The earlier loop also reinitializes any unnecessarily.
> >=20
> > Denny, can you weigh in on what you want in this thread?  Thanks.
> >=20
>=20
> I am ok with both Colin's and Joe's patch.
>=20
> Joe's patch would require additional testing vs. the trivial warning fix.
>=20
> Then there is a "guideline"  to keep fixes separate from clean up...
>=20
> Doug,  do you want a tested patch from me?

Preferably, yes :-)

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-8dmeFDYWMKRlWFV+cccK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKFDoACgkQuCajMw5X
L92fPRAAk9h1kkSRnxwwyJBgJY4eEijD35MRIEpvg1ERn7aXO/R+wSpPPytBkZAe
MFeSDavYD9OSK+yqobwhD8V8aXOSrCvkXXjGZ/FNN3Cq0mbZ4F+aZf+SIoL3Y2tR
a9T/C9ef7XY+irPZlUwc68S2KQnRmqbURZbHRRgwMuIz0qyH/ZAk3bC3QV8pisMv
j2G8vlRVKB2lnVLHq/bfS4xsuTGIHZW/2dyXb1aTN9qTSzMokIW7tJ0rK4SWM2oH
vV4CMT58PU0P5WRrH30cd2IMXIU6Tcsm03YrI/GyMW01eoawWm4dHp70jNWG6ddW
vBz5W/mTvQF4K0OVRtlAcIiT/j3iExiVfxM/TZDwskhE61GnY7mUtKb50iK7clZY
fMwRZWc1CG1/wpjPGSjO+6/qG8acH7vHe4/1BloybNm3PfakulIq0Z19lKD4HfRO
kGySsi0WsR4ADhxNu8C8P2LSQEeqMJeBQ9x6todE5zVB3mYlmI9aFIQeMVRD3SHr
vMWNklMwiBSuKQH7qVKWS0dZ22xRePoyMrLaTSw/Pz20q0809xIFyhhFhkIpnId9
kPy8Tu0Z6D8AHE4nBnHtC5E2r+TusrvEZ+9/4XrmgWjdhHTXbWD/i8spvttsj5xg
xlfjZHgFDuUVjvAFp9w2Mv3wgqd0Nc7G2LI6rnwz9LqGVNII9o0=
=J+Q7
-----END PGP SIGNATURE-----

--=-8dmeFDYWMKRlWFV+cccK--
