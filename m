From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] ib_sg_dma changes
Date: Fri, 28 Mar 2014 12:35:34 -0400
Message-ID: <20140328163500.5773.35838.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series modified the ib_sg_dma API to
eliminate the .dma_len and .dma_address methods.

In all present cases that overload these methods
(ipath, qib, ehca), the lack of these methods are
compensated for by code changes to the driver .map_sg
to insure that the vanilla sg_dma_address() and
sg_dma_len() will do the same thing as the equivalent
former ib_sg_dma_address() and ib_sg_dma_len() calls
into the drivers.

This patch series is a followup to this recent submission
http://marc.info/?l=linux-rdma&m=139602422108727&w=2
and Bart's similar comment in
http://marc.info/?l=linux-netdev&m=135643746610259&w=2.

Roland, I'm not sure of the history of these methods and
what rationale caused them to be added?

There is obviously an interim step that could be done
here to preseve the overload by not changing verbs, yet
change qib/ipath/echa to not overload them.  This would
allow the drivers to work even when the "correct" API's
had not been used by the ULP.
---

Mike Marciniszyn (4):
      IB/core: Remove overload in ib_sg_dma*
      IB/qib: remove ib_sg_dma_address() and ib_sg_dma_len() overloads
      IB/ipath: remove ib_sg_dma_address() and ib_sg_dma_len() overloads
      IB/ehca: remove ib_sg_dma_address() and ib_sg_dma_len() overloads


 drivers/infiniband/hw/ehca/ehca_mrmw.c  |   12 ---------
 drivers/infiniband/hw/ipath/ipath_dma.c |   43 +++++++++++--------------------
 drivers/infiniband/hw/qib/qib_dma.c     |   21 +++------------
 include/rdma/ib_verbs.h                 |   14 ++++------
 4 files changed, 25 insertions(+), 65 deletions(-)

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
