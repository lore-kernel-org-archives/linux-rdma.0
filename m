From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 26 Mar 2017 09:50:39 -0400
Message-ID: <1490536239.2404.80.camel@redhat.com>
References: <1490466578.2404.55.camel@redhat.com>
         <CA+55aFx+p+grY-vLzHOmj4VFKvni3eHUmO_hn+AzmHXw2MeUZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFx+p+grY-vLzHOmj4VFKvni3eHUmO_hn+AzmHXw2MeUZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-03-25 at 15:45 -0700, Linus Torvalds wrote:
> On Sat, Mar 25, 2017 at 11:29 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > 
> > This has been a slow -rc cycle for the RDMA subsystem.  We really
> > haven't had a lot of rc fixes come in.  This pull request is the
> > first
> > of this entire rc cycle and it has all of the suitable fixes so far
> > and
> > it's still only about 20 patches.  The fix for the minor breakage
> > cause
> > by the dma mapping patchset is in here, as well as a couple other
> > potential oops fixes, but the rest is more minor.
> 
> I am getting *very* irritated with the rdma pull requests.
> 
> I'm looking at your commits, and they have all been done on a Friday
> evening between 4pm and 11pm (with the bulk being after 9pm).
> 
> So what the hell happened in the rdma subsystem the rest of the week?

I checked out these machines in our RDMA cluster:

rdma-dev-17.lab.bos.redhat.com - Intel KnightsLanding F with OPA
dledford	HTTP	2017-03-22 10:34:04 -04:00	Distro
Tree	Provision		Fedora-26-20170320.n.0 Everything
x86_64

rdma-dev-19.lab.bos.redhat.com - ConnectX-4 IB/RoCE (using LACP LAG)
dledford	HTTP	2017-03-22 10:34:28 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-dev-20.lab.bos.redhat.com - ConnectX-4 IB/RoCE (using LACP LAG)
dledford	HTTP	2017-03-22 10:34:45 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-dev-22.lab.bos.redhat.com - ConnectX-4 IB/RoCE (100Gig on both)
dledford	HTTP	2017-03-22 10:35:07 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-perf-01.lab.bos.redhat.com - ConnectX-3 IB/RoCE (56Gig on both)
dledford	HTTP	2017-03-22 10:35:23 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-virt-00.lab.bos.redhat.com - ConnectX-3 Pro (IB/RoCE) (56Gig)
dledford	HTTP	2017-03-22 10:35:45 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-dev-12.lab.bos.redhat.com - cxgb4 (iWARP) (40Gig)
dledford	HTTP	2017-03-22 10:45:19 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-dev-06.lab.bos.redhat.com - qib (IB) (40Gig)
dledford	HTTP	2017-03-22 10:44:35 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

rdma-dev-04.lab.bos.redhat.com - mthca (IB) (20Gig)
dledford	HTTP	2017-03-22 10:36:42 -04:00	Distro
Tree	Provision		Fedora-Rawhide-20170321.n.0
Everything x86_64

This gave me direct testing of OPA/hfi1, iWARP/cxgb4,
IB/mthca;mlx4;mlx5;qib, and RoCE/mlx5;mlx4.  The ocrdma and bnxt_re
RoCE machines were checked out by other people, so I skipped those.  I
then did my work on the cluster itself.  I brought in all the patches I
sent you, plus an additional 15 patches that I needed to test so I
could give an Acked-by/Tested-by to them.  I then spent my time testing
them in the cluster.  When I was satisfied, I pulled them again, one at
a time, from patchworks, applied them to my normal work tree on my
workstation, emailed the mailing list, then marked the patch approved
in patchworks.  I do those four things in sequence every time now (get
from patchworks, apply, email reply, marked approved in patchworks).
 It's how I keep patchworks and my mailing list email in sync and if I
don't follow this pattern, I have lost a patch or two in the past.  For
the for-next area, where I'm going to commit the code and if it's wrong
do a revert, the dates will be more representative of when I'm doing
the work.  When I'm building and testing a bunch of -rc fixes like
this, I'm more likely to do an initial pull in the cluster, test it and
make sure I'm happy with all of the patches, then basically do it all
over again with a list of known good patches when I'm satisfied with my
testing.

> That's just *odd*. Why am I getting a pull request on a Saturday with
> stuff that was done late Friday night?

Because I leave for an RDMA conference on Monday morning, so I needed
to get it in.  It wasn't rushed in the sense you are thinking, but I am
running out of time before I leave and I did want to get it in.

> Can you understand why it feels very hurried to me, and why I get a
> feeling that you're timing your work and your pull requests for the
> rc
> releases on a Sunday?

I absolutely *was* trying to beat your sunday -rc tag, because I want
groups that aren't going to be at this conference (such as the Mellanox
QE team that tests upstream kernels) to have something to test against
while the rest of us are there.  They tend to pull -rc tags and go from
there.

> What testing did this branch get during the week? Several patches
> have
> dates from a month ago, but regardless they all show this pattern of
> looking like they were hurriedly committed the night before being
> sent
> off..
> 
> It just fails the smell test.  What's going on here?

I pulled and tested them in the Red Hat cluster this week, and when I
was satisfied with the overall set of patches, pulled those that were
actually mine to submit and not part of the PCI pool changes and built
a branch and submitted that branch to you.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
