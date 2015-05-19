From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 14:49:36 -0600
Message-ID: <20150519204936.GB24622@obsidianresearch.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
 <20150519190742.GO18675@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDD2D8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDD2D8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 08:27:22PM +0000, Hefty, Sean wrote:
> > I have mixed feelings about using the SA message format for this.
> > 
> > In-kernel we don't use that format, and many of the newer APIs were
> > designed around passing the GMP,Forward,Return path tuple, not just a
> > naked GMP.
> 
> I think the choice of the netlink protocol is a largely matter of
> taste.  In the internal review of these patches, the netlink hook
> was previously in the mad layer, which would have allowed
> redirecting any mad to user space.  (The code only attempted to
> redirect SA queries.)  Trying to hook from within ib_mad added a
> fair amount of complexity, that moving up into sa_query avoided.
> The proposed interface would allow moving the changes back down,
> versus limiting this only to the SA query calls.  (And I'm not
> meaning to imply that limiting this only to SA queries is a bad
> choice.)

I'm not sure there is much use case for letting user space get
involved in arbitary MAD traffic..

Over generalizing feels like over design and doesn't let us add
valuable information that could help push policy decisions into user
space, like passing the IP and TOS, QP type, etc when available, to
userspace.

If there is a use case for that, it still cleanly layers, the cache NL
query goes first, if that fails then the MAD-based NL query goes next.

> > I'd rather see the netlink data ask for what the kernel needs (eg UD
> > path to X, RC path to X) and return the new format we've already
> > established for AF_IB
> 
> Does anyone else have input on the netlink protocol?  Hal/Ira?  MADs
> seem more flexible, but higher-level structures more efficient and
> natural.

MADs are not more flexible, they are fixed and controlled by something
outside the kernel. Their upside is we can track certain limited
changes to the standard without too much effort.

But the same reasons we didn't use them for AF_IB holds here too:
 - Routers are not supported
 - Asymmetric (non-reversible) mesh networks are not supported

We should't bake in the already known limitations of PathRecord when
adding a new scheme.

Userspace should provide the same kind of information as AF_IB, in a
netlink container that could be extended in future.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
