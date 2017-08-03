From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core build environment enabling out-of-core providers
Date: Thu, 3 Aug 2017 08:48:50 -0500
Message-ID: <008401d30c5f$3c9e2560$b5da7020$@opengridcomputing.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com> <20170802160900.GB21208@obsidianresearch.com> <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com> <44b511c6-45fa-d5aa-4d4c-e47d2edcf604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44b511c6-45fa-d5aa-4d4c-e47d2edcf604-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nicolas Morey-Chaisemartin' <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >>
> >> You can't really publish those headers sanely, and part of the point
> >> here was specifically to allow using things like statomic.h properly
> >> without having to be concerned about how to install the shim into a
> >> public header.
> >>
> >> In my view, the best approach, which I have suggested before, is to
> >> build the out-of-tree stuff 'in-tree' and discard everything except
> >> the single provider library you are building for. For instance, a rpm
> >> spec file that produces as contents a single provider shlib.
> >>
> >> This seems like the least amount of work for everyone, and it doesn't
> >> really matter, I think, that the 'source' for the 'provider' carries
> >> lots of unbuilt stuff.
> >>
> >> Perhaps the best way to accomplish that is to add a sample rpm spec
> >> file to Documentation/ or something that shows how to do that. If you
> >> want to take a first stab at it I can give you some help.
> > Hey Jason, Thanks for this detailed response!  I appreciate it.
> >
> > Today I did two experiments:
> >
> > 1) I took my out-of-tree provider, and moved it into rdma-core, updated it to
> > use the rdma-core bldenv and APIs.  This included the rdma-core mmio and
> > dma/cache services, plus a few other nits like ccan, and the new byte swapping
> > API, and got it building.  That was pretty straight forward.
> >
> > 2) I took the updated out-of-tree provider src from 1), and put it back in the
> > out-of-tree provider automake/config bldenv, and then tried to pull in whatever
> > was needed from rdma-core to build it.  This resulted in me pulling certain
> > files, like you mentioned above.  I just pulled them from the rdma-core/build/
> > tree for the sake of getting it to build.   Basically I needed ccan/*
> > infiniband/driver.h, and util/compiler.h/udma_barrier.h.  That got it to build.
> >
> >
> > I haven't tested either of these yet to see if they actually load.  But that's
> > where I'm at.  #2 has the issues you describe, in that the atomic header is
> > auto-generated based on the installed distro/platform.  So that leads to using
> > #1 which is what you recommend.
> Hi,
> 
> I 'm not sure I see the issue here (or at least nothing easily fixed).
> If the standard spec produces an extra rdma-core-provider-devel with those
> headers, it's just a matter of rebuilding the out-of-tree provider against the right
> distro/package.
> 

After thinking about this more, I agree:  If rdma-core is built into binary platform and distro-specific rpms, then these header files are definitely available to export as a -devel rpm for that same platform/distro.  

Jason, am I missing something?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
