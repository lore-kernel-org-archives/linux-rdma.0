From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx5 3/7] Add inline functions to read completion's
 attributes
Date: Wed, 1 Jun 2016 10:24:52 -0600
Message-ID: <20160601162452.GB15186@obsidianresearch.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
 <1464788882-1876-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464788882-1876-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 01, 2016 at 04:47:58PM +0300, Yishai Hadas wrote:
> Add inline functions in order to read various completion's
> attributes. These functions will be assigned in the ibv_cq_ex
> structure in order to allow the user to read the completion's
> attributes.

Did you look at using for these?

__attribute__((optimize("-fno-omit-frame-pointer")))

To help get rid of the stack frame?

> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  src/cq.c | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 121 insertions(+)
> 
> diff --git a/src/cq.c b/src/cq.c
> index a056787..188b34e 100644
> +++ b/src/cq.c
> @@ -850,6 +850,127 @@ int mlx5_poll_cq_v1(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
>  	return poll_cq(ibcq, ne, wc, 1);
>  }
>  
> +static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
> +{
> +	fprintf(stderr, "un-expected opcode in cqe\n");

Something like this can be very expensive, depending on the version of
gcc it may force a stack frame to be created for all callers. You
should audit the assembly to be sure that gcc is not creating
stack frames.

> +static inline uint32_t mlx5_cq_read_wc_qp_num(struct ibv_cq_ex
> *ibcq)

You need to go through everything you've written and make sure it is
const-correct.
You should also annotate with restrict.

Doing this properly can increase performance by allowing the caller to
avoid reloads.

> +{
> +	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));

You might want to look at having the caller pass in 'cq' from a member
in ibv_cq_ex. That way the caller can hold the cq in a register
instead of constantly reloading it like this - I'm assuming to_mcq is
not just an container_of??

> +static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
> +{
> +	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
> +	int wc_flags = 0;
> +
> +	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
> +		wc_flags = (!!(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
> +				 !!(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
> +				 (get_cqe_l3_hdr_type(cq->cqe64) ==
> +				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> +				IBV_WC_IP_CSUM_OK_SHIFT;
> +
> +	switch (cq->cqe64->op_own >> 4) {
> +	case MLX5_CQE_RESP_WR_IMM:
> +	case MLX5_CQE_RESP_SEND_IMM:
> +		wc_flags	|= IBV_WC_WITH_IMM;
> +		break;
> +	}
> +
> +	wc_flags |= ((ntohl(cq->cqe64->flags_rqpn) >> 28) & 3) ? IBV_WC_GRH : 0;
> +	return wc_flags;
> +}

There is a disappointing amount of branching here...

Anyhow, if there was any doubt that we could use a generic inline
scheme I think this patch puts it too rest, the work being done in
most of the accessors is fairly complex.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
