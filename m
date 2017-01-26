From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Thu, 26 Jan 2017 14:49:00 -0700
Message-ID: <20170126214900.GA31937@obsidianresearch.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126182753.GA5056@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0E132B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0E132B-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 08:38:40PM +0000, Hefty, Sean wrote:
> > > There should not be any compat - it's just going to drag down
> > > development and everyone is free to submit their provider to rdma-
> > core,
> > > same as kernel drivers.
> > 
> > Yep, that was the argument that won the day so far.
> 
> I don't disagree with the direction, but I agree with Benjamin.  The
> intent behind a public symbol/structure and their actual usage by
> applications may differ.  Why wasn't the soname updated?

Well, no it cannot differ. If apps use private symbols they get
burned. Glibc and gcc have established that precedent decades ago.

The soname is not bumped because libibverbs is a symver based library,
which means we can manage our private ABI safely without ever
requiring soname changes. If something does manage to link to it then
it gets a runtime dynamic linking failure, not a random crash.

Remember, libibverbs fundamentally does not support two copies of the
library in the same address space, so one of the major motivations to
use a soname to manage version is invalid. Even worse, because of
this, if we did bump the soname, it would be very painful and
dangerous.

So that leaves us with only one point to argue on: Should libibverbs
have a private ABI or not? If yes, then we are doing it properly.

The issue is muddied a bit because the private ABI has not been as
absolutely private as I'd like, so we could add compat for the two
symbols and defer the incompat transition till a later release.. This
argument would be best supported if someone knows of something that
actually breaks out in the wild...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
