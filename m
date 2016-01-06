From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] Start to add qp support to rdmavt and other verbs
Date: Wed, 06 Jan 2016 10:14:55 -0800
Message-ID: <20160106181226.3238.98769.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch continues adding the support for queue pairs in rdmavt. It also adds
the create queue pair, user context alloc, dealloc, and query device verbs.

This patchset builds on the "Begin to use rdmavt for qib" patchset.

---

Dennis Dalessandro (3):
      IB/rdmavt: Add R and S flags for queue pairs
      IB/rdmavt: Add create queue pair functionality
      IB/rdmavt: Export reset_qp in rdmavt

Harish Chegondi (3):
      IB/rdmavt: Add IB user context allocation and de-alloction functions
      IB/rdmavt: Allow reserving just one qpn
      IB/rdmavt: Add support for rvt_query_device function


 drivers/infiniband/sw/rdmavt/qp.c |  430 +++++++++++++++++++++++++++++++++++--
 drivers/infiniband/sw/rdmavt/vt.c |   30 ++-
 include/rdma/rdma_vt.h            |   18 +-
 include/rdma/rdmavt_qp.h          |   81 +++++++
 4 files changed, 529 insertions(+), 30 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
