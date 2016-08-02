From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allocation of CQ resize structure doesn't need
 to be atomic
Date: Tue, 02 Aug 2016 13:52:56 -0400
Message-ID: <1470160376.18081.25.camel@redhat.com>
References: <1469768323-8093-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YOZIvniFUwuHiSjG6/8Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469768323-8093-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-YOZIvniFUwuHiSjG6/8Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-28 at 21:58 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=20
> We allocate a small tracking structure as part of
> mlx4_ib_resize_cq().
> However, we don't need to use GFP_ATOMIC -- immediately after the
> allocation, we call mlx4_cq_resize(), which allocates a command
> mailbox with GFP_KERNEL and then sleeps on a firmware command, so we
> better not be in an atomic context.
>=20
> This actually has a real impact, because when this GFP_ATOMIC
> allocation fails (and GFP_ATOMIC does fail in practice) then a
> userspace consumer resizing a CQ will get a spurious failure that we
> can easily avoid.
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=C2=A0

Thanks, I reworded the commit subject for length and applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-YOZIvniFUwuHiSjG6/8Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoN34AAoJELgmozMOVy/dxc8P/jzOYDB5qDHM70anHEQ0Uzc/
ahZAoFRMC7V4qiPcTpNNO2lxNEXSREQ2Go40LFsMQqcti7EUzUXJn+9NI+vzO1+E
/7ltaFs44edIWuK7O3sZdmKyE1MOmM6iVsMH/Ukb9kWHhsYTc3AVhfPBjAhYq9UG
sANDWJiY6sl8MqTHCwFFpPk8mKI6NqFnRZNzQvcT4UFiNYXKX/EZIcKcrq0ddHAp
j3nLltuBGBi27pr/sdduHBGQaIUQDN3quUbsu0FT6yaqJPeaCoiXnvTjXiBQJ6+K
t9XBFvPlt09IO8xho3m+iQO/26VPWNthdDzeVe5kEcmZE9XWIhhcRu+iHVMq+Rj2
jf22Z9MS4Muqc+xyog+9S+J0kzeLBQq0F+oI2xW+8EBT3FBmZyGQcYWo0byHa7Mv
GrH7DQ2mu23O1C/U/71hhjTyDDCGgze0Xt/hQpXkYE0ujNuEndDG5QQhZNWinWlD
G0K/zDTTVFbsKWZLsQsjOaNVujQetw5ECGV0ycf7sUyXZJ8WcaP9sGE9U4KruLqh
0eiejX8B46qjCCyeGJfoUiAZPMK33JTbMp4NVFjrfigxuVPDPQls+zCs8rnJWaQT
9CGqtQ6j9b4vqycWIBNuJLAc6aJi1SwKc7y9A0M/rA8mCB3fAJyaEYJKqQvFYnRV
wjnsi1TPMFPaXUVajw4Y
=a6hK
-----END PGP SIGNATURE-----

--=-YOZIvniFUwuHiSjG6/8Q--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
