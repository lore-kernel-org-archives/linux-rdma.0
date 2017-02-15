From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1] IB/core: Remove pointer casting from void
 to net_device
Date: Wed, 15 Feb 2017 09:54:30 -0500
Message-ID: <1487170470.86943.91.camel@redhat.com>
References: <20170202051408.21839-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Jyey4jwnlEtVn6QB/sUP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202051408.21839-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Jyey4jwnlEtVn6QB/sUP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-02-02 at 07:14 +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patch avoids unnecessary type casting from void to net_device.
>=20
> CC: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Jyey4jwnlEtVn6QB/sUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYpGumAAoJELgmozMOVy/dn8sP/jR+EfL5vu04lHd7mesauf7R
I0buAn6y5RkZf+1o7/RWJg8En7XWGo9hPT6YNVVqiHmNXMF1TiZjNxGOyjPXhG2Y
YBuLdv2DEJERZFREV2uwpgxltfgvlraCnsJubUEQ2CKKQVC0STJrzq+VGO60RO4d
38qfpadUX9B4eU5tmCJi4mOBX7F7vTX0KUN7KfMHgiKo98L4MHuHPEFesD7Pet2B
v8jmg7KFuo9GkRvCyVaBMtk81fsrLz18BRXP5xbQMy5gca5+pZ9JDhSX7rnEjTjt
JBdE0p+n3ijYV5pI25AoR5drEPA0szxtKDrkxyMQXdao9nEOS5J3habjkrkdEd1t
GZoiT2LYhd4nRhzjls3tPP4FSLrBMnAAdFadkLznbmrI//Hr0rySLIdKmpIyQ/7w
lzlG5YHF3RoQ4u0VoTs2OH42R+CitTV56qPXAuEHm4sWnr8h69jxMUZr5r1Hp4VI
YGDTuCI4G5OHD3+Pm7nwxmN2iBq1cK2cQsvfRRAZjUlxNWks6i6jxomdssZfpI4c
Gry0oDgfpduRJ2MT9Eth2TdUl7KAv+/8vJNDmU9sy5FBlQRK/20XztCKF9stvKZh
a15eZ3Aax8dSU+KLolbxbaQ8DxCBBuDxPbhXrNjva6V1nItPdkBCYnMCgAMjOOtY
4+M+P27avM4/ud6++VV/
=KPib
-----END PGP SIGNATURE-----

--=-Jyey4jwnlEtVn6QB/sUP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
