From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 5/9] IB/core: add a simple MR pool
Date: Tue, 8 Mar 2016 11:37:15 -0800
Message-ID: <56DF29EB.7040703@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457461000-24088-6-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/08/2016 10:16 AM, Christoph Hellwig wrote:
> +struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list)
> +{
> +	struct ib_mr *mr = NULL;
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

Hmm ... why has 'mr' been initialized to NULL in this function? I think 
that initialization can be left out. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
