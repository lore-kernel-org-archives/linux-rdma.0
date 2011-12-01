From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] rdma/cm: Update port reservation to support AF_IB
Date: Thu, 1 Dec 2011 10:37:02 +0200
Message-ID: <4ED73CAE.9080805@mellanox.com>
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
> +{
> +	struct idr *ps = NULL;
> +	struct sockaddr_ib *sib;
> +	u64 sid_ps, mask, sid;
> +
> +	sib = (struct sockaddr_ib *)&id_priv->id.route.addr.src_addr;
> +	mask = be64_to_cpu(sib->sib_sid_mask)&  RDMA_IB_IP_PS_MASK;
> +	sid = be64_to_cpu(sib->sib_sid)&  mask;
> +
> +	if ((id_priv->id.ps == RDMA_PS_IB)&&  (sid == (RDMA_IB_IP_PS_IB&  mask))) {
> +		sid_ps = RDMA_IB_IP_PS_IB;
> +		ps =&ib_ps;
> +	} else if (((id_priv->id.ps == RDMA_PS_IB) || (id_priv->id.ps == RDMA_PS_TCP))&&
> +		   (sid == (RDMA_IB_IP_PS_TCP&  mask))) {
> +		sid_ps = RDMA_IB_IP_PS_TCP;
> +		ps =&tcp_ps;
> +	} else if (((id_priv->id.ps == RDMA_PS_IB) || (id_priv->id.ps == RDMA_PS_UDP))&&
> +		   (sid == (RDMA_IB_IP_PS_UDP&  mask))) {
> +		sid_ps = RDMA_IB_IP_PS_UDP;
> +		ps =&udp_ps;
>   	}

I see here some relation between PS_IB to PS_TCP and PS_UDP, isn't a 
similar interaction is needed with PS_IPOIB?

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

so 0x3f here in RDMA_IB_IP_PS_IB stand's for IANA's "any local network", 
correct?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
