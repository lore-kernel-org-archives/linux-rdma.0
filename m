From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] RDMA/bnxt_re: Do not free the ctx_tbl
 entry if delete GID fails
Date: Sun, 14 May 2017 09:10:15 +0300
Message-ID: <20170514061015.GP3616@mtr-leonro.local>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-10-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xNm6VWMD3PcA105u"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494413139-11883-10-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xNm6VWMD3PcA105u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 03:45:34AM -0700, Selvin Xavier wrote:
> Do not free context table entry if delete GID fails. Stack may call
> back the add_gid for the same context again which could result in
> panic

"may call" ??? Will you leave memory leak if this "may call" won't happen?


>
> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 61703f3..525f4b0 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -375,15 +375,17 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
>  			return -EINVAL;
>  		ctx->refcnt--;
>  		if (!ctx->refcnt) {
> -			rc = bnxt_qplib_del_sgid
> -					(sgid_tbl,
> -					 &sgid_tbl->tbl[ctx->idx], true);
> -			if (rc)
> +			rc = bnxt_qplib_del_sgid(sgid_tbl,
> +						 &sgid_tbl->tbl[ctx->idx],
> +						 true);
> +			if (rc) {
>  				dev_err(rdev_to_dev(rdev),
>  					"Failed to remove GID: %#x", rc);
> -			ctx_tbl = sgid_tbl->ctx;
> -			ctx_tbl[ctx->idx] = NULL;
> -			kfree(ctx);
> +			} else {
> +				ctx_tbl = sgid_tbl->ctx;
> +				ctx_tbl[ctx->idx] = NULL;
> +				kfree(ctx);
> +			}
>  		}
>  	} else {
>  		return -EINVAL;
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--xNm6VWMD3PcA105u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkX9McACgkQ5GN7iDZy
WKcWQhAAlze6uJhB2eCNs8Ogr+z3UVunQXQFx373F8judUeCQckUepJxTlQyHhRS
kNBDXkAz2HtfqlNoPEHoMUlQP6Aekic4KpfNesmUZvweP3BK3gNBbgpve+Pdjx9g
TnnbxYvFSdg5mrQmMuMcEGeLARDXDvzaiSRFPghsurOqn6GQfTFrIspSYLy5dCwl
3PlMnp4jot6QkQHDeU6KxPQ91Dw7axqv6+WfBC2gfBYhKCWIaHAZBApJE47aLnb7
X8yIEEwwmhY/xylCwtcJ9qDram7bDrPSUaEmwKhLX8kh+i1l3Bwn5oBF6Lu42qrX
NK8UERm0MDiuFYMfpW+aW/I6vGbS8a4VDAULbjOVxI54n40C1/7GPA4k1o8j2eZ4
RopPv1yFq0HAHqXZLBfHtSoPhbn2yyhQkUg5sWfEwlNdwtU3y44p64cfEbCrLzak
IzKsHlQpkNQnm51ZktVQUjDyIN9/Vg4QEQzuDoYX9b6Va1/a7kPhPB5CahcNOmFx
SwbYvD9Q1OwzWW/Sc9pMVznWimOxIE3ifVkGbblNWoqLexQM0a2MLkIXi70yH+Ow
8iha2YFBx4/yvUa014/GYuFvKDvLT9YxQ4SLgV/n5+2A2gUPykmbsXAn+WlpD0EE
UGK1q8gZsBeic886d/nCvTY9ODrgiJKpmZ6mhrOcncAwkWWNzrY=
=tjSB
-----END PGP SIGNATURE-----

--xNm6VWMD3PcA105u--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
