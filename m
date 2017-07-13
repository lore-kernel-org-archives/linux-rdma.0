From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 13 Jul 2017 10:34:20 +0300
Message-ID: <20170713073420.GJ1528@mtr-leonro.local>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ggMi11T3lbLnZZ+m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499894262-10761-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ggMi11T3lbLnZZ+m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 12, 2017 at 03:17:38PM -0600, Jason Gunthorpe wrote:
> Sparse says:
>  warning: dubious: !x & y
>
> Unclear why sparse thinks this is bad, but casting to C99 bool is the
> same as !! and much easier to read.

IMHO, it is because of usage "&" to compare boolean result.

>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/mlx5/cq.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
> index 500116133c1f9e..9a8d958a9ced68 100644
> --- a/providers/mlx5/cq.c
> +++ b/providers/mlx5/cq.c
> @@ -206,11 +206,12 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
>  		if (likely(cur_rsc->type == MLX5_RSC_TYPE_QP)) {
>  			wq = &qp->rq;
>  			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
> -				wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> -						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> -						(get_cqe_l3_hdr_type(cqe) ==
> -						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> -						IBV_WC_IP_CSUM_OK_SHIFT;
> +				wc->wc_flags |=
> +				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> +				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &

Those "&" should be &&.

> +				     (get_cqe_l3_hdr_type(cqe) ==
> +				      MLX5_CQE_L3_HDR_TYPE_IPV4))
> +				    << IBV_WC_IP_CSUM_OK_SHIFT;
>  		} else {
>  			wq = &(rsc_to_mrwq(cur_rsc)->rq);
>  		}
> @@ -1105,11 +1106,11 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
>  	int wc_flags = 0;
>
>  	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
> -		wc_flags = (!!(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
> -				 !!(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
> -				 (get_cqe_l3_hdr_type(cq->cqe64) ==
> -				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> -				IBV_WC_IP_CSUM_OK_SHIFT;
> +		wc_flags = ((bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
> +			    (bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
> +			    (get_cqe_l3_hdr_type(cq->cqe64) ==
> +			     MLX5_CQE_L3_HDR_TYPE_IPV4))
> +			   << IBV_WC_IP_CSUM_OK_SHIFT;
>
>  	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
>  	case MLX5_CQE_RESP_WR_IMM:
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ggMi11T3lbLnZZ+m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnInwACgkQ5GN7iDZy
WKcrug//aOBj0ExXqK5IApPPqnmQIdkOtiMh6UhTWVla+J/b5K1g9xpn2UApGSPw
MvWEyC07cs9BGczx8kV0UFw+RACwaf5i020+TddkfUFtrNjn/OdzkcGkqiCTJRih
Of4XRek7UxhgVCuj4d+04GU9JTlFVNjwjelGUMaZ1zf0GBHPK6pn8bsiI/EdJ6H4
6x49t/nLpgD4Itf0+6DDEXARjEWwJx9F+Yp7cUlvHlp+7LC3WW0fPD6ZkAlUbT6e
PsuONDKY3sfqVLPw8FRmz0qqrT0hNi8UM7SLBAAoXp+GwHQMshLZr0ix9UX4D5Bg
b6BRtrhrJcf16BWxOik3ZtxRY5HEHsjQOdNU0fpfFDvLh5nIQwRrvdfYvd6yBY0A
Y8dViFRmlI7h6RQfHn7PFjV/eeek10ccyw5sERGFH9z4GMZ60o4YctcuqKJh13xF
bdSR50muGSPh06jEYsO7AEeMQGFZqf6wNv6et4CvNMpsKLttrf9hRDxrRFGZ2DQg
e8uKcSluNzpI+MIczLsHPP2TtB/32/sRlbEs0PxlJOALh2Dp9gvZo6tD0HdkCy/V
NbmIzSIk40Ac6Tq/Lv2yD7T39hPB8SS3ou0hXLFgqNpDjhkwysjFjmqHpOvQJs/J
/WsNoD0+8U/DEkOMJQvHtV8oOKON3aoxxJvNmA9IB6TGwXqEAVo=
=L6M7
-----END PGP SIGNATURE-----

--ggMi11T3lbLnZZ+m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
