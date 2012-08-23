From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC] RDMA/cma: Make IPoIB port space multicast joins
 consistent with IPoIB
Date: Thu, 23 Aug 2012 15:45:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8A8DA@ORSMSX101.amr.corp.intel.com>
References: <1345732127-7765-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345732127-7765-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 7172559..f7e4cb9 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -3056,9 +3056,16 @@ static int cma_join_ib_multicast(struct rdma_id_private
> *id_priv,
>  		    IB_SA_MCMEMBER_REC_FLOW_LABEL |
>  		    IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
> 
> -	if (id_priv->id.ps == RDMA_PS_IPOIB)
> +	if (id_priv->id.ps == RDMA_PS_IPOIB) {
>  		comp_mask |= IB_SA_MCMEMBER_REC_RATE |
> -			     IB_SA_MCMEMBER_REC_RATE_SELECTOR;
> +			     IB_SA_MCMEMBER_REC_RATE_SELECTOR |
> +			     IB_SA_MCMEMBER_REC_MTU_SELECTOR |
> +			     IB_SA_MCMEMBER_REC_MTU |
> +			     IB_SA_MCMEMBER_REC_HOP_LIMIT;
> +
> +		rec.rate_selector = IB_SA_EQ;
> +		rec.mtu_selector  = IB_SA_EQ;
> +	}

So, the rdma cm joins a group without these set.  The SA picks some values, which differ from those used by ipoib.  IPoIB then joins a group, which fails because of the mismatch.  Is this the problem?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
