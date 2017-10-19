From: Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Thu, 19 Oct 2017 16:23:38 +0800
Message-ID: <0561ed58-7104-d8b6-1709-ea181ac493f5@redhat.com>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
 <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
 <4faccebf-7fcf-58b9-1605-82ee9acc652b@grimberg.me>
 <e44f4640-44b2-4692-ca57-08f9ebf4da2c@redhat.com>
 <729c512f-55ff-25e4-6dd9-8b4dcc31bb8d@grimberg.me>
 <ff355fcf-5089-f297-d3fa-9b86d133236b@redhat.com>
 <6d639dd4-9366-2ecf-b49e-751c7a167528@grimberg.me>
 <64135330-a62d-87b8-c805-6b52fd40bf81@redhat.com>
 <62eea88b-caa4-5799-3d8f-8d8789879aa8@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <62eea88b-caa4-5799-3d8f-8d8789879aa8-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/19/2017 02:55 PM, Sagi Grimberg wrote:
>
>>> Hi Yi,
>>>
>>> I was referring to the bug you reported on a simple create_ctrl failed:
>>> https://pastebin.com/7z0XSGSd
>>>
>>> Does it reproduce?
>>>
>> yes, this issue was reproduced during "git bisect" with below patch
>
> OK, if this does not reproduce with the latest code, lets put it aside
> for now.
>
> So as for the error you see, can you please try the following patch?
Hi Sagi
With this patch, no such error log found on host side, but I found there 
is no nvme0n1 device node even get "nvme nvme0: Successfully 
reconnected" on host.

Host side:
[   98.181089] nvme nvme0: new ctrl: NQN 
"nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
[   98.329464] nvme nvme0: creating 40 I/O queues.
[   98.835409] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
[  107.873586] nvme nvme0: Reconnecting in 10 seconds...
[  118.505937] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  118.513443] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  118.519875] nvme nvme0: Failed reconnect attempt 1
[  118.525241] nvme nvme0: Reconnecting in 10 seconds...
[  128.733311] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  128.740812] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  128.747247] nvme nvme0: Failed reconnect attempt 2
[  128.752609] nvme nvme0: Reconnecting in 10 seconds...
[  138.973404] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  138.980904] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  138.987329] nvme nvme0: Failed reconnect attempt 3
[  138.992691] nvme nvme0: Reconnecting in 10 seconds...
[  149.232610] nvme nvme0: creating 40 I/O queues.
[  149.831443] nvme nvme0: Successfully reconnected
[  149.831519] nvme nvme0: identifiers changed for nsid 1
[root@rdma-virt-01 linux ((dafb1b2...))]$ lsblk
NAME                           MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                              8:0    0 465.8G  0 disk
├─sda2                           8:2    0 464.8G  0 part
│ ├─rhelaa_rdma--virt--01-swap 253:1    0     4G  0 lvm  [SWAP]
│ ├─rhelaa_rdma--virt--01-home 253:2    0 410.8G  0 lvm  /home
│ └─rhelaa_rdma--virt--01-root 253:0    0    50G  0 lvm  /
└─sda1                           8:1    0     1G  0 part /boot

> -- 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 405895b1dff2..916658e010ff 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -572,6 +572,11 @@ static void nvme_rdma_free_queue(struct 
> nvme_rdma_queue *queue)
>         if (!test_and_clear_bit(NVME_RDMA_Q_ALLOCATED, &queue->flags))
>                 return;
>
> +       if(nvme_rdma_queue_idx(queue) == 0)
> +               nvme_rdma_free_qe(queue->device->dev,
> +                       &queue->ctrl->async_event_sqe,
> +                       sizeof(struct nvme_command), DMA_TO_DEVICE);
> +
>         nvme_rdma_destroy_queue_ib(queue);
>         rdma_destroy_id(queue->cm_id);
>  }
> @@ -739,8 +744,6 @@ static struct blk_mq_tag_set 
> *nvme_rdma_alloc_tagset(struct nvme_ctrl *nctrl,
>  static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl,
>                 bool remove)
>  {
> -       nvme_rdma_free_qe(ctrl->queues[0].device->dev, 
> &ctrl->async_event_sqe,
> -                       sizeof(struct nvme_command), DMA_TO_DEVICE);
>         nvme_rdma_stop_queue(&ctrl->queues[0]);
>         if (remove) {
>                 blk_cleanup_queue(ctrl->ctrl.admin_q);
> -- 
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
