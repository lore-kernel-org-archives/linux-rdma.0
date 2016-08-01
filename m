From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/5] nvme-rdma: Make sure to shutdown the controller if
	we can
Date: Mon, 1 Aug 2016 13:04:46 +0200
Message-ID: <20160801110446.GD16141@lst.de>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me> <1469822242-3477-4-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469822242-3477-4-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 29, 2016 at 10:57:20PM +0300, Sagi Grimberg wrote:
> Relying on ctrl state in nvme_rdma_shutdown_ctrl is wrong because
> it will never be NVME_CTRL_LIVE (delete_ctrl or reset_ctrl invoked it).
> 
> Instead, check that the admin queue is connected. Note that it is safe
> because we can never see a copmeting thread trying to destroy the admin
> queue (reset or delete controller).
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/nvme/host/rdma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index a70eb3cbf656..641ab7f91899 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1644,7 +1644,7 @@ static void nvme_rdma_shutdown_ctrl(struct nvme_rdma_ctrl *ctrl)
>  		nvme_rdma_free_io_queues(ctrl);
>  	}
>  
> -	if (ctrl->ctrl.state == NVME_CTRL_LIVE)
> +	if (test_bit(NVME_RDMA_Q_CONNECTED, &ctrl->queues[0].flags))
>  		nvme_shutdown_ctrl(&ctrl->ctrl);
>  
>  	blk_mq_stop_hw_queues(ctrl->ctrl.admin_q);

Maybe the right way to handle this is to unconditionally call
nvme_shutdown_ctrl and make sure we return an early error
on the register write?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
