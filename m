From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Corrected description of max_sge and
 max_sge_rd
Date: Thu, 11 May 2017 11:33:56 +0300
Message-ID: <20170511083355.GE3011@yuval-lap>
References: <1494433465-1883-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494433465-1883-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 10, 2017 at 07:24:25PM +0300, Yishai Hadas wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch corrects ambiguity in documentation of max_sge and max_sge_rd
> fields. This ambiguity seems to be created due to [1] and due to mention
> of "RD and non RD QPs" in man page.
> 
> Here RD can be understood as reliable datagram QP of Infiniband
> specification as opposed to "read".
> 
> max_sge_rd: Maximum number of sges per WR for RDMA Read operations.
> max_sge: Maximum number of sges per WR for QP for non RDMA Read
> operations.

So the new comments makes it clear but can you consider change the name to
reflect that? i.e. it is good to have comments describing variables role
but better to have the names self explanatory.

Something like the following will make comments almost unneeded.
max_sge_rdma_rd: Maximum number of sges per WR for RDMA Read operations.
max_sge_rd: Maximum number of sges per WR for QP for non RDMA Read

My 2 cents.

> 
> [1] http://www.rdmamojo.com/2012/07/13/ibv_query_device/
> 
> Signed-off-by: Parav Pandit<parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> 
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/131
> 
>  libibverbs/man/ibv_query_device.3 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libibverbs/man/ibv_query_device.3 b/libibverbs/man/ibv_query_device.3
> index 35daa53..0e9d286 100644
> --- a/libibverbs/man/ibv_query_device.3
> +++ b/libibverbs/man/ibv_query_device.3
> @@ -33,8 +33,8 @@ uint32_t                hw_ver;                 /* Hardware version */
>  int                     max_qp;                 /* Maximum number of supported QPs */
>  int                     max_qp_wr;              /* Maximum number of outstanding WR on any work queue */
>  int                     device_cap_flags;       /* HCA capabilities mask */
> -int                     max_sge;                /* Maximum number of s/g per WR for non-RD QPs */
> -int                     max_sge_rd;             /* Maximum number of s/g per WR for RD QPs */
> +int                     max_sge;                /* Maximum number of s/g per WR for SQ & RQ of QP for non RDMA Read operations */

Should the line be break here as it exceed 80 characters?

> +int                     max_sge_rd;             /* Maximum number of s/g per WR for RDMA Read operations */
>  int                     max_cq;                 /* Maximum number of supported CQs */
>  int                     max_cqe;                /* Maximum number of CQE capacity per CQ */
>  int                     max_mr;                 /* Maximum number of supported MRs */
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
