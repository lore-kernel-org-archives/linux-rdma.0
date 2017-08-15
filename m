From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 2/2] rdma: Autoload netlink client modules
Date: Tue, 15 Aug 2017 10:57:37 -0600
Message-ID: <20170815165737.GB15171@obsidianresearch.com>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170815095651.GQ24282@mtr-leonro.local>
 <20170815153523.GA14623@obsidianresearch.com>
 <20170815155843.GT24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170815155843.GT24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 15, 2017 at 06:58:43PM +0300, Leon Romanovsky wrote:
> On Tue, Aug 15, 2017 at 09:35:23AM -0600, Jason Gunthorpe wrote:
> > On Tue, Aug 15, 2017 at 12:56:51PM +0300, Leon Romanovsky wrote:
> >
> > > Can it be something like that (untested)?
> > > #define MODULE_ALIAS_RDMA_NETLINK(_index)
> >
> > No, MODULE_ALIAS does something like
> >
> > static const char __UNIQUE_ID(name)[]
> >   __used __attribute__((section(".modinfo"), unused, aligned(1))) = __stringify(tag) "=" info;
> >
> > So it must accept a string produced by the pre-processor, not by code.
> 
> But the netlink indexes were defined as anonymous enum, can we safely
> convert them to be defines?

Technically no, we shouldn't, the difference could break things.. But
due to the limited use of the header we probably could change to
defines.

Either way doesn't really matter..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
