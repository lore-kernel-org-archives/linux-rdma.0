From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.2 0/2] iser fixes for 3.2
Date: Fri, 4 Nov 2011 00:15:59 +0200
Message-ID: <alpine.LRH.2.00.1111040013260.9030@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

These are two fixes making iser better citizen w.r.t to honoring
the DMA mapping API

Or Gerlitz (2):
      ib/iser: use separate buffers for the login request/response
      ib/iser: issue dma unmapping on the tx bufs used for the iscsi/iser headers

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   11 ++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    4 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   31 ++++++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   33 ++++++++++++++++++++-----
 4 files changed, 60 insertions(+), 19 deletions(-)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
