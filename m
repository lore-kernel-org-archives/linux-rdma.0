From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: building rdma-core from travis
Date: Tue, 18 Oct 2016 11:00:07 -0600
Message-ID: <20161018170007.GA11537@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB096A7B@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB096A91@ORSMSX109.amr.corp.intel.com>
 <20161018050834.GF25013@leon.nu>
 <20161018160716.GB24189@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB096CC3@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB096CC3-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 18, 2016 at 04:31:23PM +0000, Hefty, Sean wrote:
> > Right. rdma-core does not support precise, at all. Aside from cmake,
> > the original source packages had some non-functional 'compat' for such
> > an old glibc (from 2012!) that I stripped out as well.
> 
> To people who use vi to write C code with text-based email for their
> code review process, 2012 is spaceship futuristic.

Well, those people will suffer then *shrug*

> > I can't recommend that anybody working on a c-language project should
> > be using the precise images on travis for anything <shrug>
> 
> We use containers, which are supposed to be faster for processing.

I seem to recall the GCE images have faster CPUs but spend more time
booting the VM.

For rdma-core I counter balanced the VM spin up time by avoiding the
matrix feature. rdma-core has a very fast compile at 19s, I can run
all four compiler passes in less time than it takes to spin up and
configure the VM, container or not :\.

For something like libfabric you might get a win if you do the same
and run fabtests on one of the compiler's output instead of for both.

Plus, if you use trusty you don't need to download and compile
rdma-core, just install libibverbs-dev and librdmacm-dev from Ubuntu.

But at the end of the day, it depend what you expect out of
travis. rdma-core has travis setup to try and show that the code is
clean with bleeding edge rolling release distros (eg forward
looking).

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
