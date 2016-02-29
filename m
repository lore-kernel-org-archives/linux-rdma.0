From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 5/9] IB/core: add a simple MR pool
Date: Mon, 29 Feb 2016 14:36:53 -0800
Message-ID: <56D4C805.8040507@sandisk.com>
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
> +struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list)
> +{
> +	struct ib_mr *mr = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->mr_lock, flags);
> +	mr = list_first_entry_or_null(list, struct ib_mr, qp_entry);
> +	if (mr)
> +		qp->mrs_used++;
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

Hi Christoph,

So ib_mr_pool_get() does not remove the returned element from the list 
and ib_mr_pool_put() adds it to the list? Why this asymmetry?

Thanks,

Bart.
