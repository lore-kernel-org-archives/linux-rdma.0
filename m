From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/5] nvme-rdma: Free the I/O tags when we delete the
	controller
Date: Mon, 1 Aug 2016 13:03:08 +0200
Message-ID: <20160801110308.GC16141@lst.de>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me> <1469822242-3477-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469822242-3477-3-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 29, 2016 at 10:57:19PM +0300, Sagi Grimberg wrote:
> If we wait until we free the controller (free_ctrl) we might
> lose our rdma device without any notification while we still
> have open resources (tags mrs and dma mappings).
> 
> Instead, destroy the tags with their rdma resources once we
> delete the device and not when freeing it.
> 
> Note that we don't do that in nvme_rdma_shutdown_ctrl because
> controller reset uses it as well and we want to give active I/O
> a chance to complete successfully.
> 
> Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

This looks fine to me, but can we place share the code instead of
duplicating it?  E.g.

static void __nvme_rdma_remove_ctrl(struct nvme_rdma_ctrl *ctrl, bool shutdown)
{
 	nvme_remove_namespaces(&ctrl->ctrl);
	if (shutdown)
	  	nvme_rdma_shutdown_ctrl(ctrl);
  	nvme_uninit_ctrl(&ctrl->ctrl);
	if (ctrl->ctrl.tagset) {
		blk_cleanup_queue(ctrl->ctrl.connect_q);
		blk_mq_free_tag_set(&ctrl->tag_set);
		nvme_rdma_dev_put(ctrl->device);
	}
	nvme_put_ctrl(&ctrl->ctrl);
}

or in a second step we should probably always call shutdown_ctrl
but skip the actual shutdown if the ctrl state doesn't require it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
