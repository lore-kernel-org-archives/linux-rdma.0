From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Convert IBTA traps to OPA traps
Date: Thu, 10 Dec 2015 09:59:28 -0500
Message-ID: <20151210145904.22192.40996.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This two patch series gets rid of the vestigal use of IBTA
traps in the hfi1 driver.
---

Erik E. Kahn (1):
      staging/rdma/hfi1: HFI now sends OPA Traps instead of IBTA

Jubin John (1):
      staging/rdma/hfi1: add definitions for OPA traps


 drivers/staging/rdma/hfi1/mad.c   |  121 +++++++++++++++++++------------------
 drivers/staging/rdma/hfi1/mad.h   |  114 +++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/ruc.c   |   10 ++-
 drivers/staging/rdma/hfi1/ud.c    |   21 +++---
 drivers/staging/rdma/hfi1/verbs.h |    2 -
 5 files changed, 193 insertions(+), 75 deletions(-)

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
