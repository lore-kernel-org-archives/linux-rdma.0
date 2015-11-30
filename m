From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Fix 4.4 IB merge window regressions
Date: Mon, 30 Nov 2015 09:34:15 -0500
Message-ID: <20151130143326.24060.35941.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This two patch series fixes regressions for qib and hfi1
introduced in the 4.4 merge window.

These are critical for 4.4 and for rebasing the qib/hfi1
refactoring.

---

Ira Weiny (1):
      IB/qib: Fix qib_mr structure

Mike Marciniszyn (1):
      IB/core: correct issue with sge copyin corrupting wr


 drivers/infiniband/core/uverbs_cmd.c  |   15 ++++++++++-----
 drivers/infiniband/hw/qib/qib_verbs.h |    2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
