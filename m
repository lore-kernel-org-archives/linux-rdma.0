From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: ocrdma merged to my next branch
Date: Tue, 24 Apr 2012 16:49:41 -0700
Message-ID: <1335311385-11381-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

So I pulled in the Emulex ocrdma driver with the intention of merging
for 3.5.  I took the chance to add a few simple patches that fix minor
problems with the driver; please let me know if you see any problems
with any of the changes I made.

By the way, the way that the driver endian swaps structures in place
makes it nearly impossible to use sparse for endian checking; it would
probably be better to use leXX_to_cpu / cpu_to_leXX accessors
explicitly and then have a chance of the driver working on big-endian.

Roland Dreier (4):
  RDMA/ocrdma: Fix warnings about uninitialized variables
  RDMA/ocrdma: Make needlessly global functions/structs static
  RDMA/ocrdma: Set event's device member in ocrdma_dispatch_ibevent()
  RDMA/ocrdma: Remove write-only variables

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   24 ++++++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    6 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   11 +++--------
 3 files changed, 18 insertions(+), 23 deletions(-)

-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
