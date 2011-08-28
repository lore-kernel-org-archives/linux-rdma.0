From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] RDMA/cm: Fix sparse warning about cm_class
Date: Sun, 28 Aug 2011 14:34:42 +0200
Message-ID: <201108281434.43040.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix a sparse warning about a missing declaration for the symbol cm_class in
source file drivers/infiniband/core/ucm.c.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

---
 drivers/infiniband/core/ucm.c |    3 ---
 include/rdma/ib_cm.h          |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 08f948d..4dc2ef7 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -106,9 +106,6 @@ enum {
 	IB_UCM_MAX_DEVICES = 32
 };
 
-/* ib_cm and ib_user_cm modules share /sys/class/infiniband_cm */
-extern struct class cm_class;
-
 #define IB_UCM_BASE_DEV MKDEV(IB_UCM_MAJOR, IB_UCM_BASE_MINOR)
 
 static void ib_ucm_add_one(struct ib_device *device);
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index c8f94e8..1f2be6c 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -291,6 +291,9 @@ struct ib_cm_id {
 	u32			remote_cm_qpn;  /* 1 unless redirected */
 };
 
+/* ib_cm and ib_user_cm modules share /sys/class/infiniband_cm */
+extern struct class cm_class;
+
 /**
  * ib_create_cm_id - Allocate a communication identifier.
  * @device: Device associated with the cm_id.  All related communication will
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
