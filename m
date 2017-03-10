From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernull NULL pointer observed on initiator side after 'nvmetcli
 clear' on target side
Date: Fri, 10 Mar 2017 15:59:17 +0800
Message-ID: <b0a84bcc-7dca-d342-b30e-b01eba8088cd@redhat.com>
References: <1053522223.31446389.1488721184925.JavaMail.zimbra@redhat.com>
 <644fc4ab-df6b-a337-1431-bad881ef56ee@grimberg.me>
 <88ae146a-7510-9be0-c9b4-58e70f9d73b9@redhat.com>
 <6ffda302-02f9-12f0-a112-ea7cd20b9ffa@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6ffda302-02f9-12f0-a112-ea7cd20b9ffa-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>
>
> Yep... looks like we don't take into account that we can't use all the
> queues now...
>
> Does this patch help:
Still can reproduce the reconnect in 10 seconds issues with the patch, 
here is the log:

[  193.574183] nvme nvme0: new ctrl: NQN "nvme-subsystem-name", addr 
172.31.2.3:1023
[  193.612039] __nvme_rdma_init_request: changing called
[  193.638723] __nvme_rdma_init_request: changing called
[  193.661767] __nvme_rdma_init_request: changing called
[  193.684579] __nvme_rdma_init_request: changing called
[  193.707327] __nvme_rdma_init_request: changing called
[  193.730071] __nvme_rdma_init_request: changing called
[  193.752896] __nvme_rdma_init_request: changing called
[  193.775699] __nvme_rdma_init_request: changing called
[  193.798813] __nvme_rdma_init_request: changing called
[  193.821257] __nvme_rdma_init_request: changing called
[  193.844090] __nvme_rdma_init_request: changing called
[  193.866472] __nvme_rdma_init_request: changing called
[  193.889375] __nvme_rdma_init_request: changing called
[  193.912094] __nvme_rdma_init_request: changing called
[  193.934942] __nvme_rdma_init_request: changing called
[  193.957688] __nvme_rdma_init_request: changing called
[  606.273376] Broke affinity for irq 16
[  606.291940] Broke affinity for irq 28
[  606.310201] Broke affinity for irq 90
[  606.328211] Broke affinity for irq 93
[  606.346263] Broke affinity for irq 97
[  606.364314] Broke affinity for irq 100
[  606.382105] Broke affinity for irq 104
[  606.400727] smpboot: CPU 1 is now offline
[  616.820505] nvme nvme0: reconnecting in 10 seconds
[  626.882747] blk_mq_reinit_tagset: tag is null, continue
[  626.914000] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  626.947965] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  626.974673] nvme nvme0: Failed reconnect attempt, requeueing...
[  637.100252] blk_mq_reinit_tagset: tag is null, continue
[  637.129200] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  637.163578] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  637.190246] nvme nvme0: Failed reconnect attempt, requeueing...
[  647.340147] blk_mq_reinit_tagset: tag is null, continue
[  647.367612] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  647.402527] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  647.430338] nvme nvme0: Failed reconnect attempt, requeueing...
[  657.579993] blk_mq_reinit_tagset: tag is null, continue
[  657.608478] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  657.643947] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  657.670579] nvme nvme0: Failed reconnect attempt, requeueing...
[  667.819897] blk_mq_reinit_tagset: tag is null, continue
[  667.848786] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  667.881951] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  667.908578] nvme nvme0: Failed reconnect attempt, requeueing...
[  678.059821] blk_mq_reinit_tagset: tag is null, continue
[  678.089295] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  678.123602] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  678.150317] nvme nvme0: Failed reconnect attempt, requeueing...


> -- 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 29ac8fcb8d2c..25af3f75f6f1 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -337,8 +337,6 @@ static int __nvme_rdma_init_request(struct 
> nvme_rdma_ctrl *ctrl,
>         struct ib_device *ibdev = dev->dev;
>         int ret;
>
> -       BUG_ON(queue_idx >= ctrl->queue_count);
> -
>         ret = nvme_rdma_alloc_qe(ibdev, &req->sqe, sizeof(struct 
> nvme_command),
>                         DMA_TO_DEVICE);
>         if (ret)
> @@ -647,8 +645,22 @@ static int nvme_rdma_connect_io_queues(struct 
> nvme_rdma_ctrl *ctrl)
>
>  static int nvme_rdma_init_io_queues(struct nvme_rdma_ctrl *ctrl)
>  {
> +       struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
> +       unsigned int nr_io_queues;
>         int i, ret;
>
> +       nr_io_queues = min(opts->nr_io_queues, num_online_cpus());
> +       ret = nvme_set_queue_count(&ctrl->ctrl, &nr_io_queues);
> +       if (ret)
> +               return ret;
> +
> +       ctrl->queue_count = nr_io_queues + 1;
> +       if (ctrl->queue_count < 2)
> +               return 0;
> +
> +       dev_info(ctrl->ctrl.device,
> +               "creating %d I/O queues.\n", nr_io_queues);
> +
>         for (i = 1; i < ctrl->queue_count; i++) {
>                 ret = nvme_rdma_init_queue(ctrl, i,
> ctrl->ctrl.opts->queue_size);
> @@ -1793,20 +1805,8 @@ static const struct nvme_ctrl_ops 
> nvme_rdma_ctrl_ops = {
>
>  static int nvme_rdma_create_io_queues(struct nvme_rdma_ctrl *ctrl)
>  {
> -       struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
>         int ret;
>
> -       ret = nvme_set_queue_count(&ctrl->ctrl, &opts->nr_io_queues);
> -       if (ret)
> -               return ret;
> -
> -       ctrl->queue_count = opts->nr_io_queues + 1;
> -       if (ctrl->queue_count < 2)
> -               return 0;
> -
> -       dev_info(ctrl->ctrl.device,
> -               "creating %d I/O queues.\n", opts->nr_io_queues);
> -
> -- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
