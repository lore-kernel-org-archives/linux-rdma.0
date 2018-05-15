From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 6/6] infiniband: qplib_fp: Use dev_fmt
Date: Tue, 15 May 2018 10:40:42 -0400
Message-ID: <117ed9198ff46889d3e66a0d501fb574e60544ed.camel@redhat.com>
References: <cover.1525878372.git.joe@perches.com>
         <51c5082a4add7520b4fac54e58ca26a8156bf5e8.1525878372.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-k7eLPhUI2HJkNmQ8vgQd"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51c5082a4add7520b4fac54e58ca26a8156bf5e8.1525878372.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: x86@kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-k7eLPhUI2HJkNmQ8vgQd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-05-09 at 08:15 -0700, Joe Perches wrote:
> Convert the embedded dev_<level> uses to use the new dev_fmt
> prefix and remove the prefix from the formats.
>=20
> Miscellanea:
>=20
> o Add missing terminating newlines to avoid possible interleaving
> o Realign arguments
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

I don't see any problem with this patch.  For the IB part:

Acked-by: Doug Ledford <dledford@redhat.com>

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-k7eLPhUI2HJkNmQ8vgQd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr68WoACgkQuCajMw5X
L92/0Q//bGW3mh1Eok5Q5JHlmfBjRO1hf3NIFGMtEsjJFqOwptqWg+nFdkwwg3TQ
V4laIumHEhmgVKBzxtiX2nIitNrY79NO8Au99TAetJuzEtRPENdOY4QrIbdYBo8O
kj3pKpafBum08uwmZMj13hvAaiEJZl5pRqYQ3xhoCybxW5l5gQkdJYGaKvMnefws
3yxjGIq1KzFw0z0nwZZR2a8UKPz7wEKG0y/yN5K3oK1K2BX8+qxHblulbr+8ezdr
lJFJV53B23aepGBOb5pBShpnjcABOqcATJmS9Yd1WtJ9064FcNrjMq/PUFPGqxuP
GchlXvAKsrCovGxZcdGrHxmxmFJ1Q8e8nKc/fM8E1J1JYg1DhlDds6gWoRnA5ah3
eIMX26giAzWDZykeVfHT/0NrJ3kRm9ydULHGG6Xw3NbgwgRTxERbeU25xfE7wVBn
X2kuYe9wsScY2BgGfQ1m1bKG8nTnByrERvL864G/Lo3pbgfbtuKL9CPoQCJGFl2V
+665A9H0L1+Wy2dZPCppeWXJvYNckn8Z6UxsON4dDVDNeKDDn9D44b8RvLEo60y3
BzbBbSAjZSfZPNkV8Pa6akVpppdJY6U6lWmf9RS52bEpWgMmjvAQZSs6vfy/kdja
ESmW0d4yTC3wrV91X8a+1ecoYjaZ2pgiDtiEQG6EAEjTaK4i4gM=
=tYVD
-----END PGP SIGNATURE-----

--=-k7eLPhUI2HJkNmQ8vgQd--
