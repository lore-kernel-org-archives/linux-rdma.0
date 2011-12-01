From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] rdma/cm: Update port reservation to support AF_IB
Date: Thu, 1 Dec 2011 10:49:05 +0200
Message-ID: <4ED73F81.6060605@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E8D150@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E8D150-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/4/2011 9:08 AM, Hefty, Sean wrote:
> +static struct idr *cma_select_ib_ps(struct rdma_id_private *id_priv)
> [...]
> +	if (ps) {
> +		sib->sib_sid = cpu_to_be64(sid_ps | ntohs(cma_port((struct sockaddr *) sib)));
> +		sib->sib_sid_mask = cpu_to_be64(RDMA_IB_IP_PS_MASK | sib->sib_sid_mask);
> +	}
> +	return ps;

looks like ntohs(cma_port((struct sockaddr *) sib)) introduced this sparse warning

> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer
> drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64 
> degrades to integer


>
> +}
> +
> +static int cma_get_port(struct rdma_id_private *id_priv)
> +{
> +	struct idr *ps;
> +	int ret;
> +
> +	if (id_priv->id.route.addr.src_addr.ss_family != AF_IB)
> +		ps = cma_select_inet_ps(id_priv);
> +	else
> +		ps = cma_select_ib_ps(id_priv);
> +	if (!ps)
> +		return -EPROTONOSUPPORT;
> +
>   	mutex_lock(&lock);
>   	if (cma_any_port((struct sockaddr *)&id_priv->id.route.addr.src_addr))
>   		ret = cma_alloc_any_port(ps, id_priv);
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index 51988f8..5eb3179 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -70,6 +70,11 @@ enum rdma_port_space {
>   	RDMA_PS_UDP   = 0x0111,
>   };
>
> +#define RDMA_IB_IP_PS_MASK   0xFFFFFFFFFFFF0000ULL
> +#define RDMA_IB_IP_PS_TCP    0x0000000001060000ULL
> +#define RDMA_IB_IP_PS_UDP    0x0000000001110000ULL
> +#define RDMA_IB_IP_PS_IB     0x00000000013F0000ULL
> +
>   struct rdma_addr {
>   	struct sockaddr_storage src_addr;
>   	struct sockaddr_storage dst_addr;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
