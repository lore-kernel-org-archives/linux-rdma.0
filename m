From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] IB/qib: Finish adding core rdmavt verbs support
Date: Wed, 03 Feb 2016 14:19:51 -0800
Message-ID: <20160203221808.4030.95183.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add the rest of the rdmavt core verbs support in qib, this mostly entails
removing existing operations.

This patch series applies on the previously posted "IB/rdmavt: Finish
adding core verbs support" and can be seen in context at:
https://github.com/ddalessa/kernel/tree/for-4.6

---

Dennis Dalessandro (2):
      IB/qib: Clean up register_ib_device
      IB/qib: Support query gid in rdmavt

Harish Chegondi (4):
      IB/qib: Remove qib_lookup_qpn and use rvt_lookup_qpn instead
      IB/qib: Remove modify queue pair code
      IB/qib: Remove destroy queue pair code
      IB/qib: Remove modify_port and port_immutable functions

Jubin John (1):
      IB/qib: Remove srq functionality


 drivers/infiniband/hw/qib/Makefile     |    2 
 drivers/infiniband/hw/qib/qib.h        |   13 +
 drivers/infiniband/hw/qib/qib_common.h |    1 
 drivers/infiniband/hw/qib/qib_driver.c |   27 -
 drivers/infiniband/hw/qib/qib_mad.c    |    5 
 drivers/infiniband/hw/qib/qib_qp.c     |  636 +++-----------------------------
 drivers/infiniband/hw/qib/qib_rc.c     |   10 -
 drivers/infiniband/hw/qib/qib_ruc.c    |   17 +
 drivers/infiniband/hw/qib/qib_sdma.c   |    2 
 drivers/infiniband/hw/qib/qib_srq.c    |  380 -------------------
 drivers/infiniband/hw/qib/qib_uc.c     |   10 -
 drivers/infiniband/hw/qib/qib_ud.c     |   17 +
 drivers/infiniband/hw/qib/qib_verbs.c  |  213 ++---------
 drivers/infiniband/hw/qib/qib_verbs.h  |   51 ---
 14 files changed, 168 insertions(+), 1216 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_srq.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
