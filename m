From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH wip/dl-for-next] RDMA/bnxt_re: Fix kbuild error
Date: Thu, 18 Jan 2018 21:15:32 +0200
Message-ID: <20180118191531.GA16234@yuvallap>
References: <1516288665-11055-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516288665-11055-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 18, 2018 at 10:17:45AM -0500, Devesh Sharma wrote:
> Fix for following build failure
> 
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3402:7-14: ERROR: reference
> preceded by free on line 3375
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/dl-for-next
> head:   d47f6fe6736ed3ecb39cd69fe26e3518f199eecd
> commit: cb8a852e09c1dc8e47af741714063acf9c4d115c [3/28] RDMA/bnxt_re: Add support for MRs with Huge pages
> :::::: branch date: 4 hours ago
> :::::: commit date: 15 hours ago
> 
> >> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3402:7-14: ERROR: reference preceded by free on line 3375
> 
> git remote add rdma-rdma https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
> git remote update rdma-rdma
> git checkout cb8a852e09c1dc8e47af741714063acf9c4d115c
> vim +3402 drivers/infiniband/hw/bnxt_re/ib_verbs.c
> 
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 7220322..9b8fa77 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -3355,10 +3355,8 @@ int bnxt_re_dereg_mr(struct ib_mr *ib_mr)
>  	int rc;
>  
>  	rc = bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
> -	if (rc) {
> +	if (rc)
>  		dev_err(rdev_to_dev(rdev), "Dereg MR failed: %#x\n", rc);
> -		return rc;
> -	}
>  
>  	if (mr->pages) {
>  		rc = bnxt_qplib_free_fast_reg_page_list(&rdev->qplib_res,
> @@ -3421,7 +3419,7 @@ struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
>  
>  	rc = bnxt_qplib_alloc_mrw(&rdev->qplib_res, &mr->qplib_mr);
>  	if (rc)
> -		goto fail;
> +		goto bail;
>  
>  	mr->ib_mr.lkey = mr->qplib_mr.lkey;
>  	mr->ib_mr.rkey = mr->ib_mr.lkey;
> @@ -3443,9 +3441,10 @@ struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
>  	return &mr->ib_mr;
>  
>  fail_mr:
> -	bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
> -fail:
>  	kfree(mr->pages);
> +fail:
> +	bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
> +bail:
>  	kfree(mr);
>  	return ERR_PTR(rc);
>  }
> @@ -3595,22 +3594,20 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
>  	pbl_tbl = kcalloc(umem_pgs, sizeof(u64 *), GFP_KERNEL);
>  	if (!pbl_tbl) {
>  		rc = -ENOMEM;
> -		goto free_mrw;
> +		goto free_umem;
>  	}
>  
>  	page_shift = umem->page_shift;
>  
>  	if (!bnxt_re_page_size_ok(page_shift)) {
>  		dev_err(rdev_to_dev(rdev), "umem page size unsupported!");
> -		kfree(pbl_tbl);
>  		rc = -EFAULT;
> -		goto free_umem;
> +		goto fail;
>  	}
>  
>  	if (!umem->hugetlb && length > BNXT_RE_MAX_MR_SIZE_LOW) {
>  		dev_err(rdev_to_dev(rdev), "Requested MR Sz:%llu Max sup:%llu",
>  			length,	(u64)BNXT_RE_MAX_MR_SIZE_LOW);
> -		kfree(pbl_tbl);
>  		rc = -EINVAL;
>  		goto fail;
>  	}
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
