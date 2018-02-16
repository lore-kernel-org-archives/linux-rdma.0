From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc 2/6] RDMA/bnxt_re: Maintain GID index mapping
 between stack and hardware
Date: Fri, 16 Feb 2018 09:07:03 -0700
Message-ID: <20180216160703.GB22739@ziepe.ca>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
 <1518758413-20850-3-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518758413-20850-3-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 15, 2018 at 09:20:09PM -0800, Selvin Xavier wrote:
> Every GID has a duplicate entry in the stack for RoCE v2.
> HW table maintain only single entries. Currently the hw index
> is calculated by dividing the stack index by two. This is prone to
> failure after a series of add/delete gid operation in random order.
> 
> Maintain a mapping between stack GID index and hardware
> index to avoid failure.
> 
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  3 +++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 21 ++++++++++-----------
>  drivers/infiniband/hw/bnxt_re/main.c     | 13 +++++++++++++
>  3 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> index ca32057..5692335 100644
> +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> @@ -109,6 +109,7 @@ struct bnxt_re_sqp_entries {
>  #define BNXT_RE_MAX_MSIX		9
>  #define BNXT_RE_AEQ_IDX			0
>  #define BNXT_RE_NQ_IDX			1
> +#define BNXT_RE_MAX_SGID_ENTRIES	256
>  
>  struct bnxt_re_dev {
>  	struct ib_device		ibdev;
> @@ -170,6 +171,8 @@ struct bnxt_re_dev {
>  	u32 is_virtfn;
>  	u32 num_vfs;
>  	struct bnxt_qplib_roce_stats	stats;
> +	/* Array to handle gid mapping */
> +	char				*gid_map;

char would need to be a s8

>  #define to_bnxt_re_dev(ptr, member)	\
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index ce2a6d0..7943707 100644
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -348,6 +348,7 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
>  			return -EFAULT;
>  		}
>  		ctx->refcnt--;
> +		rdev->gid_map[index] = -1;
>  		if (!ctx->refcnt) {
>  			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del, true);
>  			if (rc) {
> @@ -386,6 +387,8 @@ int bnxt_re_add_gid(struct ib_device *ibdev, u8 port_num,
>  		ctx_tbl = sgid_tbl->ctx;
>  		ctx_tbl[tbl_idx]->refcnt++;
>  		*context = ctx_tbl[tbl_idx];
> +		/* tbl_idx is the HW table index and index is the stack index */
> +		rdev->gid_map[index] = tbl_idx;

It would be a lot better to store tbl_idx in the driver's context, that
is what context is for.

> -	/*
> -	 * If RoCE V2 is enabled, stack will have two entries for
> -	 * each GID entry. Avoiding this duplicte entry in HW. Dividing
> -	 * the GID index by 2 for RoCE V2
> -	 */
> -	ah->qplib_ah.sgid_index = grh->sgid_index / 2;
> +	/* Retrieve the HW index from the driver SGID map */
> +	ah->qplib_ah.sgid_index = rdev->gid_map[ah_attr->grh.sgid_index];

You'd need a new api to return the driver context for a gid index, but
that shouldn't be a problem.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
