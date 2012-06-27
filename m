From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] qib MR fixes
Date: Wed, 27 Jun 2012 18:32:57 -0400
Message-ID: <20120627223257.12508.1491.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series implements there fixes for:
1) an MR refcount leak in handling UC RDMA WRITE with immediate data
2) an EBUSY when MR refcounts are held by RDMA READ RESPONSES
3) elimination of a per-HCA spin lock when validating MR keys

---

Mike Marciniszyn (3):
      IB/qib: fix UC MR refs for immediate operations
      IB/qib: Avoid returning EBUSY from MR deregister
      IB/qib: RCU locking for MR validation


 drivers/infiniband/hw/qib/qib_keys.c  |  148 +++++++++++---------
 drivers/infiniband/hw/qib/qib_mr.c    |  247 +++++++++++++++++++--------------
 drivers/infiniband/hw/qib/qib_qp.c    |   21 +--
 drivers/infiniband/hw/qib/qib_rc.c    |   24 +--
 drivers/infiniband/hw/qib/qib_ruc.c   |   14 +-
 drivers/infiniband/hw/qib/qib_uc.c    |   31 +---
 drivers/infiniband/hw/qib/qib_ud.c    |   12 --
 drivers/infiniband/hw/qib/qib_verbs.c |   14 +-
 drivers/infiniband/hw/qib/qib_verbs.h |   31 ++++
 9 files changed, 292 insertions(+), 250 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
