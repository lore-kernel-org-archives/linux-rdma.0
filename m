From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-4.3 11/15] iw_cxgb4: Support ib_alloc_mr verb
Date: Fri, 7 Aug 2015 10:06:26 -0500
Message-ID: <003301d0d122$a1e46ee0$e5ad4ca0$@opengridcomputing.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com> <1438241568-3685-12-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438241568-3685-12-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> Sent: Thursday, July 30, 2015 2:33 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH for-4.3 11/15] iw_cxgb4: Support ib_alloc_mr verb
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 +++-
>  drivers/infiniband/hw/cxgb4/mem.c      | 12 +++++++++---
>  drivers/infiniband/hw/cxgb4/provider.c |  2 +-
>  3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index cc77844..c7bb38c 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -970,7 +970,9 @@ void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_list *page_list);
>  struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(
>  					struct ib_device *device,
>  					int page_list_len);
> -struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth);
> +struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
> +			    enum ib_mr_type mr_type,
> +			    u32 max_num_sg);
>  int c4iw_dealloc_mw(struct ib_mw *mw);
>  struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
>  struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
> index cff815b..026b91e 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -853,7 +853,9 @@ int c4iw_dealloc_mw(struct ib_mw *mw)
>  	return 0;
>  }
> 
> -struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
> +struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
> +			    enum ib_mr_type mr_type,
> +			    u32 max_num_sg)
>  {
>  	struct c4iw_dev *rhp;
>  	struct c4iw_pd *php;
> @@ -862,6 +864,10 @@ struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
>  	u32 stag = 0;
>  	int ret = 0;
> 
> +	if (mr_type != IB_MR_TYPE_MEM_REG ||
> +	    max_num_sg > t4_max_fr_depth(use_dsgl))
> +		return ERR_PTR(-EINVAL);
> +
>  	php = to_c4iw_pd(pd);
>  	rhp = php->rhp;
>  	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);

Hey Sagi/Doug,

The above change introduces a regression with NFSRDMA over cxgb4.  Prior to this commit, cxgb4 allowed frmr and page list
allocations that exceeded the device max.  It does enforce the max when processing a fastreg WR though.  This is definitely a bug in
cxgb4, but was benign.  Further, the NFSRDMA server currently allocates frmrs and page_lists using  RPCSVC_MAXPAGES for max_num_sg
which exceeds the max supported by cxgb4.  Thus with the above patch, NFSRDMA doesn't work at all over cxgb4. :(

So I need to fix NFSRDMA for sure.  But adding a fix on top of the above patch will leave a bisectable window where NFSRDMA is
broken on cxgb4.  Is it too late to change the above patch so the regression is avoided?  Then I can provide a new series of patches
to fix the NFS server to mind the device max,  and fix cxgb4 to enforce the device max.

If it is too much of a pain to alter this patch, then I'll just submit the NFSRDMA fix and live with the bisect issue...

Thoughts?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
