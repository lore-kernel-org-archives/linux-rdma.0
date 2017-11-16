From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: add a simple SRQ pool per PD
Date: Thu, 16 Nov 2017 20:10:49 +0200
Message-ID: <20171116181049.GO18825@mtr-leonro.local>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <1510852885-25519-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510852885-25519-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 07:21:23PM +0200, Max Gurtovoy wrote:
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/Makefile   |   2 +-
>  drivers/infiniband/core/srq_pool.c | 106 +++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/verbs.c    |   4 ++
>  include/rdma/ib_verbs.h            |   5 ++
>  include/rdma/srq_pool.h            |  46 ++++++++++++++++
>  5 files changed, 162 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/core/srq_pool.c
>  create mode 100644 include/rdma/srq_pool.h
>
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
> index b4df164..365da0c 100644
> --- a/drivers/infiniband/core/Makefile
> +++ b/drivers/infiniband/core/Makefile
> @@ -11,7 +11,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
>  				device.o fmr_pool.o cache.o netlink.o \
>  				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
>  				multicast.o mad.o smi.o agent.o mad_rmpp.o \
> -				security.o nldev.o
> +				security.o nldev.o srq_pool.o
>
>  ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
>  ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
> diff --git a/drivers/infiniband/core/srq_pool.c b/drivers/infiniband/core/srq_pool.c
> new file mode 100644
> index 0000000..4f4a089
> --- /dev/null
> +++ b/drivers/infiniband/core/srq_pool.c
> @@ -0,0 +1,106 @@
> +/*
> + * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#include <rdma/srq_pool.h>
> +
> +struct ib_srq *ib_srq_pool_get(struct ib_pd *pd)
> +{
> +	struct ib_srq *srq;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pd->srq_lock, flags);
> +	srq = list_first_entry_or_null(&pd->srqs, struct ib_srq, pd_entry);
> +	if (srq) {
> +		list_del(&srq->pd_entry);
> +		pd->srqs_used++;
> +	}
> +	spin_unlock_irqrestore(&pd->srq_lock, flags);
> +
> +	return srq;
> +}
> +EXPORT_SYMBOL(ib_srq_pool_get);
> +
> +void ib_srq_pool_put(struct ib_pd *pd, struct ib_srq *srq)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pd->srq_lock, flags);
> +	list_add(&srq->pd_entry, &pd->srqs);
> +	pd->srqs_used--;
> +	spin_unlock_irqrestore(&pd->srq_lock, flags);
> +}
> +EXPORT_SYMBOL(ib_srq_pool_put);
> +
> +int ib_srq_pool_init(struct ib_pd *pd, int nr,
> +		struct ib_srq_init_attr *srq_attr)
> +{
> +	struct ib_srq *srq;
> +	unsigned long flags;
> +	int ret, i;
> +
> +	for (i = 0; i < nr; i++) {
> +		srq = ib_create_srq(pd, srq_attr);
> +		if (IS_ERR(srq)) {
> +			ret = PTR_ERR(srq);
> +			goto out;
> +		}
> +
> +		spin_lock_irqsave(&pd->srq_lock, flags);
> +		list_add_tail(&srq->pd_entry, &pd->srqs);
> +		spin_unlock_irqrestore(&pd->srq_lock, flags);
> +	}
> +
> +	return 0;
> +out:
> +	ib_srq_pool_destroy(pd);
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_srq_pool_init);
> +
> +void ib_srq_pool_destroy(struct ib_pd *pd)
> +{
> +	struct ib_srq *srq;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pd->srq_lock, flags);
> +	while (!list_empty(&pd->srqs)) {
> +		srq = list_first_entry(&pd->srqs, struct ib_srq, pd_entry);
> +		list_del(&srq->pd_entry);
> +
> +		spin_unlock_irqrestore(&pd->srq_lock, flags);
> +		ib_destroy_srq(srq);
> +		spin_lock_irqsave(&pd->srq_lock, flags);
> +	}
> +	spin_unlock_irqrestore(&pd->srq_lock, flags);
> +}
> +EXPORT_SYMBOL(ib_srq_pool_destroy);
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index de57d6c..74db405 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -233,6 +233,9 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
>  	pd->__internal_mr = NULL;
>  	atomic_set(&pd->usecnt, 0);
>  	pd->flags = flags;
> +	pd->srqs_used = 0;
> +	spin_lock_init(&pd->srq_lock);
> +	INIT_LIST_HEAD(&pd->srqs);
>
>  	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
>  		pd->local_dma_lkey = device->local_dma_lkey;
> @@ -289,6 +292,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
>  		pd->__internal_mr = NULL;
>  	}
>
> +	WARN_ON_ONCE(pd->srqs_used > 0);
>  	/* uverbs manipulates usecnt with proper locking, while the kabi
>  	   requires the caller to guarantee we can't race here. */
>  	WARN_ON(atomic_read(&pd->usecnt));
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index bdb1279..fdc721f 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1512,6 +1512,10 @@ struct ib_pd {
>
>  	u32			unsafe_global_rkey;
>
> +	spinlock_t		srq_lock;
> +	int			srqs_used;
> +	struct list_head	srqs;
> +
>  	/*
>  	 * Implementation details of the RDMA core, don't use in drivers:
>  	 */
> @@ -1566,6 +1570,7 @@ struct ib_srq {
>  	void		       *srq_context;
>  	enum ib_srq_type	srq_type;
>  	atomic_t		usecnt;
> +	struct list_head	pd_entry; /* srq pool entry */
>
>  	struct {
>  		struct ib_cq   *cq;
> diff --git a/include/rdma/srq_pool.h b/include/rdma/srq_pool.h
> new file mode 100644
> index 0000000..04aa059
> --- /dev/null
> +++ b/include/rdma/srq_pool.h
> @@ -0,0 +1,46 @@
> +/*
> + * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#ifndef _RDMA_SRQ_POOL_H
> +#define _RDMA_SRQ_POOL_H 1
> +
> +#include <rdma/ib_verbs.h>
> +
> +struct ib_srq *ib_srq_pool_get(struct ib_pd *pd);
> +void ib_srq_pool_put(struct ib_pd *pd, struct ib_srq *srq);
> +
> +int ib_srq_pool_init(struct ib_pd *pd, int nr,
> +		struct ib_srq_init_attr *srq_attr);
> +void ib_srq_pool_destroy(struct ib_pd *pd);

Can you please use rdma_ prefix instead of ib_ prefix?

Thanks

> +
> +#endif /* _RDMA_SRQ_POOL_H */
> --
> 1.8.3.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
