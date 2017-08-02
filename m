From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core build environment enabling out-of-core providers
Date: Wed, 2 Aug 2017 14:16:09 -0500
Message-ID: <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com> <20170802160900.GB21208@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170802160900.GB21208-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Currently there is no way to build an out-of-rdma-core provider on a
> > system installed with rdma-core.  It would be useful to have
> > rdma-core install the needed headers and libs (ie the ccan stuff) as
> > part of its install.  This would be similar to previous releases of
> > libibverbs that included the headers needed for providers to build.
> > I would like to implement this for rdma-core, but wanted feedback on
> > this approach.  Maybe an rdma-core-devel type package?  I guess I'm
> > thinking this would be analogous to building out-of-kernel modules,
> > which is available for kernel developers.
> 
> I don't think that really works. eg the util/mmio.h relies on
> stdatomic.h to work, which means it relies on the cmake shim to
> provide stdatomic.h on old systems. Other private headers may be similar
> in their integration with cmake/etc.
> 
> You can't really publish those headers sanely, and part of the point
> here was specifically to allow using things like statomic.h properly
> without having to be concerned about how to install the shim into a
> public header.
> 
> In my view, the best approach, which I have suggested before, is to
> build the out-of-tree stuff 'in-tree' and discard everything except
> the single provider library you are building for. For instance, a rpm
> spec file that produces as contents a single provider shlib.
> 
> This seems like the least amount of work for everyone, and it doesn't
> really matter, I think, that the 'source' for the 'provider' carries
> lots of unbuilt stuff.
> 
> Perhaps the best way to accomplish that is to add a sample rpm spec
> file to Documentation/ or something that shows how to do that. If you
> want to take a first stab at it I can give you some help.

Hey Jason, Thanks for this detailed response!  I appreciate it.  

Today I did two experiments:

1) I took my out-of-tree provider, and moved it into rdma-core, updated it to
use the rdma-core bldenv and APIs.  This included the rdma-core mmio and
dma/cache services, plus a few other nits like ccan, and the new byte swapping
API, and got it building.  That was pretty straight forward.

2) I took the updated out-of-tree provider src from 1), and put it back in the
out-of-tree provider automake/config bldenv, and then tried to pull in whatever
was needed from rdma-core to build it.  This resulted in me pulling certain
files, like you mentioned above.  I just pulled them from the rdma-core/build/
tree for the sake of getting it to build.   Basically I needed ccan/*
infiniband/driver.h, and util/compiler.h/udma_barrier.h.  That got it to build.


I haven't tested either of these yet to see if they actually load.  But that's
where I'm at.  #2 has the issues you describe, in that the atomic header is
auto-generated based on the installed distro/platform.  So that leads to using
#1 which is what you recommend.  I'm ok with using #1, but then the issue
becomes supporting my provider across older non rdma-core installed systems.
Ideally, I want to be able to build my provider to install into a RHEL7.x
system, for example, which uses the older libibverbs.  But I also want it to
build/install into a system installed with OFED-4.8 which includes rdma-core-14
I think, as well as SLE12SP3 which has rdma-core as part of its distribution as
well.

I guess the issue is how to use 1) but allow a build/install into an older
libibverbs system.   I don't think it is possible w/o a hybrid bldenv that uses
rdma-core bldenv if that is what is installed, or the old libibverbs
headers/APIs if that is installed. 

And I'm trying to do this cleanly :)  (backporting is rarely clean)

Thanks,

Steve




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
