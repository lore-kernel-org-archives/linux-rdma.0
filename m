From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Thu, 11 Jun 2015 23:56:17 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1109C100@CRSMSX101.amr.corp.intel.com>
References: <1434042225-4975-1-git-send-email-kaike.wan@intel.com>
 <1434042225-4975-2-git-send-email-kaike.wan@intel.com>
 <20150611175803.GC20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2CD@CRSMSX101.amr.corp.intel.com>
 <20150611185136.GC20779@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD33C@CRSMSX101.amr.corp.intel.com>
 <20150611195154.GB24457@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611195154.GB24457-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > Is QP type definition already exported to user space?
> 
> QP Type could be a bad name, open to ideas

I think the name "QP Type" is bad...

I want to say "transport type" but I don't think that really communicates what we want here.

> 
> > I see  IBV_QPT_RC/UC/UD/RAW_PACKET/XRC_SEND/XRC_RECV, but not
> GMP in verbs.h.
> 
> GMP is a special case of UD.

I think this is where QP Type (or "Transport type") are not equivalent to if a path needs to be reversible or not.

To properly derive the reversibility requires more than the transport.  There is nothing which precludes me from requesting a reversible path for any QP Type.

This is really a "protocol" attribute and it seems that each protocol could potentially want a reversible Path Record independent of the QP or "Transport Type".

> 
> > > > +/* Local Service ServiceID attribute */ struct
> > > > +rdma_nla_ls_service_id {
> > > > +	__be64		service_id;
> > > > +};
> > >
> > > Do not expose BE to userspace, everything should be in cpu order.
> >
> > If we use cpu order, we need to do two conversions: from BE to cpu
> > order in kernel and from cpu order to BE in user space. Struct
> > ib_user_path_rec contains many __be32 fields.
> 
> I don't see a problem with the extra conversion.

Neither do I.  All user space values should be in host order.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
