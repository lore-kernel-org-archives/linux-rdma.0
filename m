From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core build environment enabling out-of-core providers
Date: Wed, 2 Aug 2017 14:23:00 -0600
Message-ID: <20170802202300.GA24244@obsidianresearch.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
 <20170802160900.GB21208@obsidianresearch.com>
 <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
 <20170802193403.GA23777@obsidianresearch.com>
 <01a001d30bca$b177e3c0$1467ab40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01a001d30bca$b177e3c0$1467ab40$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2017 at 03:05:31PM -0500, Steve Wise wrote:

> > Just be careful that all the cmake magic is working properly in your
> > other environment, for all the distros you want to target..
> 
> Well definitely no magic is happening in my specific experiment, since I just
> copied the headers from the built rdma-core tree which means they were
> customized for RHEL7.2, which is what was installed.  But I just wanted to get a
> feel for what files exactly were needed to build a provider.  I suppose I could
> take that cmake magic into my bldenv and just the src files needed to produce
> the auto-generated files.  Is it just the stdatomic.h file that is tweaked?

valgrind, stdatomic and some of the kernel are currently shimed, plus
some definitions in config.h that control a few things in compiler.h
and some of the ccan headers. The trick is this can change, and
future failure might be silent..

> > This could be automated, so you can develope against upstream, and
> > then using a script create a rdma-core with the classic private ABI,
> > and copy the provider from the upstream to build it.
> > 
> > Alternatively, just have your customers use a new libibverbs on
> > RHEL. That reduces your QA burden and development workload...
> 
> If my package installs libibverbs along with my provider, then
> potentially I break any existing providers installed with whatever
> rdma-core, ofed, or inboxed libibverbs that was installed.  I'm not
> sure if this is acceptable, but I agree it simplifies the QA matrix.

In this case install upstream rdma-core providers along side yours..

Also, I just looked for you, and found this:

https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7-Beta/html/7.4_Release_Notes/new_features_networking.html#BZ1404035

So RHEL 7.4 is shipping rdma-core 13 apparently ?

So replacing RHEL 7.4's rdma-core 13 with 15+your stuff is pretty
straightforward, IHMO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
