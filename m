From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 06/12] IB/core: add a simple MR pool
Date: Mon, 18 Apr 2016 23:19:10 -0400
Message-ID: <20160419031909.GD27515@rhel.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460410360-13104-7-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 02:32:34PM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Steve Wise <swise@opengridcomputing.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/infiniband/core/Makefile  |  2 +-
>  drivers/infiniband/core/mr_pool.c | 86 +++++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/verbs.c   |  5 +++
>  include/rdma/ib_verbs.h           |  8 +++-
>  include/rdma/mr_pool.h            | 25 ++++++++++++
>  5 files changed, 124 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/infiniband/core/mr_pool.c
>  create mode 100644 include/rdma/mr_pool.h
> 
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
> index f818538..48bd9d8 100644
> --- a/drivers/infiniband/core/Makefile
> +++ b/drivers/infiniband/core/Makefile
> @@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
>  
>  ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
>  				device.o fmr_pool.o cache.o netlink.o \
> -				roce_gid_mgmt.o
> +				roce_gid_mgmt.o mr_pool.o
>  ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
>  ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
>  
> diff --git a/drivers/infiniband/core/mr_pool.c b/drivers/infiniband/core/mr_pool.c
> new file mode 100644
> index 0000000..49d478b
> --- /dev/null
> +++ b/drivers/infiniband/core/mr_pool.c
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright (c) 2016 HGST, a Western Digital Company.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +#include <rdma/ib_verbs.h>
> +#include <rdma/mr_pool.h>
> +
> +struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list)
> +{
> +	struct ib_mr *mr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->mr_lock, flags);
> +	mr = list_first_entry_or_null(list, struct ib_mr, qp_entry);
> +	if (mr) {
> +		list_del(&mr->qp_entry);
> +		qp->mrs_used++;
> +	}
> +	spin_unlock_irqrestore(&qp->mr_lock, flags);
> +
> +	return mr;
> +}
> +EXPORT_SYMBOL(ib_mr_pool_get);
> +
> +void ib_mr_pool_put(struct ib_qp *qp, struct list_head *list, struct ib_mr *mr)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->mr_lock, flags);
> +	list_add(&mr->qp_entry, list);
> +	qp->mrs_used--;
> +	spin_unlock_irqrestore(&qp->mr_lock, flags);
> +}
> +EXPORT_SYMBOL(ib_mr_pool_put);
> +
> +int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
> +		enum ib_mr_type type, u32 max_num_sg)
> +{
> +	struct ib_mr *mr;
> +	unsigned long flags;
> +	int ret, i;
> +
> +	for (i = 0; i < nr; i++) {
> +		mr = ib_alloc_mr(qp->pd, type, max_num_sg);
> +		if (IS_ERR(mr)) {
> +			ret = PTR_ERR(mr);
> +			goto out;
> +		}
> +
> +		spin_lock_irqsave(&qp->mr_lock, flags);
> +		list_add_tail(&mr->qp_entry, list);
> +		spin_unlock_irqrestore(&qp->mr_lock, flags);
> +	}
> +
> +	return 0;
> +out:
> +	ib_mr_pool_destroy(qp, list);
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_mr_pool_init);
> +
> +void ib_mr_pool_destroy(struct ib_qp *qp, struct list_head *list)
> +{
> +	struct ib_mr *mr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->mr_lock, flags);
> +	while (!list_empty(list)) {
> +		mr = list_first_entry(list, struct ib_mr, qp_entry);
> +		list_del(&mr->qp_entry);
> +
> +		spin_unlock_irqrestore(&qp->mr_lock, flags);
> +		ib_dereg_mr(mr);
> +		spin_lock_irqsave(&qp->mr_lock, flags);
> +	}
> +	spin_unlock_irqrestore(&qp->mr_lock, flags);
> +}
> +EXPORT_SYMBOL(ib_mr_pool_destroy);
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index d0ed260..d9ea2fb 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -762,6 +762,9 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>  	qp->qp_type    = qp_init_attr->qp_type;
>  
>  	atomic_set(&qp->usecnt, 0);
> +	qp->mrs_used = 0;
> +	spin_lock_init(&qp->mr_lock);
> +
>  	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
>  		return ib_create_xrc_qp(qp, qp_init_attr);
>  
> @@ -1255,6 +1258,8 @@ int ib_destroy_qp(struct ib_qp *qp)
>  	struct ib_srq *srq;
>  	int ret;
>  
> +	WARN_ON_ONCE(qp->mrs_used > 0);
> +
>  	if (atomic_read(&qp->usecnt))
>  		return -EBUSY;
>  
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 9e8616a..400a8a0 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1421,9 +1421,12 @@ struct ib_qp {
>  	struct ib_pd	       *pd;
>  	struct ib_cq	       *send_cq;
>  	struct ib_cq	       *recv_cq;
> +	spinlock_t		mr_lock;
> +	int			mrs_used;
>  	struct ib_srq	       *srq;
>  	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
>  	struct list_head	xrcd_list;
> +
>  	/* count times opened, mcast attaches, flow attaches */
>  	atomic_t		usecnt;
>  	struct list_head	open_list;
> @@ -1438,12 +1441,15 @@ struct ib_qp {
>  struct ib_mr {
>  	struct ib_device  *device;
>  	struct ib_pd	  *pd;
> -	struct ib_uobject *uobject;
>  	u32		   lkey;
>  	u32		   rkey;
>  	u64		   iova;
>  	u32		   length;
>  	unsigned int	   page_size;
> +	union {
> +		struct ib_uobject	*uobject;	/* user */
> +		struct list_head	qp_entry;	/* FR */
> +	};
>  };
>  
>  struct ib_mw {
> diff --git a/include/rdma/mr_pool.h b/include/rdma/mr_pool.h
> new file mode 100644
> index 0000000..986010b
> --- /dev/null
> +++ b/include/rdma/mr_pool.h
> @@ -0,0 +1,25 @@
> +/*
> + * Copyright (c) 2016 HGST, a Western Digital Company.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +#ifndef _RDMA_MR_POOL_H
> +#define _RDMA_MR_POOL_H 1
> +
> +#include <rdma/ib_verbs.h>
> +
> +struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list);
> +void ib_mr_pool_put(struct ib_qp *qp, struct list_head *list, struct ib_mr *mr);
> +
> +int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
> +		enum ib_mr_type type, u32 max_num_sg);
> +void ib_mr_pool_destroy(struct ib_qp *qp, struct list_head *list);
> +
> +#endif /* _RDMA_MR_POOL_H */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
