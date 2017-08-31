From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Thu, 31 Aug 2017 15:15:42 +0800
Message-ID: <1101dc7c-f4bd-6411-985c-8cf7325ad1d8@redhat.com>
References: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
 <97bb90ec-4337-62f7-f08d-a673975a5637@grimberg.me>
 <20170425180630.GU14088@mtr-leonro.local>
 <cbc43d35-27c9-331d-b345-b09530477d74@mellanox.com>
 <39bb8b67-4018-09bd-9d7d-a8f8534084a7@redhat.com>
 <7ceef67d-4424-97d5-02f5-7569a1f5a20e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ceef67d-4424-97d5-02f5-7569a1f5a20e-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> I couldn't repro it, but for some reason you got an overflow in the QP 
> send queue.
> seems like something might be wrong with the calculation (probably 
> signaling calculation).
>
> please supply more details:
> 1. link layer ?
> 2. HCA type + FW versions on target/host sides ?
> 3. B2B connection ?
>
> try this one as a first step:
>
Hi Max
I retest this issue on 4.13.0-rc6/4.13.0-rc7 without your patch, found 
this issue cannot be reproduced any more.
Here is my environment:
link layer:mlx5_roce
HCA:
04:00.0 Infiniband controller: Mellanox Technologies MT27700 Family 
[ConnectX-4]
04:00.1 Infiniband controller: Mellanox Technologies MT27700 Family 
[ConnectX-4]
05:00.0 Ethernet controller: Mellanox Technologies MT27710 Family 
[ConnectX-4 Lx]
05:00.1 Ethernet controller: Mellanox Technologies MT27710 Family 
[ConnectX-4 Lx]
Firmware:
[   13.489854] mlx5_core 0000:04:00.0: firmware version: 12.18.1000
[   14.360121] mlx5_core 0000:04:00.1: firmware version: 12.18.1000
[   15.091088] mlx5_core 0000:05:00.0: firmware version: 14.18.1000
[   15.936417] mlx5_core 0000:05:00.1: firmware version: 14.18.1000
The two server connected by switch.

Will let you know and retest your patch when I reproduced it in the future.

Thanks
Yi

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 82fcb07..1437306 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -88,6 +88,7 @@ struct nvme_rdma_queue {
>         struct nvme_rdma_qe     *rsp_ring;
>         atomic_t                sig_count;
>         int                     queue_size;
> +       int                     limit_mask;
>         size_t                  cmnd_capsule_len;
>         struct nvme_rdma_ctrl   *ctrl;
>         struct nvme_rdma_device *device;
> @@ -521,6 +522,7 @@ static int nvme_rdma_init_queue(struct 
> nvme_rdma_ctrl *ctrl,
>
>         queue->queue_size = queue_size;
>         atomic_set(&queue->sig_count, 0);
> +       queue->limit_mask = (min(32, 1 << ilog2((queue->queue_size + 
> 1) / 2))) - 1;
>
>         queue->cm_id = rdma_create_id(&init_net, nvme_rdma_cm_handler, 
> queue,
>                         RDMA_PS_TCP, IB_QPT_RC);
> @@ -1009,9 +1011,7 @@ static void nvme_rdma_send_done(struct ib_cq 
> *cq, struct ib_wc *wc)
>   */
>  static inline bool nvme_rdma_queue_sig_limit(struct nvme_rdma_queue 
> *queue)
>  {
> -       int limit = 1 << ilog2((queue->queue_size + 1) / 2);
> -
> -       return (atomic_inc_return(&queue->sig_count) & (limit - 1)) == 0;
> +       return (atomic_inc_return(&queue->sig_count) & 
> (queue->limit_mask)) == 0;
>  }
>
>  static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
>
>
>
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
