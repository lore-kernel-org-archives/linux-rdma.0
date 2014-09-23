From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2] svcrdma: Advertise the correct max payload
Date: Tue, 23 Sep 2014 14:42:34 -0500
Message-ID: <00a701cfd766$855044e0$8ff0cea0$@opengridcomputing.com>
References: <20140922200547.19909.68196.stgit@build.ogc.int> <465554E1-802A-4D37-8032-4E99B96B8BFB@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <465554E1-802A-4D37-8032-4E99B96B8BFB-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> > diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> > index c419498..a9cf5c3 100644
> > --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> > +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> > @@ -392,4 +392,8 @@ extern struct kmem_cache *svc_rdma_ctxt_cachep;
> > /* Workqueue created in svc_rdma.c */
> > extern struct workqueue_struct *svc_rdma_wq;
> >
> > +#define RPCSVC_MAXPAYLOAD_RDMA \
> > +	(RPCSVC_MAXPAYLOAD < (RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT) ? \
> > +	 RPCSVC_MAXPAYLOAD : (RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT))
> > +
> 
> Couldn't you use:
> 
> #if RPCSVC_MAXPAYLOAD < (RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT)
> #define RPCSVC_MAXPAYLOAD_RDMA RPC_MAXPAYLOAD
> #else
> #define RPCSVC_MAXPAYLOAD_RDMA (RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT)
> #endif
> 
> That seems more idiomatic.

Sure.  That makes it easier to read in my opinion too.

I'll send out V3 with this change.

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
