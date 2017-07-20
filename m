From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 20 Jul 2017 17:23:32 +0000
Message-ID: <1500571411.3181.4.camel@wdc.com>
References: <1500570064-11712-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500570064-11712-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500570064-11712-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <A7334186F1087C4D9892286D37281A9B-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-20 at 11:01 -0600, Jason Gunthorpe wrote:
> Sparse says:
>  warning: dubious: !x & y
>=20
> Unclear why sparse thinks this is bad, but casting to C99 bool is the
> same as !! and much easier to read.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/mlx5/cq.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
> index 500116133c1f9e..9a8d958a9ced68 100644
> --- a/providers/mlx5/cq.c
> +++ b/providers/mlx5/cq.c
> @@ -206,11 +206,12 @@ static inline int handle_responder(struct ibv_wc *w=
c, struct mlx5_cqe64 *cqe,
>  		if (likely(cur_rsc->type =3D=3D MLX5_RSC_TYPE_QP)) {
>  			wq =3D &qp->rq;
>  			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
> -				wc->wc_flags |=3D (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> -						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> -						(get_cqe_l3_hdr_type(cqe) =3D=3D
> -						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> -						IBV_WC_IP_CSUM_OK_SHIFT;
> +				wc->wc_flags |=3D
> +				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> +				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> +				     (get_cqe_l3_hdr_type(cqe) =3D=3D
> +				      MLX5_CQE_L3_HDR_TYPE_IPV4))
> +				    << IBV_WC_IP_CSUM_OK_SHIFT;
>  		} else {
>  			wq =3D &(rsc_to_mrwq(cur_rsc)->rq);
>  		}
> @@ -1105,11 +1106,11 @@ static inline int mlx5_cq_read_wc_flags(struct ib=
v_cq_ex *ibcq)
>  	int wc_flags =3D 0;
> =20
>  	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
> -		wc_flags =3D (!!(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
> -				 !!(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
> -				 (get_cqe_l3_hdr_type(cq->cqe64) =3D=3D
> -				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> -				IBV_WC_IP_CSUM_OK_SHIFT;
> +		wc_flags =3D ((bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
> +			    (bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
> +			    (get_cqe_l3_hdr_type(cq->cqe64) =3D=3D
> +			     MLX5_CQE_L3_HDR_TYPE_IPV4))
> +			   << IBV_WC_IP_CSUM_OK_SHIFT;
> =20
>  	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
>  	case MLX5_CQE_RESP_WR_IMM:

Hello Jason,

Since patches 4 and 5 touch the same code: shouldn't these two patches
be squashed into a single patch?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
