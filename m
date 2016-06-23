From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/rdmavt: Correct qp_priv_alloc() return value test
Date: Thu, 23 Jun 2016 11:50:07 -0400
Message-ID: <0544617c-ca0e-8056-21a8-4bcad980ccb8@redhat.com>
References: <20160622202933.16853.56199.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kneDGv9BUO7kV3JVKpMfUjHCUorEXH0iM"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160622202933.16853.56199.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Stable <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kneDGv9BUO7kV3JVKpMfUjHCUorEXH0iM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/22/2016 04:29 PM, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
>=20
> The current drivers return errors from this calldown
> wrapped in an ERR_PTR().
>=20
> The rdmavt code incorrectly tests for NULL.
>=20
> The code is fixed to use IS_ERR() and change ret according
> to the driver return value.
>=20
> Cc: Stable <stable@vger.kernel.org> # 4.6+
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--kneDGv9BUO7kV3JVKpMfUjHCUorEXH0iM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbAUvAAoJELgmozMOVy/dXyMP/j/CqoxW7dOolZUtMAk/PKhB
uDABlM+X6pql9cxGRHJinNX9RhXocUyirkRGcJbAV6FO32Kjc2s4Rrfet2oxzkIz
OQYoqOglGr1fZdN70gLrsoJZ40Ih7gf0DGjRfzbVpOA5DmIylHXR6IRjzRY4CddR
v33EXOQuQJHNm3JMQ9gGosazkyVujyVWO2473tHy4FeDT6nR79ie+NQh80BerVPC
vWhj0/WNIhnTXWaCrP5bwkr0zVfB0OzSWdc/XU938It1qIempAjSafqs9BXXr2Zz
0qRb+QK7hnxkADNHkt2Euo5b/JU8juY5ps9G8M+zAIovtzD788vepcR8zsIY+9lG
uII6pvxOu80ZU0cYBefNluR1HX5Cd4bKdd4v0gWAWpUhwSo+GIweR5dsdQeWVAYA
v2CEl4VWN1xNEF8dgoNi/eY64FnkxRupC0WYk8KmaMU90J7oI0r+m6rT5Y1GQoXR
q1AajsxSRCMcTJcC2Tn4Ba1x4HZMRY5SKBZK1wyjfu2Ew/VqUisWA0MfEJHvijVm
ZM3/vHUXI040/XB7rLBtiQULf7cEiAhU8ATEjWSQz97s51kMX1qKDXggGkaN4LZP
LcbeJW6EF9HwuVePtS9NcfwUmlKCnUHVi/9P7/cVHGM41OETDdnZ2wQz3c8k78zc
pIuG+Pt3v25Xk9PSZfRF
=1WmA
-----END PGP SIGNATURE-----

--kneDGv9BUO7kV3JVKpMfUjHCUorEXH0iM--
