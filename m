From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernull NULL pointer observed on initiator side after 'nvmetcli
 clear' on target side
Date: Thu, 9 Mar 2017 12:02:55 +0800
Message-ID: <88ae146a-7510-9be0-c9b4-58e70f9d73b9@redhat.com>
References: <1053522223.31446389.1488721184925.JavaMail.zimbra@redhat.com>
 <644fc4ab-df6b-a337-1431-bad881ef56ee@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <644fc4ab-df6b-a337-1431-bad881ef56ee-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Looks like blk_mq_reinit_tagset is not aware that tags can go away with
> cpu hotplug...
>
> Does this fix your issue:
> -- 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index e48bc2c72615..9d97bfc4d465 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -295,6 +295,9 @@ int blk_mq_reinit_tagset(struct blk_mq_tag_set *set)
>         for (i = 0; i < set->nr_hw_queues; i++) {
>                 struct blk_mq_tags *tags = set->tags[i];
>
> +               if (!tags)
> +                       continue;
> +
>                 for (j = 0; j < tags->nr_tags; j++) {
>                         if (!tags->static_rqs[j])
>                                 continue;
> -- 
Hi Sagi
With this patch, the NULL pointer fixed now.
But from below log, we can see it will continue reconnecting in 10 
seconds and cannot be stopped.

[36288.963890] Broke affinity for irq 16
[36288.983090] Broke affinity for irq 28
[36289.003104] Broke affinity for irq 90
[36289.020488] Broke affinity for irq 93
[36289.036911] Broke affinity for irq 97
[36289.053344] Broke affinity for irq 100
[36289.070166] Broke affinity for irq 104
[36289.088076] smpboot: CPU 1 is now offline
[36302.371160] nvme nvme0: reconnecting in 10 seconds
[36312.953684] blk_mq_reinit_tagset: tag is null, continue
[36312.983267] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[36313.017290] nvme nvme0: rdma_resolve_addr wait failed (-104).
[36313.044937] nvme nvme0: Failed reconnect attempt, requeueing...
[36323.171983] blk_mq_reinit_tagset: tag is null, continue
[36323.200733] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[36323.233820] nvme nvme0: rdma_resolve_addr wait failed (-104).
[36323.261027] nvme nvme0: Failed reconnect attempt, requeueing...
[36333.412341] blk_mq_reinit_tagset: tag is null, continue
[36333.441346] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[36333.476139] nvme nvme0: rdma_resolve_addr wait failed (-104).
[36333.502794] nvme nvme0: Failed reconnect attempt, requeueing...
[36343.652755] blk_mq_reinit_tagset: tag is null, continue
[36343.682103] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[36343.716645] nvme nvme0: rdma_resolve_addr wait failed (-104).
[36343.743581] nvme nvme0: Failed reconnect attempt, requeueing...
[36353.893103] blk_mq_reinit_tagset: tag is null, continue
[36353.921041] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[36353.953541] nvme nvme0: rdma_resolve_addr wait failed (-104).
[36353.983528] nvme nvme0: Failed reconnect attempt, requeueing...
[36364.133544] blk_mq_reinit_tagset: tag is null, continue
[36364.162012] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[36364.195002] nvme nvme0: rdma_resolve_addr wait failed (-104).
[36364.221671] nvme nvme0: Failed reconnect attempt, requeueing...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
