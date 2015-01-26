From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 16/19] IB/mad: Add Intel Omni-Path Architecture defines
Date: Mon, 26 Jan 2015 14:07:49 -0500
Message-ID: <1422299272-15898-17-git-send-email-ira.weiny@intel.com>
References: <1422299272-15898-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422299272-15898-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA_SMP_CLASS_VERSION -- Defined at 0x80
OPA_MGMT_BASE_VERSION -- Defined at 0x80

Increase max management version to accommodate OPA

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes since V2:
	Remove OPA_MIN_CLASS_VERSION

 drivers/infiniband/core/mad_priv.h | 2 +-
 include/rdma/ib_mad.h              | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index d71ddcc..10df80d 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -56,7 +56,7 @@
 
 /* Registration table sizes */
 #define MAX_MGMT_CLASS		80
-#define MAX_MGMT_VERSION	8
+#define MAX_MGMT_VERSION	0x83
 #define MAX_MGMT_OUI		8
 #define MAX_MGMT_VENDOR_RANGE2	(IB_MGMT_CLASS_VENDOR_RANGE2_END - \
 				IB_MGMT_CLASS_VENDOR_RANGE2_START + 1)
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
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
