From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/3] IB/mthca: Delete an unnecessary check before the
 function call "pci_dev_put"
Date: Mon, 25 Jul 2016 16:19:26 +0300
Message-ID: <20160725131926.GB20674@leon.nu>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546CE09B.9090101@users.sourceforge.net>
 <55b7a06e-6bb4-f1bb-e4dd-7812648ecf34@users.sourceforge.net>
 <989c5ce4-4e66-04f1-6c4e-f371337852d7@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fez1/uVX7m6GpeOd"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <989c5ce4-4e66-04f1-6c4e-f371337852d7@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org


--fez1/uVX7m6GpeOd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2016 at 12:58:08PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 23 Jul 2016 10:05:12 +0200
>=20
> The pci_dev_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--fez1/uVX7m6GpeOd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlhHeAAoJEORje4g2clinvQ8P/2Al3Ww1mPGAfFcVEFNHud1j
wqIkX+uZHmMe/naYxXzQ45y46CHqDfz8BzA13wfRMTnaoTsE5y9qO3BQQx0KOP5q
h+pkW5aCuK7uNgq7RtbRCunfTYkXDCqtsR35PjEBT2dL+v3Sw0LVxN4+mNo9c2Kg
96+LVSc4Is6L3g+1FZj6xDESNOc8iVY1OaLilLZYhmfPgL2GmUBxMV8YroLqyu17
DE7uE2IdZGUXlmH+Nh8WA0OOggrdSQx5yeTjxqbEDLDHGCJKWAxMyejPPr3mB7cT
mGf26cH9+xaaVtoHm4B/Rr5kwq8uzZqryvs1v+4CNHydK86/u3pkMxyshrBZv1Sf
rOeOy0wsW2qT5iNqqRpBeeaZXd8FqMpLXJJG++gNj9y2nMOzieoHi2DAE4cGqEOv
65wGybSCPMFYh9wlePDcb3N/xk0WpCYXPNNlW0QgMXkRYUqhj0tpll4Lsv9Gkm6k
8slZkZiLDbTdusZhjbv7u0VrJWhIJdtYLplZp1td4NDrw3lzyhsX4NGWx9hIgDnx
06Gv4qy10rGFYmpChI7XwcQwDWnjEHz3qEicHozj1o9AHCXtxFqz/V9FMqQCRvA5
cfq1X3d48dQOkLQM0Nvng8VXdX94cfC1ouCVgpeoIcvuBYf9g6hREgldNkVWgajZ
dsfa7Y0i/pn/JKnPhlJY
=59NT
-----END PGP SIGNATURE-----

--fez1/uVX7m6GpeOd--
