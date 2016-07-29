From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V3] Add flow control to the portmapper
Date: Fri, 29 Jul 2016 07:47:46 +0300
Message-ID: <20160729044746.GT4628@leon.nu>
References: <1469736146-17640-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OelmujB7rQAg+yu0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469736146-17640-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--OelmujB7rQAg+yu0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2016 at 03:02:26PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> During connection establishment with a large number of
> connections, it is possible that the connection requests
> might fail. Adding flow control prevents this failure.
> Change ibnl_unicast to use blocking to enable flow control.
>=20
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>=20
> V3: update to use blocking ver. of netlink_unicast() in=20
> ibnl_unicast(), instead of creating new function in=20
> netlink header for this purpose; as was done in V1.
>=20
> V2: update commit message with justification for flow control.=20
> CC'ing linux-netdev mailing list.
>=20
>  drivers/infiniband/core/netlink.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/=
netlink.c
> index 9b8c20c..a6b3acb 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -229,7 +229,13 @@ static void ibnl_rcv(struct sk_buff *skb)
>  int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			__u32 pid)
>  {
> -	return nlmsg_unicast(nls, skb, pid);
> +	int err;
> +
> +	err =3D netlink_unicast(nls, skb, pid, 0);
> +	if (err > 0)
> +		err =3D 0;
> +
> +	return err;

It can be simplified a little bit to remove number of lines.
4 last lines can be replaced to be one in ANSI C.

return (err < 0)?:0;

--OelmujB7rQAg+yu0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmt/yAAoJEORje4g2clinQd4P/2c0xHk8MxnEF+Jj47T0RT+s
LqTJuP3kP6ZOvr1fxKRplAmiQxDZQR7aIjEaAYVg0dhDYPiDsAJwpzjLzqPYx/D1
bIk6/aiZY07w9fGaji0tt53HK1GHQRLSXDEHlsM7WlPMJU3yxE4mIG42jjLaKUdS
BNixdWZq/caUUW+9V0ObRk3EwtVrUoMOVNLnOE2RLsHcUGhupemeH/f5i6jrDags
r33R06PQGRIkUnlUhsM6Z+ozijW+FJIxbtJVlUisOATN26MSKD4VoAFftsyVgH+G
iEB6wNZEgS54zbrHz4C0fVPL4DS93ttPBTNZp0lWD5i8p0YVrDEhWxIbjLQzFk0Z
GLe8euZncxpp9vxCbJeaebounEwBS4z+2Dhh65EQRTOcrUJjzmtPcP1Jlb98vQiQ
lILkg77Ml5dIIpvyoX5ls1T1nyjr9eSO9oZvcObbR2dt4CYrqAs5c7WtBx26GFFG
bhKMQeA4NLKYCo/4obMTZDTh4yOZeJOtXdY9LRLbM3whhRYCLlTQHPZR7eByspyU
jv28RY2IzF/dkkB0OLpxiHejN5xEOU/dnkSwwCnDtm1lRMp55423wrQJkI1zcLj/
douqN2+1IS4w53/w2dIZkylpVEI4lpgtBCD6wmTwLQwoj4InpDh6Kqvn/SNd8aUJ
yc8dBabpbUN2kcTVZtV5
=OpNy
-----END PGP SIGNATURE-----

--OelmujB7rQAg+yu0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
