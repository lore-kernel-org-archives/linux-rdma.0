From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] iw_cxgb4: only call the cq comp_handler when the cq
 is armed
Date: Mon, 13 Nov 2017 17:00:40 -0500
Message-ID: <1510610440.3735.46.camel@redhat.com>
References: <20171110182301.0122F8760@linode.aoot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QiErrwlD0l4cSIv6Afzt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171110182301.0122F8760-4JwuKsrtP3INXE9Dec0ohg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-QiErrwlD0l4cSIv6Afzt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-11-09 at 07:14 -0800, Steve Wise wrote:
> The ULPs completion handler should only be called if the CQ is
> armed for notification.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-QiErrwlD0l4cSIv6Afzt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKFggACgkQuCajMw5X
L91D0A//QBLoYLVOHR9ykC54JScnhH8ZoSKY7984DFPxLFj8vYoWOyM40Qu75mvZ
K6lq/3ZX8LdUcCoVCy/dn9iDS4NTU94Drshkgxh/V0vkOPOeBVLjZ4eRyuO9lCOQ
HCtnW4JTNsT5fgefkP1md7xrTa4FQyBCRVpuOqHsvldNYt4rPl4aFNrvFNFauDNn
qZWyzkazz7+FHA/76MpQtfMAnWoCNNnP6kNivxz70dO71BgtzVW0GTxiLmR30XJk
2XpuvtFiDgFUP0UsHAuTnJ9SqCZTEtXXzn1CgVITmTOx6oMCiHTmyux+65ss3vcg
yVZPVe1iFBT5NFahLEA9EslF+JvoNIKanh6gdnokHSN+eDUumFo1uBA+7vAcID7f
qGYIyeWaCSeJPCSxaJ5cnfSNq5miQQozmiw+J4Fsmu4QuW/nPt3lW9ZJkBnyGBjG
z850a+Oj0X+m4Bw0wqZfOsSZY6w8e7vhLElBzfc8zGeJjQoVjk3gVlf3P5hGiyHH
lO92Mrju1vsrbIELbpMWai4WHSD1QOK1R+QBxrsaf2atnW0FAm0jR8YQOJaB3ENu
EEmcUfXssscfwl42TBIFn3LGzrFP2E9+AOORe7wYFGHq00nRPpGLfUawV8K4c+wF
U+9uUSNkSw2XUinMkK5d922jLlPbrZ0e00Pq2fYexocT3LsEEfA=
=rYW7
-----END PGP SIGNATURE-----

--=-QiErrwlD0l4cSIv6Afzt--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
