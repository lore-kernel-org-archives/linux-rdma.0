From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/rxe: add RXE_START_MASK for rxe_opcode
 IB_OPCODE_RC_SEND_ONLY_INV
Date: Fri, 27 Apr 2018 14:23:53 -0400
Message-ID: <1524853433.11756.72.camel@redhat.com>
References: <1524714759-14654-1-git-send-email-jianchao.w.wang@oracle.com>
         <f2df9d02-8693-60e6-e4fd-24c81817b898@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2dDtBQVpbCgD/xtK7qaX"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f2df9d02-8693-60e6-e4fd-24c81817b898@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yanjun Zhu <yanjun.zhu@oracle.com>, Jianchao Wang <jianchao.w.wang@oracle.com>, monis@mellanox.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-2dDtBQVpbCgD/xtK7qaX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-04-26 at 12:02 +0800, Yanjun Zhu wrote:
> On 2018/4/26 11:52, Jianchao Wang wrote:
> > w/o RXE_START_MASK, the last_psn of IB_OPCODE_RC_SEND_ONLY_INV
> > will not be updated in update_wqe_psn, and the corresponding
> > wqe will not be acked in rxe_completer due to its last_psn is
> > zero. Finally, the other wqe will also not be able to be acked,
> > because the wqe of IB_OPCODE_RC_SEND_ONLY_INV with last_psn 0
> > is still there. This causes large amount of io timeout when
> > nvmeof is over rxe.
> >=20
> > Add RXE_START_MASK for IB_OPCODE_RC_SEND_ONLY_INV to fix this.
> >=20
> > Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
>=20
> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-2dDtBQVpbCgD/xtK7qaX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjarkACgkQuCajMw5X
L93d0xAAj+9kI9dpd+n3qjn4rOjfqG0V820I+WwQOEdFx19Be+UmbKN7nhifAuYS
O/MtDE7j5gng5DNhl0QAcWUNgypEdeb4gonVIhqrUuEvpXz70cQcIcvoZ4kF+7A0
Fp3cPTxG4h0wo8VLIh6AbZZT+Kr/umWJX6gAMiZEcVdsX5i//pV1/MJvvTydzYQm
cv/XC5rRj2FlV8LpIKUsG0x3INLqh9nTM4biGdx8AvB7Sm3cQbxZ3c4MHOhGyJWD
b8OKVlVAAtz2+uvqGfd2/+sgQeEWNfeUtETsfGOSPTx/08JV/HPS4C/rRmU2HuJH
ZwKXmDyi5LaYGrDdKSX4MLdVH1e9zRfcueJnbNKdJFen4g1MpthHQa7sxm1KlQcI
sj4rhHMVeuDWAJwmc5pHZnNKbRnbBPUdq92cSM2u2s5JVQlXgiN4yrzXPobZNWir
r9aJ2XPf1jmCz6f5LbtMkqWR4BEvW5i7BBzX7WNCeHUxLXIiX7lJeVz6RoHYJDiP
8Xxrlwe0iLTe83dJm8vhm6rfUWRxehWoqnDo7RU8L6JzXQLzDhjcquC7HC2kpheT
0CZod266e95iMQfBIHNBIIzyWNNVUuP3Z1qW9rS3dXDaU5UZpM/SJOMusu9cuFc/
rSFTg+qwOTwS6yohm47k57oGEVIcyHxiEiFaNubJMsAdIhTszD8=
=+zIT
-----END PGP SIGNATURE-----

--=-2dDtBQVpbCgD/xtK7qaX--
