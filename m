From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC} [PATCH 3/8 v2] libibverbs: Introduce XRC domains
Date: Wed, 26 Sep 2012 16:57:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A9784A@FMSMSX151.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8F4E3@ORSMSX101.amr.corp.intel.com>
 <20120926165502.GA7005@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120926165502.GA7005-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > + * ibv_open_xrcd - Open an extended connection domain
> > + */
> > +static inline struct ibv_xrcd *
> > +ibv_open_xrcd(struct ibv_context *context, int fd, int oflags)
> > +{
> > +	struct verbs_context *vctx = verbs_get_ctx_op(context, open_xrcd);
> > +	return vctx ? vctx->open_xrcd(context, fd, oflags) : NULL;
> > +}
> 
> errno = ENOSYS on the error path?

verbs is hit and miss on that, but I'll add it
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
