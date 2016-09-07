From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: RFCv3: Consolidated userspace RDMA library repo
Date: Tue, 6 Sep 2016 22:09:25 -0600
Message-ID: <20160907040925.GA27361@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Everyone,

I've updated the repo, and I think we are now at the point to begin to
engage the distribution packagers and collect their feedback. As Doug
has suggested, there are many modifications that the distros have done
that could be folded back upstream.

It is available at:
  https://github.com/jgunthorpe/rdma-plumbing

Prior posts on this topic are still informative:
  http://www.spinics.net/lists/linux-rdma/msg39026.html
  http://www.spinics.net/lists/linux-rdma/msg39328.html
  http://www.spinics.net/lists/linux-rdma/msg40014.html

The patch series has several notable improvements since last time,
based on feedback:

- If valgrind headers are available they are used by default
- Static libraries are not built by default
- If libnl is not present cmake fails by default
- NDEBUG is on for Release builds but off for RelWithDebInfo (default)
  builds
- -fno-strict-aliasing is copied from upstream and applied minimally
- srptools and iwpmd are included
- Further build integration, removal of dead #ifdefs
- Warning free build on new compilers
- Start on stripping out the -abi.h mess
- Demo rpm spec file that runs on OpenSuSE 13.2/14.1/tumbleweed, FC24,
  CentOS6/7 and maybe others.

The big set piece of this update is to make the compile warning-free
with "-Wall -Wextra -Wno-sign-compare -Wno-unused-parameter" on gcc
and clang.

This is a fairly high warning level and actually found some very
intersting things, my earlier patch series encompasses this stuff.

One area that needs some feedback is how far back should we bother to
support warning-free compile with gcc. Currently only gcc 6.1and clang
3.8 are warning free.

This is mainly to do with -Wmaybe-uninitialized on older compilers
that lack the static analysis that gcc now has.  I know Linus has
in-the-past come out against uninitialized_var,
(https://lkml.org/lkml/2012/10/26/508) and indeed gcc 6.1 noticed one
probable-bug in mlx5 being suppressed by using this inappropriately.

Some options:
 - Have cmake set -Wno-maybe-uninitialized on old compiles and forget
   about it
 - Annotate in zero initializers in the few places, maybe with some
   kind of macro
 - Leave it as is, recommend developers use gcc 6.1 or clang 3.8

Since clang throws a hissy fit with the x=x construction I've deleted
it from the tree..

For this update I am going to not post patches again, the series is
now up to 57 commits and that is too many for the mailing list.

This next major step will be to track down the packagers in distros
and inform them of the plan to collect feedback.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
