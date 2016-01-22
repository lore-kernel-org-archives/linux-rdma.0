From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/7] Start to add qp support to rdmavt and other verbs
Date: Fri, 22 Jan 2016 12:49:57 -0800
Message-ID: <20160122204807.4351.24569.stgit@scvm10.sc.intel.com>
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

This patchset builds on the v4 "Begin to use rdmavt for qib" patchset.

Changes since v1:
Add patch "Support creating qps with GFP_NOIO flag"

---

Dennis Dalessandro (3):
      IB/rdmavt: Add R and S flags for queue pairs
      IB/rdmavt: Add create queue pair functionality
      IB/rdmavt: Export reset_qp in rdmavt

Harish Chegondi (3):
      IB/rdmavt: Add IB user context allocation and de-alloction functions
      IB/rdmavt: Allow reserving just one qpn
      IB/rdmavt: Add support for rvt_query_device function

Mike Marciniszyn (1):
      IB/rdmavt: Support creating qps with GFP_NOIO flag


 drivers/infiniband/sw/rdmavt/qp.c |  466 +++++++++++++++++++++++++++++++++++--
 drivers/infiniband/sw/rdmavt/vt.c |   30 ++
 include/rdma/rdma_vt.h            |   19 +-
 include/rdma/rdmavt_qp.h          |   81 ++++++
 4 files changed, 563 insertions(+), 33 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
