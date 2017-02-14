From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Add port counter support for
 Receive WQs
Date: Tue, 14 Feb 2017 10:30:14 -0500
Message-ID: <1487086214.86943.74.camel@redhat.com>
References: <20170118132510.4586-1-leon@kernel.org>
         <20170118132510.4586-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-a/1Yb/8oUBPah8cYKGF2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118132510.4586-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-a/1Yb/8oUBPah8cYKGF2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 15:25 +0200, Leon Romanovsky wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Counters weren't updated due to Receive WQs' traffic since the
> counter-id was not associated with the RQ.
>=20
> Added support for associating the q-counter-id with the Receive WQ.
> The attachment is done only when changing WQ's state from RESET to
> READY in modify-WQ command.
>=20
> FW support is required for the above, without this support
> Receive WQ counters will not count.
>=20
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-a/1Yb/8oUBPah8cYKGF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYoyKGAAoJELgmozMOVy/dfDUP/3Oo1KRzw27PCuaeur1/ATBp
+Mvo30IV8D5/D8N9Jz4JBUaIGnFAAS6rrdEP9CHEZFtqzc4K48YJEDwgScvr3Uw/
Ngx5TL1HFFqBL1FkePiZzaxjSJiXP00q9SeZKylm0XJajhlUJYOoxknQt8PbpmYd
ywEvHF7oM/RO6wwL2AaTI1w25kFMoDIKeej+kD77FkMFI/5uhxLsiZTmaHGHAyMg
iWU/8FFSlCgwgROgqZ3lIQeoPUKkqW6jJcjxA/GksoDie8VTM/N/6HIJoDIE32jC
okdqY91m6UjE/XIuQuFrXLyrcffKckfuQq9RsGCnR00jE+kKgkrheyxafRlKZBBg
3Q/LBPo4O6HePh8grq+wsIHQYQx5QZ2zb9pR8HLsN5LntZjRD32SLq3/sMNgb5rN
0lXlHdMAXYNUZtx9ip5r/xjWBfbRVVi5XWAdgtKe1TuxtMOt1NDj2vcTMB05H4ed
XlmJw0KJixANGGSH1ExqKBArQ61wlwfQShk7yIi8PFsrQXZrbb4PjTk0iHMKr0xW
PjICZkpvvh1HGzXj4N2CCoQP73NrFq9CHdZLWU8qqvBoxnym7xd1Ue/S/+Kf/iBm
bLp1uFTrciKtGZjLpmd/gWmD8zcx3n1ikOZ3H11Jp6Nwrc+9ZTw2OkX1L5n9F6Se
W6s8iZBtfMwo+Bh5Mqof
=vKQj
-----END PGP SIGNATURE-----

--=-a/1Yb/8oUBPah8cYKGF2--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
