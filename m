From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Fri, 23 Sep 2016 11:03:14 -0600
Message-ID: <20160923170314.GA13920@obsidianresearch.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08E609@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB08E609-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2016 at 04:58:48PM +0000, Hefty, Sean wrote:
> > diff --git a/COPYING.BSD_FB b/COPYING.BSD_FB
> > new file mode 100644
> > index 000000000000..44237612faa3
> > +++ b/COPYING.BSD_FB
> > @@ -0,0 +1,22 @@
> > +		   OpenIB.org BSD license (FreeBSD Variant)
> 
> Openib.org doesn't exist.  Can we just drop that term from the files?

Maybe? I don't know, that is starting to go down the path that Leon
alluded to regarding getting legal advice.

That would be a different patch, IMHO.

Normally I'd say to avoid confusion it is good to stick with the
historical names, but in this case there are three things calling
themselves the openib.org bsd license, so I don't know :|

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
