From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/rxe: change the function to void from int
Date: Wed, 31 Jan 2018 14:35:56 +0200
Message-ID: <20180131123555.GY2055@mtr-leonro.local>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
 <1517396819-29597-3-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SSJ6yXlPvEk0CmSI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517396819-29597-3-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--SSJ6yXlPvEk0CmSI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 06:06:55AM -0500, Zhu Yanjun wrote:
> The function rxe_av_from_attr always return 0. So change the
> function to void.
>
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c    | 3 +--
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 2 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 5 ++---
>  3 files changed, 4 insertions(+), 6 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--SSJ6yXlPvEk0CmSI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxuCsACgkQ5GN7iDZy
WKesXA/8CMnES8PRyxRbsO1PVfgw0Im8EMvidKzLVbm6xfz0JTGggdB+Xig2bKSc
vIZxnbA2cb+a6rpEeVppEyKsUCZZ3HOXurcZPetXeILhmkwJ9HGYtbNXuOTxQ3x7
Qg/GV+XVVSWdYnx326S4wO08AQqADerLw1EJ4iVLUQHShHLwhA4g3iUBOikbAoec
QmJh39ib5E1i9sSTUiq7fXlPnCINfJJm8kBaxhXDFTnn9iKZPtfgKPdb+EE46gTg
lBJenXB7yK45XJQyrCLCLgS85WklA9lIKBXtjbLtX+V9PXmWe4meWkPr4RecJeV6
8+0sc34X8a8yn/1Ti/8mJOk4ELPXk0/KxCSIeNATdUyXuRTokZHm/5aAbYuWwFFj
M4Gk10IL0lRuksAdfwVCTp2ugPJxZR9abPSmc4m3OeWkuImSb3SdCE9RgXPO3K+A
y4PRz2u/+z80O6Vp0zFBQ0TSGgkS+RtS1aIVF2fOq682asiSfBOw7VJxDcHTkL4R
X7Nn4+5sKSo+HWLoeL5kEDv0VQO4iEL6UldmGBUWOpEljXb6ASXnQNPhAtD6peqt
c/8ovYig9YVTd1Iw1ixVKYNPRA0C7FlKq00zW1OkTTCBZPZyMeZ3csryiGmdRPjk
Y5i1T/QpWYpRUO87RdrWS9ANKZwH7zRM1kDwwos3GrHUm3ciDfc=
=Lhzg
-----END PGP SIGNATURE-----

--SSJ6yXlPvEk0CmSI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
