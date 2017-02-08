From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] IB/rxe: Fix resid update
Date: Wed, 08 Feb 2017 12:39:39 -0500
Message-ID: <1486575579.86943.15.camel@redhat.com>
References: <20170207134305.GJ11103@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Y/61MU0P/K2YZSZnUADN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207134305.GJ11103@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Y/61MU0P/K2YZSZnUADN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-07 at 16:43 +0300, Dan Carpenter wrote:
> From: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Update the response's resid field when larger than MTU, instead of
> only
> updating the local resid variable.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
> b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 7bf20ced2078..d404a8aba7af 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -479,7 +479,7 @@ static enum resp_states check_rkey(struct rxe_qp
> *qp,
> =C2=A0				goto err;
> =C2=A0			}
> =C2=A0
> -			resid =3D mtu;
> +			qp->resp.resid =3D mtu;
> =C2=A0		} else {
> =C2=A0			if (pktlen !=3D resid) {
> =C2=A0				state =3D RESPST_ERR_LENGTH;

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Y/61MU0P/K2YZSZnUADN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYm1fbAAoJELgmozMOVy/dKGIQAJkcStfKkJzHbpiDr8uZAhNE
1KUoHsy8g4Uxo+mAm3RGti59TigDSGo4siUXO6q8XQPWbuZ/NTlvgnGmPWthghk/
R8C62dNc09NH48DQWcvQ6Ux2K7D2HLlPdOb/LExtnDDVe2ZFOURUhMPDTw/LhWVH
yb6/qZT+rsdt/Zs+566eUKJUyF0VSabbZ6TTaWHsa4675HVc0TBtbGQrPi1Dtq4b
5DwtH2Wn+wvPUmqgTOgOptBe6ZJLNPAhDMUbDzu0iZGMRmNHXLBHeYHOVj8HQCil
HHLCsFUj+LU4AY59tm/Ylg/osJDPW6rynt/qTNsSiILgeeK2+5o6teAs0D9gSC5O
QfQhMzT/2GlQynT6eexjn2mDfs6unvGRn+hqJk2udFbmROo59Baw5PhM7ErRygbJ
21jkNNdNXE4Y3JEBvotTnjeZJVxuhtmjgmurhefBTmdmU/qgdYg2Sz9mkBLK/73i
ubaxy+PzCImKlLpwXF/6suo7IS3vxmHt/I6Rt9OHG2jFY8AqD3uKjlVrDU3y4DIR
ye5x0YZ4DhkcGsvhstU/Jz7svU3CvQYSowVjZWtbWPSFfktqhzGjr6MtVxBHNjT3
9JGUtBbHoo5Sx+uCT8yxzENmBTwdRxjqfJYVa1OvIzW7hsnFi1robjlLTiIxjTj1
IIfOI+7MUG6QZmZh87SS
=xNBP
-----END PGP SIGNATURE-----

--=-Y/61MU0P/K2YZSZnUADN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
