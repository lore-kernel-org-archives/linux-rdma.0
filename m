From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 07/12] IB/core: add a need_inval flag to struct ib_mr
Date: Mon, 18 Apr 2016 23:20:09 -0400
Message-ID: <20160419032008.GE27515@rhel.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460410360-13104-8-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 02:32:35PM -0700, Christoph Hellwig wrote:
> From: Steve Wise <swise@chelsio.com>
> 
> This is the first step toward moving MR invalidation decisions
> to the core.  It will be needed by the upcoming RW API.
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/infiniband/core/verbs.c | 2 ++
>  include/rdma/ib_verbs.h         | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index d9ea2fb..179d800 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1353,6 +1353,7 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
>  		mr->pd      = pd;
>  		mr->uobject = NULL;
>  		atomic_inc(&pd->usecnt);
> +		mr->need_inval = false;
>  	}
>  
>  	return mr;
> @@ -1399,6 +1400,7 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
>  		mr->pd      = pd;
>  		mr->uobject = NULL;
>  		atomic_inc(&pd->usecnt);
> +		mr->need_inval = false;
>  	}
>  
>  	return mr;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 400a8a0..3f66647 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1446,6 +1446,7 @@ struct ib_mr {
>  	u64		   iova;
>  	u32		   length;
>  	unsigned int	   page_size;
> +	bool		   need_inval;
>  	union {
>  		struct ib_uobject	*uobject;	/* user */
>  		struct list_head	qp_entry;	/* FR */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
