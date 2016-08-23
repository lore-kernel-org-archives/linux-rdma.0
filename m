From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 5/6] RDMA/core: Rename RDMA magic number
Date: Wed, 24 Aug 2016 00:31:46 +0300
Message-ID: <1471987907-6336-6-git-send-email-leon@kernel.org>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471987907-6336-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Rename RDMA magic number to better describe IOCTLs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/rdma_user_ioctl.h | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index e9a69f0..7ecf8cd 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -40,16 +40,17 @@
 
 /* Documentation/ioctl/ioctl-number.txt */
 #define RDMA_IOCTL_MAGIC		0x1b
+/* Legacy name, for user space application which already use it */
 #define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
 
-#define IB_USER_MAD_REGISTER_AGENT	_IOWR(IB_IOCTL_MAGIC, 1, \
+#define IB_USER_MAD_REGISTER_AGENT	_IOWR(RDMA_IOCTL_MAGIC, 1, \
 					      struct ib_user_mad_reg_req)
 
-#define IB_USER_MAD_UNREGISTER_AGENT	_IOW(IB_IOCTL_MAGIC, 2, __u32)
+#define IB_USER_MAD_UNREGISTER_AGENT	_IOW(RDMA_IOCTL_MAGIC, 2, __u32)
 
-#define IB_USER_MAD_ENABLE_PKEY		_IO(IB_IOCTL_MAGIC, 3)
+#define IB_USER_MAD_ENABLE_PKEY		_IO(RDMA_IOCTL_MAGIC, 3)
 
-#define IB_USER_MAD_REGISTER_AGENT2     _IOWR(IB_IOCTL_MAGIC, 4, \
+#define IB_USER_MAD_REGISTER_AGENT2     _IOWR(RDMA_IOCTL_MAGIC, 4, \
 					      struct ib_user_mad_reg_req2)
 
 /* User commands. */
@@ -79,30 +80,30 @@
 #define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)
 
 #define HFI1_IOCTL_ASSIGN_CTXT \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
+	_IOWR(RDMA_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
 #define HFI1_IOCTL_CTXT_INFO \
-	_IOW(IB_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
+	_IOW(RDMA_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
 #define HFI1_IOCTL_USER_INFO \
-	_IOW(IB_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
+	_IOW(RDMA_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
 #define HFI1_IOCTL_TID_UPDATE \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
+	_IOWR(RDMA_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
 #define HFI1_IOCTL_TID_FREE \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
+	_IOWR(RDMA_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
 #define HFI1_IOCTL_CREDIT_UPD \
-	_IO(IB_IOCTL_MAGIC, __NUM(CREDIT_UPD))
+	_IO(RDMA_IOCTL_MAGIC, __NUM(CREDIT_UPD))
 #define HFI1_IOCTL_RECV_CTRL \
-	_IOW(IB_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
+	_IOW(RDMA_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
 #define HFI1_IOCTL_POLL_TYPE \
-	_IOW(IB_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
+	_IOW(RDMA_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
 #define HFI1_IOCTL_ACK_EVENT \
-	_IOW(IB_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
+	_IOW(RDMA_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
 #define HFI1_IOCTL_SET_PKEY \
-	_IOW(IB_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
+	_IOW(RDMA_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
 #define HFI1_IOCTL_CTXT_RESET \
-	_IO(IB_IOCTL_MAGIC, __NUM(CTXT_RESET))
+	_IO(RDMA_IOCTL_MAGIC, __NUM(CTXT_RESET))
 #define HFI1_IOCTL_TID_INVAL_READ \
-	_IOWR(IB_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
+	_IOWR(RDMA_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
 #define HFI1_IOCTL_GET_VERS \
-	_IOR(IB_IOCTL_MAGIC, __NUM(GET_VERS), int)
+	_IOR(RDMA_IOCTL_MAGIC, __NUM(GET_VERS), int)
 
 #endif /* RDMA_USER_IOCTL_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
