From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 13 Jul 2017 00:51:16 -0700
Message-ID: <20170713075116.GA11233@infradead.org>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499894262-10761-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 12, 2017 at 03:17:38PM -0600, Jason Gunthorpe wrote:
> Sparse says:
>  warning: dubious: !x & y
> 
> Unclear why sparse thinks this is bad, but casting to C99 bool is the
> same as !! and much easier to read.
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
> +				     (get_cqe_l3_hdr_type(cqe) ==
> +				      MLX5_CQE_L3_HDR_TYPE_IPV4))
> +				    << IBV_WC_IP_CSUM_OK_SHIFT;

Meh.  This code is complete crap.  Please factor it out into a little
helper that mere humans can read first.  And then replace the odd ^ used
as && with proper if constructs and all should make much more sense.

Something like:

static bool mlx4_ipv4_csum_ok(sruct mlx5_cqe64 *cqe)
{
	if (get_cqe_l3_hdr_type(cqe) != MLX5_CQE_L3_HDR_TYPE_IPV4)
		return false;
	if (!(cqe->hds_ip_ext & MLX5_CQE_L4_OK))
		return false;
	if (!(cqe->hds_ip_ext & MLX5_CQE_L3_OK))
		return false;
	return true;
}

...

		if (mlx4_ipv4_csum_ok(cqe))
			wc->wc_flags |= 1 << IBV_WC_IP_CSUM_OK_SHIFT;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
