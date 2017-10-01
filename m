From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] i40iw: Do not generate CQE for RTR on QP flush
Date: Sun, 1 Oct 2017 09:19:28 +0300
Message-ID: <20171001061928.GD2031@mtr-leonro.local>
References: <20170930012942.9128-1-shiraz.saleem@intel.com>
 <20170930012942.9128-3-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170930012942.9128-3-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 08:29:39PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> If RTR WQE is posted and QP is flushed, a CQE is
> incorrectly generated for the RTR WQE. Add code
> to look for the RTR and not generate a CQE when
> QP is flushed.
>
> Fixes: 280cfc4b74e6 ("i40iw: user kernel shared files")
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_uk.c   | 13 +++++++++++++
>  drivers/infiniband/hw/i40iw/i40iw_user.h |  1 +
>  2 files changed, 14 insertions(+)
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
> index 0aadb7a..28e6d9e 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
> @@ -821,6 +821,18 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
>  		I40IW_RING_SET_TAIL(qp->rq_ring, array_idx + 1);
>  		pring = &qp->rq_ring;
>  	} else {
> +		if (qp->first_sq_wq) {
> +			qp->first_sq_wq = 0;
> +			if (!wqe_idx && (qp->sq_ring.head == qp->sq_ring.tail)) {
> +				I40IW_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
> +				I40IW_RING_MOVE_TAIL(cq->cq_ring);
> +				set_64bit_val(cq->shadow_area, 0,
> +					      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
> +				memset(info, 0, sizeof(struct i40iw_cq_poll_info));
> +				return i40iw_cq_poll_completion(cq, info);
> +			}
> +		}
> +
>  		if (info->comp_status != I40IW_COMPL_STATUS_FLUSHED) {
>  			info->wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
>  			info->bytes_xfered = qp->sq_wrtrk_array[wqe_idx].wr_len;
> @@ -988,6 +1000,7 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
>  	I40IW_RING_MOVE_TAIL(qp->sq_ring);
>  	I40IW_RING_MOVE_HEAD(qp->initial_ring, ret_code);
>  	qp->swqe_polarity = 1;
> +	qp->first_sq_wq = 1;
>  	qp->swqe_polarity_deferred = 1;
>  	qp->rwqe_polarity = 0;
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
> index 84be6f1..995b8eb 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_user.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
> @@ -376,6 +376,7 @@ struct i40iw_qp_uk {
>  	u8 rwqe_polarity;
>  	u8 rq_wqe_size;
>  	u8 rq_wqe_size_multiplier;
> +	u8 first_sq_wq;

Isn't this supposed to be "bool" and not "u8"?

Thanks

>  	bool deferred_flag;
>  };
>
> --
> 2.8.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnQiPAACgkQ5GN7iDZy
WKcOsA/9EzOismJVfp8rqEsXIsi7tNoLOT2X+7QLGGlD4ce+qVQ+vfDdYf7s2D9c
3e0WP/K3N0J84hRH9I0hWOr0ATZQSsB/N+WImFzYcK7KRboTZziIMqINl+I3FzWt
tRoXJWQsPmN8bpmXRs+7eKA76oHmVStqme1frh2fIYUlQHITqOpMivSgsaJH+iAo
doL7Pk8/YKThrpYOfKBIujo2/odcyW+Xo0YEgTsT7Y8+LyvYBEz0f6vuBx6i9XcN
DP98wtHhTKPRSo1L1e95sOHnmELXam53T+xleJnf1Ojndpzl9gbMAwXTWPHe/ZS3
14nX4R7kVBsK+5co5deZbzT83L5GGYry2VMmAs51DkutnRBHzQwwZm1bbZQaUY8f
g8daKxLekS/apGEk5NXMCWo2+agk1PEqhYSwLXrUhFtPTarFj8xdVtQXvY/XrCHI
3Nba9+rUpv6Pu2cGjj0pkCDrWO81t59L2suzM/lEyJjYy3Refnae/4Nf7EF6mdez
ID3/wA5A5leLcLRw1iRfV0NjdeiY2nRfJ2VnpYSB+l/Aq5EpeQt6TZPWgwj/AUiW
xJgzz8tJ1eUUszUwRpps/nOVk4RKNweZfuQF1hKV6f0FDzEDeWa3Bl9NIlIt6dsl
67xbbI1ePnDDTTmaZhMCJ1mO5XeuC1USOnZl3Aeouka4WvLTU60=
=f+vo
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
