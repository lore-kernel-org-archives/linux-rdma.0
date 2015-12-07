From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 28/37] IB/rdmavt: Add common LID defines to rdmavt
Date: Mon, 07 Dec 2015 15:45:01 -0500
Message-ID: <20151207204500.8144.46602.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Original patch is from Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>. It has
been split into separate patches.

This patch adds RVT_PERMISSIVE_LID and RVT_MULTICAST_LID_BASE
to rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_vt.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 2d2987b..546660b 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -58,6 +58,9 @@
 
 #include "ib_verbs.h"
 
+#define RVT_MULTICAST_LID_BASE 0xC000
+#define RVT_PERMISSIVE_LID 0xFFFF
+
 /*
  * For some of the IBTA objects there will likely be some
  * initializations required. We need flags to determine whether it is OK

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
