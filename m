From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core soon in Debian
Date: Thu, 27 Jul 2017 16:37:01 -0600
Message-ID: <20170727223701.GA8740@obsidianresearch.com>
References: <1500041591.3563.31.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500041591.3563.31.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 14, 2017 at 04:13:11PM +0200, Benjamin Drung wrote:
> Hi everyone,
> 
> a few weeks passed since my last status update regarding rdma-core in
> Debian. We made good progress in getting it ready. Only three items are
> left:
> 
> 1) I sent three patches for the ibacm and iwpmd service to the mailing
> list. They need to be reviewed and accepted:

This is done.

> 2) Common infrastructure for auto loading rdma modules: See the "Add
> rdma service for kernel boot support" thread on this mailing list.
> Jason Gunthorpe made a very good proposal were I made some comments on
> it.

This is now PR 174.

Also, I tested the Debian packages in various way and all most of my
fixes are now commited.

> 3) Get rid of openibd and rdma service dependencies:
> 
> $ git grep openibd
> ibacm/CMakeLists.txt:set(rdmascript "openibd")
> srp_daemon/CMakeLists.txt:set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")

These both relate to the init.d scripts,

AFAIK Debian is basically the only user of the init.d scripts, so you
should do whatever is appropriate. I think you can just drop both
references.

> $ git grep rdma.service -- ibacm/
> ibacm/ibacm.service.in:Requires=rdma.service
> ibacm/ibacm.service.in:After=rdma.service opensm.service

I will look at this next, I intend to make ibacm socket activatable,
which will take care of lots of ordering problems. verbs hot-plug (now
merged) and eventually rdma_cm hot plug should fix the rest.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
