From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core build environment enabling out-of-core providers
Date: Wed, 2 Aug 2017 15:05:31 -0500
Message-ID: <01a001d30bca$b177e3c0$1467ab40$@opengridcomputing.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com> <20170802160900.GB21208@obsidianresearch.com> <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com> <20170802193403.GA23777@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170802193403.GA23777-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> > 2) I took the updated out-of-tree provider src from 1), and put it back in
the
> > out-of-tree provider automake/config bldenv, and then tried to pull in
whatever
> > was needed from rdma-core to build it.  This resulted in me pulling certain
> > files, like you mentioned above.  I just pulled them from the
rdma-core/build/
> > tree for the sake of getting it to build.   Basically I needed ccan/*
> > infiniband/driver.h, and util/compiler.h/udma_barrier.h.  That got it to
build.
> 
> Just be careful that all the cmake magic is working properly in your
> other environment, for all the distros you want to target..

Well definitely no magic is happening in my specific experiment, since I just
copied the headers from the built rdma-core tree which means they were
customized for RHEL7.2, which is what was installed.  But I just wanted to get a
feel for what files exactly were needed to build a provider.  I suppose I could
take that cmake magic into my bldenv and just the src files needed to produce
the auto-generated files.  Is it just the stdatomic.h file that is tweaked?

> 
> > I haven't tested either of these yet to see if they actually load.  But
that's
> > where I'm at.  #2 has the issues you describe, in that the atomic header is
> > auto-generated based on the installed distro/platform.  So that leads to
using
> > #1 which is what you recommend.  I'm ok with using #1, but then the issue
> > becomes supporting my provider across older non rdma-core installed
> > systems.
> 
> You can handle this by rolling back the rdma-core repository to the
> right points in history and re-instering your provider. This will
> require some level of cherry picking future patches (eg ccan, etc),
> but may be the simplest approach for this specific requirement.
> 
> This would be somewhere around
> 0c0914e1e9b7a68bcebfe785b6df30500ca7d2e0 for RHEL7 libibverbs.
> 
> You can find a similar point for OFED.
> 

Hmm.  This is interesting.

> This could be automated, so you can develope against upstream, and
> then using a script create a rdma-core with the classic private ABI,
> and copy the provider from the upstream to build it.
> 
> Alternatively, just have your customers use a new libibverbs on
> RHEL. That reduces your QA burden and development workload...

If my package installs libibverbs along with my provider, then potentially I
break any existing providers installed with whatever rdma-core, ofed, or inboxed
libibverbs that was installed.   I'm not sure if this is acceptable, but I agree
it simplifies the QA matrix.  

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
