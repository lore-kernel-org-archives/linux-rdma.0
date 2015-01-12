From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Mon, 12 Jan 2015 12:11:08 -0500
Message-ID: <1421082672-22588-17-git-send-email-ira.weiny@intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA_MIN_CLASS_VERSION -- OPA Class versions are > 0x80
OPA_SMP_CLASS_VERSION -- Defined at 0x80
OPA_MGMT_BASE_VERSION -- Defined at 0x80

Increase max management version to accommodate OPA

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad_priv.h |    4 +++-
 include/rdma/ib_mad.h              |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index d71ddcc..a7041b0 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -56,11 +56,13 @@
 
 /* Registration table sizes */
 #define MAX_MGMT_CLASS		80
-#define MAX_MGMT_VERSION	8
+#define MAX_MGMT_VERSION	0x83
 #define MAX_MGMT_OUI		8
 #define MAX_MGMT_VENDOR_RANGE2	(IB_MGMT_CLASS_VENDOR_RANGE2_END - \
 				IB_MGMT_CLASS_VENDOR_RANGE2_START + 1)
 
+#define OPA_MIN_CLASS_VERSION	0x80
+
 struct ib_mad_list_head {
 	struct list_head list;
 	struct ib_mad_queue *mad_queue;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 80e7cf4..8938f1e 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -42,8 +42,11 @@
 #include <rdma/ib_verbs.h>
 #include <uapi/rdma/ib_user_mad.h>
 
-/* Management base version */
+/* Management base versions */
 #define IB_MGMT_BASE_VERSION			1
+#define OPA_MGMT_BASE_VERSION			0x80
+
+#define OPA_SMP_CLASS_VERSION			0x80
 
 /* Management classes */
 #define IB_MGMT_CLASS_SUBN_LID_ROUTED		0x01
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
