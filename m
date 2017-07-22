From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] cxgb4: Fix error codes in c4iw_create_cq()
Date: Sat, 22 Jul 2017 13:28:12 -0400
Message-ID: <ce103089-9f0f-6ef0-23ac-7e1ef2d3b36d@redhat.com>
References: <20170713074740.4i2weowvndudqwh6@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fU1lB3awUiQs3QccPLV0O6k9VsfEVe0mH"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170713074740.4i2weowvndudqwh6@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Steve Wise <swise@chelsio.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fU1lB3awUiQs3QccPLV0O6k9VsfEVe0mH
Content-Type: multipart/mixed; boundary="mc3sNJbRKhBa0qT3JOIvsu3VA5C3TL32g";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Steve Wise <swise@chelsio.com>
Cc: Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <ce103089-9f0f-6ef0-23ac-7e1ef2d3b36d@redhat.com>
Subject: Re: [PATCH] cxgb4: Fix error codes in c4iw_create_cq()
References: <20170713074740.4i2weowvndudqwh6@mwanda>
In-Reply-To: <20170713074740.4i2weowvndudqwh6@mwanda>

--mc3sNJbRKhBa0qT3JOIvsu3VA5C3TL32g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/2017 3:47 AM, Dan Carpenter wrote:
> If one of these kmalloc() calls fails then we return ERR_PTR(0) which i=
s
> NULL.  It results in a NULL dereference in the callers.
>=20
> Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--mc3sNJbRKhBa0qT3JOIvsu3VA5C3TL32g--

--fU1lB3awUiQs3QccPLV0O6k9VsfEVe0mH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4ssAAoJELgmozMOVy/dFRsQAK0tdkcid6YF2Kdg93SGExcL
JprMmq5SfN2x1YC19mPtkMNMAAq32tO2CReRBoU97kOiv7+iX/jtktkJFurw2ZOp
Cd0ioi4uBC/6riQhfYLnvKaRsHHwIvVg4qvTtBttvZwew9RLWyVJjRfiRXRTkTBl
RIHbN+Ow24eFZkXB9IJvIbQhr+b5MbQpRyPy2i32FkE/bzRvW9NfFJy4zMYCTGlz
EhzMSavanqSA61pM9xqAgrSbisqRy/HoPa+Z8UKvOP4Tq0ChEgbI+hXfpYHWlF8E
9S6QITwHSVemyA5txVmhGaQv+0IRs8oHSqsOMhTWS4+trxS5YPYYtnS5Ci5yQ2Cl
AlMKzPS1igskDgfgaaNxBYSfF6GaxahlOxLuIqQJNemGUGyjrYVDWvSnqMlqh5Nu
Hwn1XVu5rp9Ecql+6ACqbEyuNdCqZY/U/cStbD4BkHF5r1iS0M1p4j+Hpgl5Bv5w
rvtcrzMtUb4RVf4wPvGAWvkGJHklIxFa8DliQGLQyL1+ch0XYoo4ou9P88/oSrOC
k2NPJJrLQNJc+Vel8rmBEZQbXw+PVqtxx8BXvKxYaUUwuSuls8YGnSOEdB0XtRyq
hmuaWOXLEuHaAk8rHNdhKiduZ8Z0QGBeJA0pU+jhPqUU9V1lViQa7Ubs1i2gHjST
s4A+QABX2eSmChZ7byoQ
=uHps
-----END PGP SIGNATURE-----

--fU1lB3awUiQs3QccPLV0O6k9VsfEVe0mH--
