From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH -v2 09/26] infiniband: rename random32() to prandom_u32()
Date: Thu, 03 Jan 2013 10:27:47 -0600
Message-ID: <50E5B183.4030706@opengridcomputing.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com> <1357215562-6288-10-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357215562-6288-10-git-send-email-akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Are there other "non pseudo-random" services that warrant this rename?

On 1/3/2013 6:19 AM, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>
> Signed-off-by: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>
> * Change from v1
> - leave net_random() callers as-is because that is a useful indirection
>
>   drivers/infiniband/hw/cxgb3/cxio_resource.c | 4 ++--
>   drivers/infiniband/hw/cxgb4/id_table.c      | 4 ++--
>   drivers/infiniband/hw/mlx4/mad.c            | 2 +-
>   drivers/infiniband/ulp/ipoib/ipoib_cm.c     | 2 +-
>   4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_resource.c b/drivers/infiniband/hw/cxgb3/cxio_resource.c
> index 31f9201..c40088e 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_resource.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_resource.c
> @@ -62,13 +62,13 @@ static int __cxio_init_resource_fifo(struct kfifo *fifo,
>   		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
>   	if (random) {
>   		j = 0;
> -		random_bytes = random32();
> +		random_bytes = prandom_u32();
>   		for (i = 0; i < RANDOM_SIZE; i++)
>   			rarray[i] = i + skip_low;
>   		for (i = skip_low + RANDOM_SIZE; i < nr - skip_high; i++) {
>   			if (j >= RANDOM_SIZE) {
>   				j = 0;
> -				random_bytes = random32();
> +				random_bytes = prandom_u32();
>   			}
>   			idx = (random_bytes >> (j * 2)) & 0xF;
>   			kfifo_in(fifo,
> diff --git a/drivers/infiniband/hw/cxgb4/id_table.c b/drivers/infiniband/hw/cxgb4/id_table.c
> index f95e5df..0161ae6 100644
> --- a/drivers/infiniband/hw/cxgb4/id_table.c
> +++ b/drivers/infiniband/hw/cxgb4/id_table.c
> @@ -54,7 +54,7 @@ u32 c4iw_id_alloc(struct c4iw_id_table *alloc)
>   
>   	if (obj < alloc->max) {
>   		if (alloc->flags & C4IW_ID_TABLE_F_RANDOM)
> -			alloc->last += random32() % RANDOM_SKIP;
> +			alloc->last += prandom_u32() % RANDOM_SKIP;
>   		else
>   			alloc->last = obj + 1;
>   		if (alloc->last >= alloc->max)
> @@ -88,7 +88,7 @@ int c4iw_id_table_alloc(struct c4iw_id_table *alloc, u32 start, u32 num,
>   	alloc->start = start;
>   	alloc->flags = flags;
>   	if (flags & C4IW_ID_TABLE_F_RANDOM)
> -		alloc->last = random32() % RANDOM_SKIP;
> +		alloc->last = prandom_u32() % RANDOM_SKIP;
>   	else
>   		alloc->last = 0;
>   	alloc->max  = num;
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
> index 0a903c1..b247c5b 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -93,7 +93,7 @@ static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
>   __be64 mlx4_ib_gen_node_guid(void)
>   {
>   #define NODE_GUID_HI	((u64) (((u64)IB_OPENIB_OUI) << 40))
> -	return cpu_to_be64(NODE_GUID_HI | random32());
> +	return cpu_to_be64(NODE_GUID_HI | prandom_u32());
>   }
>   
>   __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 03103d2..0e0016d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -460,7 +460,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>   		goto err_qp;
>   	}
>   
> -	psn = random32() & 0xffffff;
> +	psn = prandom_u32() & 0xffffff;
>   	ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
>   	if (ret)
>   		goto err_modify;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
