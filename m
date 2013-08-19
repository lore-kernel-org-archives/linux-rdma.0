From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Add new verb: uv_query_port_max_datagram()
Date: Mon, 19 Aug 2013 22:36:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA6D9F@ORSMSX109.amr.corp.intel.com>
References: <1376942704-25270-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376942704-25270-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 4b1ab57..a1d6c3d 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -712,6 +712,7 @@ struct ibv_context_ops {
>  	int			(*detach_mcast)(struct ibv_qp *qp, const union ibv_gid
> *gid,
>  						uint16_t lid);
>  	void			(*async_event)(struct ibv_async_event *event);
> +	int			(*query_port_max_datagram)(struct ibv_context *context,
> uint8_t port_num, uint32_t *max_datagram);
>  };

This breaks the libibverbs ABI.  You can't modify ibv_context_ops because it changes struct ibv_context.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
