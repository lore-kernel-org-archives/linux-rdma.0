From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 13/13] Remove ibsupport-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org from MAINTAINERS
Date: Sat, 24 Sep 2016 10:56:45 -0600
Message-ID: <20160924165645.GA16206@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-14-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474724600.6625.1.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474724600.6625.1.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 24, 2016 at 01:43:25PM +0000, Dalessandro, Dennis wrote:
> On Fri, 2016-09-23 at 13:17 -0600, Jason Gunthorpe wrote:
> > Turns out this is not a mailing list.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ??MAINTAINERS | 1 -
> > ??1 file changed, 1 deletion(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index b39529feec9b..7a31376056e0 100644
> > +++ b/MAINTAINERS
> > @@ -69,7 +69,6 @@ F:	ibacm/*
> > ??IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)
> > ??M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ??S:	Supported
> > -L:	ibsupport-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> > ??F:	libipathverbs/
> > ??
> > ??IWARP PORT MAPPER DAEMON (for iwarp kernel providers)
> 
> This is the right one to use, while you are at it you can tack my name
> onto here as well.
> 
> https://github.com/01org/opa-libhfi1verbs/commit/377b68888a0b885fc2a44ddf7a2ec33f2fcf217b

intel-opa is the address you want for for QIB too? It is already in the
HFI stanza

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
