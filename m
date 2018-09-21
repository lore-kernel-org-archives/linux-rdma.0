From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/mlx4: Remove unnecessary parentheses
Date: Fri, 21 Sep 2018 12:02:56 -0400
Message-ID: <551884c4290b58a8bdcf5fc02b3b29a7b1ac7844.camel@redhat.com>
References: <20180920033229.15102-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CEagSXfSaqMJxZ0kvSCr"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920033229.15102-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org


--=-CEagSXfSaqMJxZ0kvSCr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-09-19 at 20:32 -0700, Nathan Chancellor wrote:
> Clang warns when more than one set of parentheses are used in single
> conditional statements.
>=20
> drivers/infiniband/hw/mlx4/mcg.c:676:16: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>                         if ((method =3D=3D IB_MGMT_METHOD_GET_RESP)) {
>                              ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/infiniband/hw/mlx4/mcg.c:676:16: note: remove extraneous
> parentheses around the comparison to silence this warning
>                         if ((method =3D=3D IB_MGMT_METHOD_GET_RESP)) {
>                             ~       ^                         ~
> drivers/infiniband/hw/mlx4/mcg.c:676:16: note: use '=3D' to turn this
> equality comparison into an assignment
>                         if ((method =3D=3D IB_MGMT_METHOD_GET_RESP)) {
>                                     ^~
>                                     =3D
>=20
> Remove the unnecessary parentheses to silence this warning.
>=20
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to for-next, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-CEagSXfSaqMJxZ0kvSCr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlulFjAACgkQuCajMw5X
L91FBg/+N9IjWWGLCBrNlJboa98FuGpxWU0/RN1P7N8DPoZ3SecK4eHWFZzpcCQz
fi1xEdRtZhqTBLOUJzPQUSIJ9k8QwI8Z4vSLEiFn0mZyq4JitzN/yC493/7wTbHk
J6imJtVrpS7v22wHM4fKzniJJw4JG7oHMkEq2e5+u1PQRHOzdk8xWZG9hr8ip6hD
xCeKHKWMWr9/CS2JkpTYy5jbpyaAJFV19ee/Ta+LcJVp82tDOvQEGWHAWSrf0xF6
q3E/Pr7ADspLZOh8Rdvw0EVPQIIv3iDV60hjLhBsooVEFSRVsq1LJO171wJFlQzK
adD4IoxLOl/ushGOIyTGI413WvA1SMrDPU6cxLvIFMXAMlv7lor2RxumyOX+sARx
Plv7r4CfWl82z07PbN8vqZP5oyy7QhmHZKazVGnnmRks4kU3m3JG0z3jK+cubN9W
OTEinmeONgkex9aveal+KEEYpTFjzIotbL26OsrnyGUCs3338Kd320PZ0/vr7yWr
QiRqOrZcIdU7WhiWGkUh2vlozFC20+eDtcrVAwyB8opmXvodxdgd0Ne2NgCDnXbj
5x+eyXbFqFjPHG1X2aSqFyWKZhihswRyCXhm0g1Mq1ITHg4uZsVsIRscmc/qa/gf
xJ4G5QjKavDYNrD7zqulbpyahDcbz0JABEO0hHmkSAqWXNNN9Bs=
=tPdz
-----END PGP SIGNATURE-----

--=-CEagSXfSaqMJxZ0kvSCr--
