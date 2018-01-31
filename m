From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] IB/rxe: remove redudant parameter in function
Date: Wed, 31 Jan 2018 14:36:05 +0200
Message-ID: <20180131123605.GZ2055@mtr-leonro.local>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
 <1517396819-29597-2-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Chn8nxio6L/4biUD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517396819-29597-2-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Chn8nxio6L/4biUD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 06:06:54AM -0500, Zhu Yanjun wrote:
> In the function rxe_av_from_attr, the parameter rxe
> is not used. So it is removed.
>
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c    | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 5 ++---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
>  4 files changed, 7 insertions(+), 8 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Chn8nxio6L/4biUD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxuDUACgkQ5GN7iDZy
WKct1hAAhlarVNTYw7r0rWf3tbkV9GDTPNAfIyLEiTS/ABtxUemMnMGmYY4l26rC
0WMCxC6A6NS7aCRrZjHZZLGnuZGoWKPZHXsFDS8t5iJyGyD0POxGEgtvthae9WSi
oQ9arjrdnsZQNDk2Ck9wow1tvG80vtP1EVuCqrvu61eB4SDq97RYNdPMIFNb3dXm
qjG0dLIUjVny2dHWCBVTDpKBav4rsJph4vNPCrKBhj1unC9z4uTCaL5iuLGdHq4p
zOQq0LlhHths3Skl+W75Qe6MVHI156MTCsSAvs1VRXM7aorzWNiOrgAVpvm5d7DZ
T9NDkVBEMGgV1pz6Yr+1SjDlvff1tfryx9KQaU+CQtVxo2zrMNMxVfA71O+LbNLL
kzKJgp24fWCwFLlCNIWAcomEiPkXuMbyd9uvpTFIbSueD5hGvWMHW8S19YlKcsEt
2YsP2io9N3vHuzXxUQ+guKGXG8G/iLje41UdP4vABkJOM2X5uKntDFkq8xYY4Bss
vmXYy1OAIfaA7pmQVwwzKGsMuseVIEaKRx/8q9fc7Nr7lYH03JdJ+IL3SpOssYiW
EnRL58fvie6g1yNgGSnsijE6erWidGhw5ELpD5cdMTO16sMOu8+BLk099K2qytiw
XY3eIEHn9uWrVPSMaD+kfisyzUC4UOmV5an1PjXG9zcucn1ECzo=
=j9jZ
-----END PGP SIGNATURE-----

--Chn8nxio6L/4biUD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
