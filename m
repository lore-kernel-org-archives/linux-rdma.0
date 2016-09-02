From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v4 4/6] nvme-rdma: destroy nvme queue rdma resources on connect failure
Date: Fri, 2 Sep 2016 10:08:38 -0500
Message-ID: <000801d2052b$e3cfe170$ab6fa450$@opengridcomputing.com>
References: <cover.1472746379.git.swise@opengridcomputing.com> <c04f7c0232402294ce6fc0dd85878c0a21ed46bc.1472746379.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c04f7c0232402294ce6fc0dd85878c0a21ed46bc.1472746379.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> After address resolution, the nvme_rdma_queue rdma resources are
> allocated.  If rdma route resolution or the connect fails, or the
> controller reconnect times out and gives up, then the rdma resources
> need to be freed.  Otherwise, rdma resources are leaked.
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagi-Eyp3ogxVSr5BDLzU/O5InQ@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/nvme/host/rdma.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 15b0c1d..d97a16f 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -82,6 +82,7 @@ struct nvme_rdma_request {
> 
>  enum nvme_rdma_queue_flags {
>  	NVME_RDMA_Q_CONNECTED = (1 << 0),
> +	NVME_RDMA_IB_QUEUE_ALLOCATED = (1 << 1),
>  };
> 
>  struct nvme_rdma_queue {
> @@ -483,6 +484,8 @@ static void nvme_rdma_destroy_queue_ib(struct
> nvme_rdma_queue *queue)
>  	struct nvme_rdma_device *dev = queue->device;
>  	struct ib_device *ibdev = dev->dev;
> 
> +	if (!test_and_clear_bit(NVME_RDMA_IB_QUEUE_ALLOCATED,
> &queue->flags))
> +		return;
>  	rdma_destroy_qp(queue->cm_id);
>  	ib_free_cq(queue->ib_cq);
> 
> @@ -533,6 +536,7 @@ static int nvme_rdma_create_queue_ib(struct
> nvme_rdma_queue *queue,
>  		ret = -ENOMEM;
>  		goto out_destroy_qp;
>  	}
> +	set_bit(NVME_RDMA_IB_QUEUE_ALLOCATED, &queue->flags);
> 
>  	return 0;
> 
> @@ -590,6 +594,8 @@ static int nvme_rdma_init_queue(struct
> nvme_rdma_ctrl *ctrl,
>  	return 0;
> 
>  out_destroy_cm_id:
> +	if (test_and_clear_bit(NVME_RDMA_IB_QUEUE_ALLOCATED, &ctrl-
> >queues[0].flags))
> +		nvme_rdma_destroy_queue_ib(queue);
>  	rdma_destroy_id(queue->cm_id);
>  	return ret;
>  }

The above chunk is incorrect.  It is testing the ALLOCATED bit of the admin
queue (ctrl->queues[0]), which is just wrong.  This chunk should just call
nvme_rdma_destroy_queue_ib() and let that function test/clear the ALLOCATED
bit of the queue being cleaned up.  This bug was apparently benign and it
slipped through my testing.

I'll be posting v5 after I fix this and retest...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
