From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/3] IB/mthca: Fine-tuning for mthca_reset()
Date: Tue, 02 Aug 2016 15:40:42 -0400
Message-ID: <1470166842.18081.41.camel@redhat.com>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <546CE09B.9090101@users.sourceforge.net>
	 <55b7a06e-6bb4-f1bb-e4dd-7812648ecf34@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LC37Lw+MODnLx54+Sfuu"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <55b7a06e-6bb4-f1bb-e4dd-7812648ecf34@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org


--=-LC37Lw+MODnLx54+Sfuu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-07-23 at 12:55 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 23 Jul 2016 12:50:12 +0200
>=20
> Further update suggestions were taken into account
> after a patch was applied from static source code analysis.
>=20
> Markus Elfring (3):
> =C2=A0 Delete an unnecessary check before the function call "pci_dev_put"
> =C2=A0 Less function calls after error detection
> =C2=A0 Delete unnecessary variable initialisations
>=20
> =C2=A0drivers/infiniband/hw/mthca/mthca_reset.c | 48 +++++++++++++++----
> ------------
> =C2=A01 file changed, 23 insertions(+), 25 deletions(-)
>=20

I applied 1 and 2, but skipped 3. =C2=A0My memory from long ago is that
those variables didn't used to have initializers, but the compiler
complained, so the initialization was added at some point. =C2=A0This is a
dead driver, only around for the few systems out there using out dated
hardware. =C2=A0I don't want to change this and then have to revert it
because the old warnings came back, so I just dropped that patch.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD

--=-LC37Lw+MODnLx54+Sfuu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPc7AAoJELgmozMOVy/dz9cP/0V7lkVsXBPNWbOE/Lb33Kjo
zXz4tGsF9fGbc/FSpbR3ZdUdEiWH+Hh+JZBqCre78qChEmxugjGBV97s4B1V1T1k
aIDss15jQ/l75nw5VhotUblZQsJ6LYiX9nmKCdWXzCDglP/YWsBbQCanfwNfM8+4
CgsGtcDZafdzVcjhChl+MyKxnbDdqFk4Js0Z/+AdXN5mr3Ab2RRPaeHZzO8q88Vq
JQ3/iHya50GYGI7WhmFDh0dWAkMJH7n6Z8IlyU7BeGRzG2e6GQEXMK0lgpb6PxTq
jFqoJRnrTDWdf/lZ59pURB8+lc7p8FjD+DgJTWwM2xKAc3GYJl8Kkw0pARIvgMHs
LUfkan0ULzomgMVr9EwH+2aFKAd3gQ8gZaiQaQg2kKprhM5GpmUpMzZzBZ1LlTuV
C/5PqtOrZctUknmiDH1NbGNufdLscj7UdoWC8g8i3omNw7rxcXyEZOnrODWJ9zP/
Xj0CmljSWo6f0IdCmu4nFyRDjAzvd1EiDy8theVBP3sbQXwPC92YV8L1TVsWVZiy
SZDe3NvK6tkF2yJj+oRxI5NrCoMR/cFacVdF8Nfmr3Kx0qEGDYnV82P+exYONjmG
893xtgqqCwLq8wEa5tslU43eywmwdWsCyCKggztXgvyswTHV7y9wNxx+BI4Y5py0
+5n6SAIyvaUYhNQ+/4qc
=9yqQ
-----END PGP SIGNATURE-----

--=-LC37Lw+MODnLx54+Sfuu--

