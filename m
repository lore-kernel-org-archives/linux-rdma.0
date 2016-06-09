From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target driver
Date: Thu, 9 Jun 2016 14:54:16 -0700
Message-ID: <CAF1ivSag+pbhRcNu+VmJYd5FmzwxZ==Ebge78TaZkXqKC-Sidg@mail.gmail.com>
References: <1465248215-18186-1-git-send-email-hch@lst.de> <1465248215-18186-5-git-send-email-hch@lst.de>
 <5756B75C.9000409@lightbits.io> <051801d1c297$c7d8a7d0$5789f770$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <051801d1c297$c7d8a7d0$5789f770$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Armen Baloyan <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 9, 2016 at 2:42 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:

> Should the above error path actually goto a block that frees the rsps?  Like
> this?
>
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index c184ee5..8aaa36f 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1053,7 +1053,7 @@ nvmet_rdma_alloc_queue(struct nvmet_rdma_device *ndev,
>                                 !queue->host_qid);
>                 if (IS_ERR(queue->cmds)) {
>                         ret = NVME_RDMA_CM_NO_RSC;
> -                       goto out_free_cmds;
> +                       goto out_free_responses;
>                 }
>         }
>
> @@ -1073,6 +1073,8 @@ out_free_cmds:
>                                 queue->recv_queue_size,
>                                 !queue->host_qid);
>         }
> +out_free_responses:
> +        nvmet_rdma_free_rsps(queue);
>  out_ida_remove:
>         ida_simple_remove(&nvmet_rdma_queue_ida, queue->idx);
>  out_destroy_sq:

Yes. Nice catch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
