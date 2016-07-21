From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/3] nvme-rdma: Fix device removal handling
Date: Thu, 21 Jul 2016 10:15:33 +0200
Message-ID: <20160721081533.GB20363@lst.de>
References: <cover.1468879135.git.swise@opengridcomputing.com> <0cb1ccaa920b3ec48dd94ea49fa0f0b7c5520d38.1468879135.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0cb1ccaa920b3ec48dd94ea49fa0f0b7c5520d38.1468879135.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 18, 2016 at 01:44:50PM -0700, Sagi Grimberg wrote:
> Device removal sequence may have crashed because the
> controller (and admin queue space) was freed before
> we destroyed the admin queue resources. Thus we
> want to destroy the admin queue and only then queue
> controller deletion and wait for it to complete.
> 
> More specifically we:
> 1. own the controller deletion (make sure we are not
>    competing with another deletion).
> 2. get rid of inflight reconnects if exists (which
>    also destroy and create queues).
> 3. destroy the queue.
> 4. safely queue controller deletion (and wait for it
>    to complete).
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/nvme/host/rdma.c | 49 ++++++++++++++++++++++++++----------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 3e3ce2b..0e58450 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -169,7 +169,6 @@ MODULE_PARM_DESC(register_always,
>  static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
>  		struct rdma_cm_event *event);
>  static void nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
> -static int __nvme_rdma_del_ctrl(struct nvme_rdma_ctrl *ctrl);
>  
>  /* XXX: really should move to a generic header sooner or later.. */
>  static inline void put_unaligned_le24(u32 val, u8 *p)
> @@ -1318,37 +1317,43 @@ out_destroy_queue_ib:
>   * that caught the event. Since we hold the callout until the controller
>   * deletion is completed, we'll deadlock if the controller deletion will
>   * call rdma_destroy_id on this queue's cm_id. Thus, we claim ownership
> - * of destroying this queue before-hand, destroy the queue resources
> - * after the controller deletion completed with the exception of destroying
> - * the cm_id implicitely by returning a non-zero rc to the callout.
> + * of destroying this queue before-hand, destroy the queue resources,
> + * then queue the controller deletion which won't destroy this queue and
> + * we destroy the cm_id implicitely by returning a non-zero rc to the callout.
>   */
>  static int nvme_rdma_device_unplug(struct nvme_rdma_queue *queue)
>  {
>  	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
> +	int ret;
>  
> +	/* Own the controller deletion */
> +	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_DELETING))
> +		return 0;
>  
> +	dev_warn(ctrl->ctrl.device,
> +		"Got rdma device removal event, deleting ctrl\n");
>  
> +	/* Get rid of reconnect work if its running */
> +	cancel_delayed_work_sync(&ctrl->reconnect_work);
>  
> +	/* Disable the queue so ctrl delete won't free it */
> +	if (!test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags)) {
> +		ret = 0;
> +		goto queue_delete;
>  	}
>  
> +	/* Free this queue ourselves */
> +	nvme_rdma_stop_queue(queue);
> +	nvme_rdma_destroy_queue_ib(queue);
> +
> +	/* Return non-zero so the cm_id will destroy implicitly */
> +	ret = 1;
> +
> +queue_delete:
> +	/* queue controller deletion */
> +	queue_work(nvme_rdma_wq, &ctrl->delete_work);
> +	flush_work(&ctrl->delete_work);
> +	return ret;

Seems like we should be able to just skip the goto here:

	/* Disable the queue so ctrl delete won't free it */
	if (test_and_clear_bit(NVME_RDMA_Q_CONNECTED, &queue->flags)) {
		/* Free this queue ourselves */
		nvme_rdma_stop_queue(queue);
		nvme_rdma_destroy_queue_ib(queue);

		/* Return non-zero so the cm_id will destroy implicitly */
		ret = 1;
	}

	/* queue controller deletion */
	queue_work(nvme_rdma_wq, &ctrl->delete_work);
	flush_work(&ctrl->delete_work);
	return ret;
}


And that opportunity could used to improve the comment for that if
connected stop queue case a bit as well.

Otherwise this looks reasonable to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
