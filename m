From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/usnic: simplify IS_ERR_OR_NULL to IS_ERR
Date: Wed, 14 Dec 2016 12:58:51 -0500
Message-ID: <2c990f6c-d9a6-9887-c6df-bfc45c5ce6cc@redhat.com>
References: <1478891066-16093-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ppNVTKRtDhlFVTjEsgpVKu3XMGXdAlGhN"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478891066-16093-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>, Christian Benvenuti <benve@cisco.com>
Cc: kernel-janitors@vger.kernel.org, Dave Goodell <dgoodell@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ppNVTKRtDhlFVTjEsgpVKu3XMGXdAlGhN
Content-Type: multipart/mixed; boundary="IuPRPrwKBh1iJJJpPlxqagHrqOmWP7AJi";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Christian Benvenuti <benve@cisco.com>
Cc: kernel-janitors@vger.kernel.org, Dave Goodell <dgoodell@cisco.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock
 <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <2c990f6c-d9a6-9887-c6df-bfc45c5ce6cc@redhat.com>
Subject: Re: [PATCH] IB/usnic: simplify IS_ERR_OR_NULL to IS_ERR
References: <1478891066-16093-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1478891066-16093-1-git-send-email-Julia.Lawall@lip6.fr>

--IuPRPrwKBh1iJJJpPlxqagHrqOmWP7AJi
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/11/2016 2:04 PM, Julia Lawall wrote:
> The function usnic_ib_qp_grp_get_chunk only returns an ERR_PTR value or=
 a
> valid pointer, never NULL.  The same is true of get_qp_res_chunk, which=

> just returns the result of calling usnic_ib_qp_grp_get_chunk.  Simplify=

> IS_ERR_OR_NULL to IS_ERR in both cases.
>=20
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression t,e;
> @@
>=20
> t =3D \(usnic_ib_qp_grp_get_chunk(...)\|get_qp_res_chunk(...)\)
> ... when !=3D t=3De
> - IS_ERR_OR_NULL(t)
> + IS_ERR(t)
>=20
> @@
> expression t,e,e1;
> @@
>=20
> t =3D \(usnic_ib_qp_grp_get_chunk(...)\|get_qp_res_chunk(...)\)
> ... when !=3D t=3De
> ?- t ? PTR_ERR(t) : e1
> + PTR_ERR(t)
> ... when any
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--IuPRPrwKBh1iJJJpPlxqagHrqOmWP7AJi--

--ppNVTKRtDhlFVTjEsgpVKu3XMGXdAlGhN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYhbAAoJELgmozMOVy/dWJMP/iE914NLyc9MuLy9TP2kjBhN
K0VQ/5NAGjjqkwIvOct17Xqesr4kv8HU7NmBbssKXzF7CTwiERz3EGarRlWqSjBn
vKUw/LqTmsqgwyiYJrE215VGdO/8Rkm1Pw2qoB6v4rQEMQPeAnZnTJmJupHp6bmj
p2uvsCw1nSIo+E0qktdyc2Myj1cWqWhOHzfxOj1e5oOnnnrTZGW7EF06Kcu5tZv6
lste2c867nkOgqM5kNhK+DI/Wi8Ra98KcOxbIO54TBNH7sbMik3URvMQWJcaq0aR
+uZ6q8BnrMyqSvFnmmd4rP4c2Kc2KtS4UmCJwLigbjIzyj6WLrG2VumP92lOKxoC
AH5EstpVOtVMRi6bwUyhn879j9eSPkqHNTVOc0Jzwgk50zdYO+eRR2cki0okpUAN
E2uMDQmDixPNIfrkOfowo1R1IXj4BJ6ZEE9QkIJ/1Mpu5RWEvoXLhzuQ9Z5PVgx+
ceG/T2cTfQOsFMSTj8/bhcLD4g3tl/WdVKw3+tWn1CCqHfjthVbb0xIL2Kyzlpjz
ob+r04kHGVr3cv9vULPVNXwsQByZBZAUhy4wFb/pR9gzfETnrYVoapolIxoiLeLP
B8C9ty9slKafvTUhPeEZih8KmqsG4iVNtHPERzxY7g+g8MNW97n/u0efK3tVyB6r
DuEf+NnXw4QzQfxHfKQG
=brsx
-----END PGP SIGNATURE-----

--ppNVTKRtDhlFVTjEsgpVKu3XMGXdAlGhN--
