From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC} [PATCH 3/8 v2] libibverbs: Introduce XRC domains
Date: Wed, 26 Sep 2012 10:55:02 -0600
Message-ID: <20120926165502.GA7005@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8F4E3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8F4E3-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> + * ibv_open_xrcd - Open an extended connection domain
> + */
> +static inline struct ibv_xrcd *
> +ibv_open_xrcd(struct ibv_context *context, int fd, int oflags)
> +{
> +	struct verbs_context *vctx = verbs_get_ctx_op(context, open_xrcd);
> +	return vctx ? vctx->open_xrcd(context, fd, oflags) : NULL;
> +}

errno = ENOSYS on the error path?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
