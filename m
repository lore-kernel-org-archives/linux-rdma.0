From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: ratelimit PFNs busy info message
Date: Fri, 04 Aug 2017 14:55:06 -0400
Message-ID: <1501872906.79618.10.camel@redhat.com>
References: <499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins@redhat.com>
         <20170802141720.228502368b534f517e3107ff@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170802141720.228502368b534f517e3107ff-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-02 at 14:17 -0700, Andrew Morton wrote:
> On Wed,  2 Aug 2017 13:44:57 -0400 Jonathan Toppins <jtoppins@redhat.
> com> wrote:
> 
> > The RDMA subsystem can generate several thousand of these messages
> > per
> > second eventually leading to a kernel crash. Ratelimit these
> > messages
> > to prevent this crash.
> 
> Well...  why are all these EBUSY's occurring?  It sounds inefficient
> (at
> least) but if it is expected, normal and unavoidable then perhaps we
> should just remove that message altogether?

I don't have an answer to that question.  To be honest, I haven't
looked real hard.  We never had this at all, then it started out of the
blue, but only on our Dell 730xd machines (and it hits all of them),
but no other classes or brands of machines.  And we have our 730xd
machines loaded up with different brands and models of cards (for
instance one dedicated to mlx4 hardware, one for qib, one for mlx5, an
ocrdma/cxgb4 combo, etc), so the fact that it hit all of the machines
meant it wasn't tied to any particular brand/model of RDMA hardware. 
To me, it always smelled of a hardware oddity specific to maybe the
CPUs or mainboard chipsets in these machines, so given that I'm not an
mm expert anyway, I never chased it down.

A few other relevant details: it showed up somewhere around 4.8/4.9 or
thereabouts.  It never happened before, but the prinkt has been there
since the 3.18 days, so possibly the test to trigger this message was
changed, or something else in the allocator changed such that the
situation started happening on these machines?

And, like I said, it is specific to our 730xd machines (but they are
all identical, so that could mean it's something like their specific
ram configuration is causing the allocator to hit this on these machine
but not on other machines in the cluster, I don't want to say it's
necessarily the model of chipset or CPU, there are other bits of
identicalness between these machines).

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
