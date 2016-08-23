From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 4/6] RDMA/core: Move HFI1 IOCTL declarations to common file
Date: Wed, 24 Aug 2016 00:31:45 +0300
Message-ID: <1471987907-6336-5-git-send-email-leon@kernel.org>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471987907-6336-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move HFI1 IOCTL declarations to rdma_user_ioctl.h file.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/hfi/hfi1_user.h   | 55 -------------------------------------
 include/uapi/rdma/rdma_user_ioctl.h | 54 ++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 55 deletions(-)

diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 8aa3867..8807f06 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -58,7 +58,6 @@
 
 #include <linux/types.h>
 #include <rdma/rdma_user_ioctl.h>
-#include <rdma/hfi/hfi1_ioctl.h>
 
 /*
  * This version number is given to the driver by the user code during
@@ -114,60 +113,6 @@
 #define HFI1_RCVHDR_ENTSIZE_16   (1UL << 1)
 #define HFI1_RCVDHR_ENTSIZE_32   (1UL << 2)
 
-/* User commands. */
-#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */
-#define HFI1_CMD_CTXT_INFO       2	/* find out what resources we got */
-#define HFI1_CMD_USER_INFO       3	/* set up userspace */
-#define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
-#define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
-#define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
-
-#define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
-#define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
-#define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
-#define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
-#define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
-#define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
-#define HFI1_CMD_GET_VERS	 14	/* get the version of the user cdev */
-
-/*
- * User IOCTLs can not go above 128 if they do then see common.h and change the
- * base for the snoop ioctl
- */
-
-/*
- * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
- */
-#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)
-
-struct hfi1_cmd;
-#define HFI1_IOCTL_ASSIGN_CTXT \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
-#define HFI1_IOCTL_CTXT_INFO \
-	_IOW(IB_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
-#define HFI1_IOCTL_USER_INFO \
-	_IOW(IB_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
-#define HFI1_IOCTL_TID_UPDATE \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
-#define HFI1_IOCTL_TID_FREE \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
-#define HFI1_IOCTL_CREDIT_UPD \
-	_IO(IB_IOCTL_MAGIC, __NUM(CREDIT_UPD))
-#define HFI1_IOCTL_RECV_CTRL \
-	_IOW(IB_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
-#define HFI1_IOCTL_POLL_TYPE \
-	_IOW(IB_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
-#define HFI1_IOCTL_ACK_EVENT \
-	_IOW(IB_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
-#define HFI1_IOCTL_SET_PKEY \
-	_IOW(IB_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
-#define HFI1_IOCTL_CTXT_RESET \
-	_IO(IB_IOCTL_MAGIC, __NUM(CTXT_RESET))
-#define HFI1_IOCTL_TID_INVAL_READ \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
-#define HFI1_IOCTL_GET_VERS \
-	_IOR(IB_IOCTL_MAGIC, __NUM(GET_VERS), int)
-
 #define _HFI1_EVENT_FROZEN_BIT         0
 #define _HFI1_EVENT_LINKDOWN_BIT       1
 #define _HFI1_EVENT_LID_CHANGE_BIT     2
diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index 820bf34..e9a69f0 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -36,6 +36,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <rdma/ib_user_mad.h>
+#include <rdma/hfi/hfi1_ioctl.h>
 
 /* Documentation/ioctl/ioctl-number.txt */
 #define RDMA_IOCTL_MAGIC		0x1b
@@ -51,4 +52,57 @@
 #define IB_USER_MAD_REGISTER_AGENT2     _IOWR(IB_IOCTL_MAGIC, 4, \
 					      struct ib_user_mad_reg_req2)
 
+/* User commands. */
+#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */
+#define HFI1_CMD_CTXT_INFO       2	/* find out what resources we got */
+#define HFI1_CMD_USER_INFO       3	/* set up userspace */
+#define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
+#define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
+#define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
+
+#define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
+#define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
+#define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
+#define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
+#define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
+#define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
+#define HFI1_CMD_GET_VERS	 14	/* get the version of the user cdev */
+
+/*
+ * User IOCTLs can not go above 128 if they do then see common.h and change the
+ * base for the snoop ioctl
+ */
+
+/*
+ * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
+ */
+#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)
+
+#define HFI1_IOCTL_ASSIGN_CTXT \
+	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
+#define HFI1_IOCTL_CTXT_INFO \
+	_IOW(IB_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
+#define HFI1_IOCTL_USER_INFO \
+	_IOW(IB_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
+#define HFI1_IOCTL_TID_UPDATE \
+	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
+#define HFI1_IOCTL_TID_FREE \
+	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
+#define HFI1_IOCTL_CREDIT_UPD \
+	_IO(IB_IOCTL_MAGIC, __NUM(CREDIT_UPD))
+#define HFI1_IOCTL_RECV_CTRL \
+	_IOW(IB_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
+#define HFI1_IOCTL_POLL_TYPE \
+	_IOW(IB_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
+#define HFI1_IOCTL_ACK_EVENT \
+	_IOW(IB_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
+#define HFI1_IOCTL_SET_PKEY \
+	_IOW(IB_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
+#define HFI1_IOCTL_CTXT_RESET \
+	_IO(IB_IOCTL_MAGIC, __NUM(CTXT_RESET))
+#define HFI1_IOCTL_TID_INVAL_READ \
+	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
+#define HFI1_IOCTL_GET_VERS \
+	_IOR(IB_IOCTL_MAGIC, __NUM(GET_VERS), int)
+
 #endif /* RDMA_USER_IOCTL_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
