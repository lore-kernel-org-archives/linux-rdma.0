From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 5/9] IB/core: add a simple MR pool
Date: Tue, 1 Mar 2016 11:12:09 -0800
Message-ID: <56D5E989.9010006@sandisk.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-6-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 02/29/2016 02:20 PM, Christoph Hellwig wrote:
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

Hello Christoph,

A second question about this patch: why do we need locking in 
ib_mr_pool_init() and ib_mr_pool_destroy()? Calling ib_mr_pool_get() or 
ib_mr_pool_put() while one of these two functions is in progress is a 
bug (race condition). Can the locking be left out from these two functions?

Bart.
