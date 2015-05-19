From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 23:55:04 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB28F2@CRSMSX101.amr.corp.intel.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
 <20150519190742.GO18675@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDD2D8@ORSMSX109.amr.corp.intel.com>
 <20150519231526.GA25187@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519231526.GA25187-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, May 19, 2015 at 02:27:22PM -0600, Hefty, Sean wrote:
> > > I have mixed feelings about using the SA message format for this.
> > >
> > > In-kernel we don't use that format, and many of the newer APIs were
> > > designed around passing the GMP,Forward,Return path tuple, not just
> > > a naked GMP.
> >
> > I think the choice of the netlink protocol is a largely matter of
> > taste.  In the internal review of these patches, the netlink hook was
> > previously in the mad layer, which would have allowed redirecting any
> > mad to user space.  (The code only attempted to redirect SA queries.)
> > Trying to hook from within ib_mad added a fair amount of complexity,
> > that moving up into sa_query avoided.  The proposed interface would
> > allow moving the changes back down, versus limiting this only to the
> > SA query calls.  (And I'm not meaning to imply that limiting this only
> > to SA queries is a bad choice.)
> >
> > > I'd rather see the netlink data ask for what the kernel needs (eg UD
> > > path to X, RC path to X) and return the new format we've already
> > > established for AF_IB
> >
> > Does anyone else have input on the netlink protocol?  Hal/Ira?  MADs seem
> more flexible, but higher-level structures more efficient and natural.
> 
> 
> The idea was to implement a local SA cache.  Nothing more.  A lot of what is
> being discussed is beyond the intent of the patches.
> 
> Ira

The higher-level scheme discussed so far can be implemented using similar mechanism (netlink), but with a different netlink multicast group, and therefore different data exchange format. Maybe it should be done in another patch series.

Kaike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
