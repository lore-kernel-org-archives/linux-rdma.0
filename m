From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for v4.7] IB/srpt: Reduce QP buffer size
Date: Thu, 23 Jun 2016 09:13:53 -0400 (EDT)
Message-ID: <2016197898.863510.1466687633505.JavaMail.zimbra@redhat.com>
References: <20160623073548.9883-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160623073548.9883-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi
> Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Sent: Thursday, June 23, 2016 3:35:48 AM
> Subject: [PATCH for v4.7] IB/srpt: Reduce QP buffer size
> 
> The memory needed for the send and receive queues associated with
> a QP is proportional to the max_sge parameter. The current value
> of that parameter is such that with an mlx4 HCA the QP buffer size
> is 8 MB. Since DMA is used for communication between HCA and CPU
> that buffer either has to be allocated coherently or map_single()
> must succeed for that buffer. Since large contiguous allocations
> are fragile and since the maximum segment size for e.g. swiotlb
> is 256 KB, reduce the max_sge parameter. This patch avoids that
> the following text appears on the console after SRP logout and
> relogin on a system equipped with multiple IB HCAs:
> 
> mlx4_core 0000:05:00.0: swiotlb buffer is full (sz: 8388608 bytes)
> swiotlb: coherent allocation failed for device 0000:05:00.0 size=8388608
> CPU: 11 PID: 148 Comm: kworker/11:1 Not tainted 4.7.0-rc4-dbg+ #1
> Call Trace:
>  [<ffffffff812c6d35>] dump_stack+0x67/0x92
>  [<ffffffff812efe71>] swiotlb_alloc_coherent+0x141/0x150
>  [<ffffffff810458be>] x86_swiotlb_alloc_coherent+0x3e/0x50
>  [<ffffffffa03861fa>] mlx4_buf_direct_alloc.isra.5+0x9a/0x120 [mlx4_core]
>  [<ffffffffa0386545>] mlx4_buf_alloc+0x165/0x1a0 [mlx4_core]
>  [<ffffffffa035053d>] create_qp_common.isra.29+0x57d/0xff0 [mlx4_ib]
>  [<ffffffffa03510da>] mlx4_ib_create_qp+0x12a/0x3f0 [mlx4_ib]
>  [<ffffffffa031154a>] ib_create_qp+0x3a/0x250 [ib_core]
>  [<ffffffffa055dd4b>] srpt_cm_handler+0x4bb/0xcad [ib_srpt]
>  [<ffffffffa02c1ab0>] cm_process_work+0x20/0xf0 [ib_cm]
>  [<ffffffffa02c3640>] cm_work_handler+0x1ac0/0x2059 [ib_cm]
>  [<ffffffff810737ed>] process_one_work+0x19d/0x490
>  [<ffffffff81073b29>] worker_thread+0x49/0x490
>  [<ffffffff8107a0ea>] kthread+0xea/0x100
>  [<ffffffff815b25af>] ret_from_fork+0x1f/0x40
> 
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 3 +--
>  drivers/infiniband/ulp/srpt/ib_srpt.h | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
> b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index e68b20cb..4a41556 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1638,8 +1638,7 @@ retry:
>  	 */
>  	qp_init->cap.max_send_wr = srp_sq_size / 2;
>  	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
> -	qp_init->cap.max_send_sge = max(sdev->device->attrs.max_sge_rd,
> -					sdev->device->attrs.max_sge);
> +	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
>  	qp_init->port_num = ch->sport->port;
>  
>  	ch->qp = ib_create_qp(sdev->pd, qp_init);
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h
> b/drivers/infiniband/ulp/srpt/ib_srpt.h
> index fee6bfd..3890304 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -106,6 +106,7 @@ enum {
>  	SRP_LOGIN_RSP_MULTICHAN_MAINTAINED = 0x2,
>  
>  	SRPT_DEF_SG_TABLESIZE = 128,
> +	SRPT_DEF_SG_PER_WQE = 16,
>  
>  	MIN_SRPT_SQ_SIZE = 16,
>  	DEF_SRPT_SQ_SIZE = 4096,
> --
> 2.8.4
> 
> 

Thanks Bart
I will test it today
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
