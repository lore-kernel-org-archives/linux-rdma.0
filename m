From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 04:04:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390360721-14894-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 4b1ab57..ff9a1aa 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -68,13 +68,17 @@ enum ibv_node_type {
>  	IBV_NODE_CA 		= 1,
>  	IBV_NODE_SWITCH,
>  	IBV_NODE_ROUTER,
> -	IBV_NODE_RNIC
> +	IBV_NODE_RNIC,
> +	IBV_NODE_USNIC,
> +	IBV_NODE_USNIC_UDP,

Are these really different nodes or just different transports for the same NIC?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
