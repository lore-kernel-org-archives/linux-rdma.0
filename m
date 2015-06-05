From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 5 Jun 2015 15:19:19 -0600
Message-ID: <20150605211919.GA26016@obsidianresearch.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
 <20150604201953.GA7227@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB4FD7@CRSMSX101.amr.corp.intel.com>
 <20150605170521.GB7776@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB5071@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB5071-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 05, 2015 at 09:01:11PM +0000, Wan, Kaike wrote:
> > So, rather than a SA mad in netlink, I'd suggest actually using extensible
> > netlink here and define the query cleanly using nested
> > attributes:
> > 
> > RDMA_OP_RESOLVE (request)
> >   GIDS
> >   SERVICE_ID
> >   QOS/TCLASS
> >   PKEY
> >   QP TYPE (aka reversible)
> > 
> > RDMA_OP_RESOLVE (reply)
> >   IB_PATH
> >   IB_PATH
> >   IB_PATH
> 
> Are you saying that instead of defining the pathrecord attribute
> only, we can define the following simpler attributes: GID,
> SERVICE_ID, QOS/TCLASS, PKEY, QP TYPE, IB_PATH, and then use them in
> the request or response?

Request only.

Response will be an array of ib_path_rec_data (and sorry if I was
confusing on !user, user, the goal is to match ucma's existing API for
this, see ucma_set_ib_path).

Please check if we can extend the answer array too, or if it needs to
be more like:

RDMA_OP_RESOLVE (reply)
  RESOLVED_PATH (#1, REVERISBLE, GMP)
     FLAGS
     IB_PATH (ib_path_rec_data)
     FUTURE_EXTENSION
  RESOLVED_PATH (#2 FORWARD ONLY)
   ..
  RESOLVED_PATH (#3 REVERSE ONLY)
   ..
  RESOLVED_PATH (#4 Alternate FORWARD ONLY)
   ..
  RESOLVED_PATH (#5 Alternate REVERSE ONLY)
   ..
  RESOLVED_PATH (#6 Alternate REVERSIBLE, GMP)
   ..

To elaborte again: This is best API I've seen to add APM - userspace
can have the 'policy' side that APM needs and plug in to the kernel
here with this netlink interface. Obviously the kernel side is
missing, but lets plan ahead :)

> In this case, we need more attribute types
> (eg, SGID and DGID as two different attribute types instead of a
> single GID attribute type with a flags field in the attribute data)

Well, think about it and slice it up as you feel best, using netlink
conventions. Ie every address should be carryed similar to
IFLA_ADDRESS with the type (AF_*) and size appropriate.

SGID and DGID are mandatory, but the overhead of splitting them is
probably small ?

I'd *really* like to use QP TYPE instead of reversible, a UD QP has a
different path set need than a RC QP, for instance. This is forward
looking toward APM.

> > This could probably still be done under send_mad, and if you don't want to
> > finish the job then that is probably fine.
> 
> We would like to put netlink call under send_mad() for two reasons:
> 
> (1) It can potentially be used by other SA request (eg get
> ServiceRecord);
> (2) send_mad has other operations (store query point in idr map, set
> timeout) in addition to call the MAD stack. Theoretically, we could
> do all netlink call inside ib_sa_path_rec_get() before calling
> send_mad. However, since we need to handle timeout and netlink
> response in separate thread, we need to set everything up properly.

Yes, I appreciate this.

> > Even so, it isn't the netlink way to bury two different structs in the same
> > attribute, you need to use netlink headers to tell them apart, not buried
> > flags..
> 
> I was back and forth during the implementation on whether to use
> more attribute types or use a single attribute type and flags to
> define different structures. I can switch to use different
> attributes for different structures.

Generally speaking with netlink we want to see the attribute self
describe with the common length field. Different things get different
attributes. This lets you use the existing mechanics for handling
attributes and the code reads cleanly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
