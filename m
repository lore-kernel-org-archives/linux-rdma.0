From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch v2 0/3] Fix GID lookup performance regression
Date: Tue, 24 Sep 2013 17:16:26 -0400
Message-ID: <cover.1380056994.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A performance issue was identified at a customer's site.  This issue resulted
in failures in their production environment.  It was eventually determined
that the excessive amount of time it took the IB stack to look up GIDs was
the primary culprit behind the problems observed.  This patch series resolves
the issue.  The first patch is the primary resolution and the one that we
can't live without, while the other two patches make incremental improvements
and could be skipped if need be (although I tend to think they make sense).

Roland, this was a showstopper for our customer.  As a mathematical experiment,
mlx4 hardware (dual port) has a 128 entry GID table, and without this patch,
if the GID you are looking for is on a second port, or God forbid a second
card, then the slowdown to search for the right GID is entirely unlivable.

Doug Ledford (3):
  IB/cma: use cached gids
  IB/cma: Check for GID on listening device first
  IB/cache: don't fill the cache with junk

 drivers/infiniband/core/cache.c | 132 +++++++++++++++++++++++++++++++---------
 drivers/infiniband/core/cma.c   |  65 ++++++++++----------
 2 files changed, 136 insertions(+), 61 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
