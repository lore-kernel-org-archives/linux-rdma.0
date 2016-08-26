From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 26 Aug 2016 16:27:25 -0600
Message-ID: <20160826222725.GA8553@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <20160826154206.GK1916@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160826154206.GK1916-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 26, 2016 at 11:42:06AM -0400, Jarod Wilson wrote:

> > Would you help making a spec file that is close to what you
> > could use in the distro? I don't really care if it is stored in the
> > package or stored inside RH, but we need to get one made.
> 
> Sure. It would probably be something to route through Fedora first though,
> and I don't own all the packages this would encompass in Fedora, but could
> certainly round a few people up and help out.

Sounds good, here are my thoughts let me know what you think:

1) Compiler flags/etc. I haven't audited all the CentOS rpms, but at
   least verbs overrides the compiler flag to set -fno-strict-aliasing
   Upstream should be distributing the package in a way that works, so
   downstream should not need do this. We need to decide if we want/need to
   force no-strict-aliasing or not, or use some kind of compiler
   test or whatever.
2) Static libraries. Do we want to continue to provide these? Looking
   at it, I'm skeptical that libibverbs works at all as a static, does
   anyone know? Particularly, how does it work? Should we get rid of
   it or do more work to try and make it work sanely. (eg a
   libibverbs.a that includes all the providers or something)
3) Version numbers. What version numbers do we give to the sub
   packages? I guess this is very distro specific.
4) Package split. I'm suggesting
    libibcm1 -devel -static
    libibumad3 -devel -static
    libibverbs1 -devel -static
    librdmacm1 -devel -static
    rdma-utils (all the other random binaries and stuff)
    ibverbs-plugins (all the providers)

   So we would get rid of the individual packages for the providers.
   There would be no -devel for the providers and the static providers
   would be bundled with libibverbs1-static

   IMHO this is more inline with common distro practice for packaging
   plugins. (most providers are about 20k-30k)

   I don't want to dictate what distros should do, but this is best
   done with support from the build system upstream, so some guidance
   on what to do is needed to finish the cmake stuff. (see #6)
5) Valgrind - I've noticed CentOS forces valgrind on, and Debian
   leaves it as the upstream default (off)
   IMHO Upstream should shift to use valgrind by default if available
   and encourage all downstreams to compile it with valgrind headers
   present.
6) Actually splitting the file list. cmake has a INSTALL COMPONENT
   facility to help with this, but it needs to be setup upstream.
   Other than the include files and man pages this is straightforward
   to do from the spec file
7) NDEBUG - As upstream do we want this set or left unset for a
   release build. It eliminates all asserts and a few other things.
   I'm not sure what is being done today, but the %cmake rpmbuild
   default forces it on. (IMHO, upstream should decide this, not
   downstream?)
8) COPYING file and other doc stuff. There are 4 different licenses
   being used in the source. Everything is GPLv2 however. I think this
   only impacts the providers.
9) libtool .la files. I preserved them, but if distros don't want them
   I'd love to ditch them.

I'd like to get thing in a state where it is not painful for the
distros to transition - to ease things along.

My approach has been to faithfully preserve exactly what we do today,
and the list above is basicly my list of things that seem like they
need attention.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
