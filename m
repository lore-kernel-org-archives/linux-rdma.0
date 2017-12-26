From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/6] RDMA/hns: Update the usage of sr_max and
 rr_max field
Date: Tue, 26 Dec 2017 13:55:17 +0200
Message-ID: <20171226115517.GE10734@mtr-leonro.local>
References: <1514287514-88723-1-git-send-email-oulijun@huawei.com>
 <1514287514-88723-3-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+JUInw4efm7IfTNU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514287514-88723-3-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+JUInw4efm7IfTNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 26, 2017 at 07:25:10PM +0800, Lijun Ou wrote:
> This patch fixes the usage with sr_max filed and rr_max of qp
> context when modify qp. Its modifications include:
> 1. Adjust location of filling sr_max filed of qpc
> 2. Only assign the number of responder resource if
>    IB_QP_MAX_DEST_RD_ATOMIC bit is set
> 3. Only assign the number of outstanding resource if
>    IB_QP_MAX_QP_RD_ATOMIC
> 4. Fix the assgin algorithms for the field of sr_max
>    and rr_max of qp context
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> V1->V2:
> - Adjust the write way for if branch condition from
>   Leon Romanovsky's advice.
>
> V1:
> - the initial submit
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--+JUInw4efm7IfTNU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpCOKUACgkQ5GN7iDZy
WKdSvA/+P7/XC7DY5LLanWDNGHqTHue7q+ok2ETBvFsgFkU9+s3z95iD0P2PlPlf
SnDGNF4r0jhswxZznHMn8FaqKEccy01wbNjF6fH9GhUgPCkxR0onu6z3Xqj19f00
GKTntYaNxgiqjQQkdRdtmRel+UZTDN6X96XT/xgaJslf5iQlPm5KC9ZShZL/ehsD
v2VN5gBJ6/eTTIaOc+bvi0UhEJZJ9dLtS4deeO5uMVTGu4Q1HviTxrH7pLpTq4ef
E4scyeeY+xVD/ETRLk0Cil7XHUQmzsnJ9q42wqaBs6p5fSolGlU7LcjachUkbMyE
Q+gy3agWGAy9oodnN30oP47q/+JVHalXBM+yYDfhhVygSrZY5Sxb4ER/AibQBgoz
mT5TcAcMypKIwWR0jOf1xt4lVRx0soesVIXFUUtgcujEOkMdHgBVZzJWFc4Kj4Kt
e1cVMt6oKlUoSVLPHm5hz/gN0XwrOWFlwnNbvL9I5C28aY6pDhM3ZsXCvVb3o/x4
uPmLb9kKcOan6JNqQgGQzbwMd9Pru6lEpSF3viQUTCLHF90IjHfKRBSpVC+fpHUW
8apVOJUwIKwp2VybD0wNfXOIjOCSBKBDnaWvO9jthpHPWWWUjf+65jRSgknyKHLD
3I9EdcJm1KfQFxulRtGEZ9qYOo6W5xfVqXD/X9nf4GiQtuFi3YQ=
=JguB
-----END PGP SIGNATURE-----

--+JUInw4efm7IfTNU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
