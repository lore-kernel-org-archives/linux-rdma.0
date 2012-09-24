From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4/8] livibverbs: Add support for XRC SRQs
Date: Mon, 24 Sep 2012 20:49:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8F034@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E801@ORSMSX101.amr.corp.intel.com>
 <20120924203401.GB9472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120924203401.GB9472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > @@ -1052,6 +1084,9 @@ static inline int ibv_req_notify_cq(struct ibv_cq *cq,
> int solicited_only)
> >  struct ibv_srq *ibv_create_srq(struct ibv_pd *pd,
> >  			       struct ibv_srq_init_attr *srq_init_attr);
> >
> > +struct ibv_srq *ibv_create_srq_ex(struct ibv_pd *pd,
> > +				  struct ibv_srq_init_attr_ex *srq_init_attr_ex);
> > +
> 
> Just to be clear here, the original proposals for this had an inline
> wrapper indirecting through a function pointer here to avoid a
> link-time dependency - is that something people still want?
> 
> If we are OK with a link time dependency, then do we need the new
> symbol name or can we just symbol version ibv_create_srq ? (accepting
> there are small problems with that..)

I got so completely lost in what was agreed upon and what wasn't.

I don't care much either way, but I don't see a clear advantage of avoiding the link time dependency.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
