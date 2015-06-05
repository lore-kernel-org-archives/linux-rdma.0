From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 5 Jun 2015 21:02:56 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB5089@CRSMSX101.amr.corp.intel.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
 <20150604201953.GA7227@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB4FD7@CRSMSX101.amr.corp.intel.com>
 <20150605170521.GB7776@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE54EC@ORSMSX109.amr.corp.intel.com>
 <20150605205946.GC12504@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150605205946.GC12504-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Friday, June 05, 2015 5:00 PM
> 
> On Fri, Jun 05, 2015 at 08:53:01PM +0000, Hefty, Sean wrote:
> > > RDMA_OP_RESOLVE (reply)
> > >   IB_PATH
> > >   IB_PATH
> > >   IB_PATH
> >
> > I thought you were asking to move the hook site.  This approach seems
> > reasonable.  We should just need to add a check against the compmask.
> 
> I've been asking if we can include more meta-information, like the netdev for
> rdma-cm and ipoib. Having the hook site in send_mad makes that seem hard
> to reach. (maybe not?)
> 
> One one hand, it would be nice to launch a new UAPI with broad feature
> completeness, on the other hand, if it is a lot of work then go incremental.
> That is why I only said I was surprised :)

I would like the incremental approach.

Kaike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
