From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Thu, 11 Jun 2015 13:51:54 -0600
Message-ID: <20150611195154.GB24457@obsidianresearch.com>
References: <1434042225-4975-1-git-send-email-kaike.wan@intel.com>
 <1434042225-4975-2-git-send-email-kaike.wan@intel.com>
 <20150611175803.GC20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2CD@CRSMSX101.amr.corp.intel.com>
 <20150611185136.GC20779@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD33C@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABD33C-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 07:21:11PM +0000, Wan, Kaike wrote:
> > Recommend a 'QP Type' with options of:
> >  - RC QP: Return up to the full 6 path tuple with full APM data
> >  - UD QP: Return a single non-reversible path
> >  - GMP QP: Return up to two reversible GMP paths.
> > 
> > If it is hard to get accurate information then you can sketch this in and infer
> > RC QP and GMP QP by the request having the reversible set bit. But ideally
> > RDMA CM and SRP would request RC QP, IPoIB would request UD QP.
> 
> It's quite indirect here for this implementation. (ib_sa_path_rec_get())
> 
> Caller         reversible                        numb_path             QP Type
> cma              1                                                1                     GMP
> ipoib             Not set                                    1 (?)                UD 
> srp                Not set                                    1                      UD

CMA (mostly) and SRP use RC paths. IPoIB uses UD and RC. The IPoIB
path record query looks wrong for RC mode because it does not request
reversible, that should be fixed independently.

The indirection is because you don't want to modify the callers to
provide their additional information, which is probably a mistake. Add
a netlink fill callback and do it there?

> In addition, on the user side, we need to convert QP type back into
> reversible_numpath again, which may not interpret the original
> request correctly.  Why should we do all the translation?

The goal is to carry enough context information so that user space can
do something smart. We have alot more information available to drive
policy than is present in the simple IBA Path Record MAD.

In this case, the kernel does not actually care about numb paths or
reversible, except in the context of how it intends to use the
path(s).

For instance, having CM ask for reversible makes no sense, since in
the general case it wants the 3 path tuple of
GMP(reversible=1),FORWARD(reversible=0),RETURN(reversible=0). Similarly,
it doesn't make sense to ask for numbPath=1 because in the general
case it wants the 6 path APM set.

Being more specific here allows userspace to implement more detailed
policy beyond what the IB Path Record scheme allows. And for that we
need the context information from the requestor.

acm won't use it, it will always request numbPaths=1 and derive the
reversible bit from this netlink field. (or always set reversible=1)

> Is QP type definition already exported to user space?

QP Type could be a bad name, open to ideas

> I see  IBV_QPT_RC/UC/UD/RAW_PACKET/XRC_SEND/XRC_RECV, but not GMP in verbs.h.

GMP is a special case of UD.

> > > +/* Local Service ServiceID attribute */ struct rdma_nla_ls_service_id
> > > +{
> > > +	__be64		service_id;
> > > +};
> > 
> > Do not expose BE to userspace, everything should be in cpu order.
> 
> If we use cpu order, we need to do two conversions: from BE to cpu
> order in kernel and from cpu order to BE in user space. Struct
> ib_user_path_rec contains many __be32 fields.

I don't see a problem with the extra conversion.

IIRC ib_user_path_rec is an image of the SA Path Record Reply MAD, so
it should be byte for byte identical, which is why it has BE elements,
that is not to be encouraged generally..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
