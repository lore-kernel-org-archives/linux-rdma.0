From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target
 driver
Date: Tue, 14 Jun 2016 07:32:48 -0700
Message-ID: <20160614143248.GB17800@infradead.org>
References: <1465248215-18186-1-git-send-email-hch@lst.de>
 <1465248215-18186-5-git-send-email-hch@lst.de>
 <5756B75C.9000409@lightbits.io>
 <051801d1c297$c7d8a7d0$5789f770$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <051801d1c297$c7d8a7d0$5789f770$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 09, 2016 at 04:42:11PM -0500, Steve Wise wrote:
> 
> <snip>
> 
> > > +
> > > +static struct nvmet_rdma_queue *
> > > +nvmet_rdma_alloc_queue(struct nvmet_rdma_device *ndev,
> > > +		struct rdma_cm_id *cm_id,
> > > +		struct rdma_cm_event *event)
> > > +{
> > > +	struct nvmet_rdma_queue *queue;
> > > +	int ret;
> > > +
> > > +	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
> > > +	if (!queue) {
> > > +		ret = NVME_RDMA_CM_NO_RSC;
> > > +		goto out_reject;
> > > +	}
> > > +
> > > +	ret = nvmet_sq_init(&queue->nvme_sq);
> > > +	if (ret)
> > > +		goto out_free_queue;
> > > +
> > > +	ret = nvmet_rdma_parse_cm_connect_req(&event->param.conn,
> > queue);
> > > +	if (ret)
> > > +		goto out_destroy_sq;
> > > +
> > > +	/*
> > > +	 * Schedules the actual release because calling rdma_destroy_id from
> > > +	 * inside a CM callback would trigger a deadlock. (great API
> design..)
> > > +	 */
> > > +	INIT_WORK(&queue->release_work,
> > nvmet_rdma_release_queue_work);
> > > +	queue->dev = ndev;
> > > +	queue->cm_id = cm_id;
> > > +
> > > +	spin_lock_init(&queue->state_lock);
> > > +	queue->state = NVMET_RDMA_Q_CONNECTING;
> > > +	INIT_LIST_HEAD(&queue->rsp_wait_list);
> > > +	INIT_LIST_HEAD(&queue->rsp_wr_wait_list);
> > > +	spin_lock_init(&queue->rsp_wr_wait_lock);
> > > +	INIT_LIST_HEAD(&queue->free_rsps);
> > > +	spin_lock_init(&queue->rsps_lock);
> > > +
> > > +	queue->idx = ida_simple_get(&nvmet_rdma_queue_ida, 0, 0,
> > GFP_KERNEL);
> > > +	if (queue->idx < 0) {
> > > +		ret = NVME_RDMA_CM_NO_RSC;
> > > +		goto out_free_queue;
> > > +	}
> > > +
> > > +	ret = nvmet_rdma_alloc_rsps(queue);
> > > +	if (ret) {
> > > +		ret = NVME_RDMA_CM_NO_RSC;
> > > +		goto out_ida_remove;
> > > +	}
> > > +
> > > +	if (!ndev->srq) {
> > > +		queue->cmds = nvmet_rdma_alloc_cmds(ndev,
> > > +				queue->recv_queue_size,
> > > +				!queue->host_qid);
> > > +		if (IS_ERR(queue->cmds)) {
> > > +			ret = NVME_RDMA_CM_NO_RSC;
> > > +			goto out_free_cmds;
> > > +		}
> > > +	}
> > > +
> 
> Should the above error path actually goto a block that frees the rsps?  Like
> this?

Yes, this looks good.  Thanks a lot, I'll include it in when reposting.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
