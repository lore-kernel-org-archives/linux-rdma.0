From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] IB/CMA: Invalidate connections in port space IPoIB
 over Ethernet link layer
Date: Tue, 12 Jul 2011 00:47:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302D874@ORSMSX101.amr.corp.intel.com>
References: <1310405369-24822-1-git-send-email-monis@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310405369-24822-1-git-send-email-monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index b6a33b3..2d60130 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -359,6 +359,10 @@ static int cma_acquire_dev(struct rdma_id_private
> *id_priv)
>  	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
>  		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
> 
> +	if (dev_ll == IB_LINK_LAYER_ETHERNET &&
> +		id_priv->id.ps == RDMA_PS_IPOIB)
> +		return -EINVAL;

thanks - one nit - can you change the first part to dev_ll != IB_LINK_LAYER_INFINIBAND?  Just in case we ever add a new link type, we don't need to change the check.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
