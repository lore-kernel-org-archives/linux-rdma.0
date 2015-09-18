From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] IB/hfi1: checking for NULL instead of IS_ERR
Date: Fri, 18 Sep 2015 11:51:09 -0400
Message-ID: <55FC32ED.1000404@redhat.com>
References: <20150916062220.GC21542@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XM7I9jLONmPSc4xXa0O9b5oVtoHVUNRo8"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150916062220.GC21542@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Mike Marciniszyn <infinipath@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XM7I9jLONmPSc4xXa0O9b5oVtoHVUNRo8
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 02:22 AM, Dan Carpenter wrote:
> __get_txreq() returns an ERR_PTR() but this checks for NULL so it would=

> oops on failure.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--XM7I9jLONmPSc4xXa0O9b5oVtoHVUNRo8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV/DLtAAoJELgmozMOVy/d3asQAJkW7AlSWibaQWVIcwZrFgbt
RBC4x8EZ8UGuVOUBsL+LKGSweevIcnQVvyAR0adrQfOJzGcAwtUAUDL+aBcvWd0Z
OCZGTEVFKxnXqh5DeZ7bL+u1OhtwJFWqpSSJeEBLgZG+0p71qApGXfoCkvwsLPfF
dehGFKXtx0s8iA8QKyHIjmO68RKNX5ItndxJt/Q8Ea3i/BkPYUorUGhoyH3jTKqY
gV6OGQg47Mzx7xOKDtBF0icltm5aUSSbJYbzzr9VpMK1q73P/Tj/fxnywZ1BZazb
v1aaNhjrriCURs2wXv+Vzpu49YnRTlIvOpgfG8qKJSOnfcGqR+DYK1hWGknWdnYj
MLCfmI1i1jA3IBcbtZJPhMZI2FYr836voQEqlL9o0ZVorFOuoSgK9nLhY7EfUAWZ
zU/T2eTrJ3seu4QQSJlibMYHx9MZZD903eWBbw0xRh34gdSsh9/xN1CSFEwGSrlK
OeC0XA0XJGXWG6QnvX1CkYbk0vkNwc7uYuV0sSVMrFGWftMapwJAH4dFUoXB2WmD
4r4o4mf/+DPEQvVjAGkqqUDOeIf5oh3YFJYaMkndQsxyGLpaAbQ4NkPuUB10CRys
XkhanrP1TRfRkMzS8E6FFwPvPMlTpNwjXyo9Zl27obymGd0AAZdgpzt+6br3KHgb
n36XvjazX8H4JlZqsNc2
=zMrs
-----END PGP SIGNATURE-----

--XM7I9jLONmPSc4xXa0O9b5oVtoHVUNRo8--
