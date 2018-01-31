From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/rxe: remove unnecessary parameter in
 rxe_av_to_attr
Date: Wed, 31 Jan 2018 14:35:46 +0200
Message-ID: <20180131123546.GX2055@mtr-leonro.local>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
 <1517396819-29597-4-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aTHdXM4WpLndGb15"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517396819-29597-4-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--aTHdXM4WpLndGb15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 06:06:56AM -0500, Zhu Yanjun wrote:
> In the function rxe_av_to_attr, the parameter rxe is
> not used. So it is removed.
>
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c    | 3 +--
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 3 +--
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 6 ++----
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 3 +--
>  4 files changed, 5 insertions(+), 10 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--aTHdXM4WpLndGb15
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxuCIACgkQ5GN7iDZy
WKe6Ug//bFCT8JlkO7K1ni/pR8c2dXU9lN6AJd5WwNgfxU+3bT7IIWjLILYpxQPW
Q1eJ2Eno8kQAz5utapzhT3yEbGRs5ihKQ91guibGpY/12/zvXGmF2xoB/L/dn4wc
sEQX6TxMFmthL7GSsfxoWEkb5yxvJl4xPsnOomPd37mvBfskTmG4RKLy3bsPog2+
dxkfTD3GBn/S2cwe7XmimY0jGC3dBpdu/8KlNM1RbMaNcgXj5DdrtA5Z9mBgFVJk
CFIeZrdiAivpMdkWifZ91I0Wk1Z0JKJvI/Bo0kcjhv1Zch1Ej6vHZRPgk1YGEtH1
j26lpt3DQJjK2tsrRyS1P5H6W+44T+orjhw2+/mQt/HkeZ/Xkonn0xDWB4viSuDi
nPnSr4uufZJoTibvtVa3HcMHlXSQHtim9oQ9GCznJDAliweOfLA6cMTsvGZ10ss2
uGOSzHG0M2c4PYcQBog2aEqJYtcbtlBTE4vf7PzsSsX71rXwPBgyOmROfjYBq1/X
bzO3nYQHchUlD8pvzJWqDRMN9nAPQmnXrLFB+6M2KvOYnyaSkmLzr5ENKzgo+2V/
9Y8gCuSiMNAw2WpbnZcETF23ZTtlk+cozmHdDeVRseRB1JxmvX2GFAQRIS2mSOjk
KZt/aHRfCsKumDnqmCcc6Qr9hAw7x7nUt9lIIcWc99e3YahLufs=
=/t05
-----END PGP SIGNATURE-----

--aTHdXM4WpLndGb15--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
