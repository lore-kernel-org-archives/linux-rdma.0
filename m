From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] Misc fixes for 3.17 rdma stack
Date: Tue, 12 Aug 2014 19:20:03 -0400
Message-ID: <cover.1407885084.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a collection of miscellaneous fixes that people have posted
previously for inclusion in the 3.17 kernel.  The one from Bart was
(apparently) skipped when you picked up the rest of the set.  I'm
requesting that you reconsider skipping this patch as the pkey cache
is a perfectly valid optimization to use and saves considerable time
on pkey lookups (my measurements were up to 5ms per lookup that goes
to the card instead of hitting the cache, so that's a 5ms of totally
unneeded latency).

I have three in here, one that I've posted before and two that are new.

The remainder are very much trivial patches, but they weren't in your
tree so I included them here.  These have all been built into my test
kernel for my next patch set, so they've at least been compile tested
by me, and they've also been reviewed and I've added my sign off.

Bart Van Assche (1):
  IB/srp: Use P_Key cache for P_Key lookups

Dan Carpenter (1):
  RDMA/amso1100: integer overflow in c2_alloc_cq_buf()

Doug Ledford (3):
  ib/srpt: Enhance printk output
  ib/srpt: Handle GID change events
  uapi/rdma_user_cm.h: include socket.h

Fabian Frederick (3):
  drivers/infiniband/ulp/ipoib/ipoib_fs.c: remove unnecessary null test
    before debugfs_remove
  IB/mlx4: use ARRAY_SIZE instead of sizeof/sizeof[0]
  IB/mlx5: use ARRAY_SIZE instead of sizeof/sizeof[0]

 drivers/infiniband/hw/amso1100/c2_cq.c  |   7 +-
 drivers/infiniband/hw/mlx4/main.c       |   6 +-
 drivers/infiniband/hw/mlx5/qp.c         |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c |   6 +-
 drivers/infiniband/ulp/srp/ib_srp.c     |   9 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   | 202 ++++++++++++++++----------------
 include/uapi/rdma/rdma_user_cm.h        |   1 +
 7 files changed, 118 insertions(+), 115 deletions(-)

-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
