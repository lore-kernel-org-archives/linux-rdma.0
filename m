From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
Date: Sun,  4 Sep 2016 14:30:35 +0300
Message-ID: <1472988635-31463-7-git-send-email-leon@kernel.org>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472988635-31463-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

MAD and HFI1 have different naming convention, this patch
simplifies and unifies their defines and names.

As part of cleanup, the HFI1 _NUM() macro and command indexes
were removed. It has a potential to break applications which use
these defines directly, while shouldn't.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 include/uapi/rdma/rdma_user_ioctl.h | 98 ++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 60 deletions(-)

diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index 7ecf8cd..9388125 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -39,71 +39,49 @@
 #include <rdma/hfi/hfi1_ioctl.h>

 /* Documentation/ioctl/ioctl-number.txt */
-#define RDMA_IOCTL_MAGIC		0x1b
+#define RDMA_IOCTL_MAGIC	0x1b
 /* Legacy name, for user space application which already use it */
-#define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
-
-#define IB_USER_MAD_REGISTER_AGENT	_IOWR(RDMA_IOCTL_MAGIC, 1, \
-					      struct ib_user_mad_reg_req)
-
-#define IB_USER_MAD_UNREGISTER_AGENT	_IOW(RDMA_IOCTL_MAGIC, 2, __u32)
-
-#define IB_USER_MAD_ENABLE_PKEY		_IO(RDMA_IOCTL_MAGIC, 3)
-
-#define IB_USER_MAD_REGISTER_AGENT2     _IOWR(RDMA_IOCTL_MAGIC, 4, \
-					      struct ib_user_mad_reg_req2)
-
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
+#define IB_IOCTL_MAGIC		RDMA_IOCTL_MAGIC

 /*
- * User IOCTLs can not go above 128 if they do then see common.h and change the
- * base for the snoop ioctl
+ * General blocks assignments
+ * It is closed on purpose do not expose it it user space
+ * #define MAD_CMD_BASE		0x00
+ * #define HFI1_CMD_BAS		0xE0
  */

-/*
- * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
- */
-#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)
+/* MAD specific section */
+#define IB_USER_MAD_REGISTER_AGENT	_IOWR(RDMA_IOCTL_MAGIC, 0x01, struct ib_user_mad_reg_req)
+#define IB_USER_MAD_UNREGISTER_AGENT	_IOW(RDMA_IOCTL_MAGIC,  0x02, __u32)
+#define IB_USER_MAD_ENABLE_PKEY		_IO(RDMA_IOCTL_MAGIC,   0x03)
+#define IB_USER_MAD_REGISTER_AGENT2	_IOWR(RDMA_IOCTL_MAGIC, 0x04, struct ib_user_mad_reg_req2)

-#define HFI1_IOCTL_ASSIGN_CTXT \
-	_IOWR(RDMA_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
-#define HFI1_IOCTL_CTXT_INFO \
-	_IOW(RDMA_IOCTL_MAGIC, __NUM(CTXT_INFO), struct hfi1_ctxt_info)
-#define HFI1_IOCTL_USER_INFO \
-	_IOW(RDMA_IOCTL_MAGIC, __NUM(USER_INFO), struct hfi1_base_info)
-#define HFI1_IOCTL_TID_UPDATE \
-	_IOWR(RDMA_IOCTL_MAGIC, __NUM(TID_UPDATE), struct hfi1_tid_info)
-#define HFI1_IOCTL_TID_FREE \
-	_IOWR(RDMA_IOCTL_MAGIC, __NUM(TID_FREE), struct hfi1_tid_info)
-#define HFI1_IOCTL_CREDIT_UPD \
-	_IO(RDMA_IOCTL_MAGIC, __NUM(CREDIT_UPD))
-#define HFI1_IOCTL_RECV_CTRL \
-	_IOW(RDMA_IOCTL_MAGIC, __NUM(RECV_CTRL), int)
-#define HFI1_IOCTL_POLL_TYPE \
-	_IOW(RDMA_IOCTL_MAGIC, __NUM(POLL_TYPE), int)
-#define HFI1_IOCTL_ACK_EVENT \
-	_IOW(RDMA_IOCTL_MAGIC, __NUM(ACK_EVENT), unsigned long)
-#define HFI1_IOCTL_SET_PKEY \
-	_IOW(RDMA_IOCTL_MAGIC, __NUM(SET_PKEY), __u16)
-#define HFI1_IOCTL_CTXT_RESET \
-	_IO(RDMA_IOCTL_MAGIC, __NUM(CTXT_RESET))
-#define HFI1_IOCTL_TID_INVAL_READ \
-	_IOWR(RDMA_IOCTL_MAGIC, __NUM(TID_INVAL_READ), struct hfi1_tid_info)
-#define HFI1_IOCTL_GET_VERS \
-	_IOR(RDMA_IOCTL_MAGIC, __NUM(GET_VERS), int)
+/* HFI specific section */
+/* allocate HFI and context */
+#define HFI1_IOCTL_ASSIGN_CTXT		_IOWR(RDMA_IOCTL_MAGIC, 0xE1, struct hfi1_user_info)
+/* find out what resources we got */
+#define HFI1_IOCTL_CTXT_INFO		_IOW(RDMA_IOCTL_MAGIC,  0xE2, struct hfi1_ctxt_info)
+/* set up userspace */
+#define HFI1_IOCTL_USER_INFO		_IOW(RDMA_IOCTL_MAGIC,  0xE3, struct hfi1_base_info)
+/* update expected TID entries */
+#define HFI1_IOCTL_TID_UPDATE		_IOWR(RDMA_IOCTL_MAGIC, 0xE4, struct hfi1_tid_info)
+/* free expected TID entries */
+#define HFI1_IOCTL_TID_FREE		_IOWR(RDMA_IOCTL_MAGIC, 0xE5, struct hfi1_tid_info)
+/* force an update of PIO credit */
+#define HFI1_IOCTL_CREDIT_UPD		_IO(RDMA_IOCTL_MAGIC,   0xE6)
+/* control receipt of packets */
+#define HFI1_IOCTL_RECV_CTRL		_IOW(RDMA_IOCTL_MAGIC,  0xE8, int)
+/* set the kind of polling we want */
+#define HFI1_IOCTL_POLL_TYPE		_IOW(RDMA_IOCTL_MAGIC,  0xE9, int)
+/* ack & clear user status bits */
+#define HFI1_IOCTL_ACK_EVENT		_IOW(RDMA_IOCTL_MAGIC,  0xEA, unsigned long)
+/* set context's pkey */
+#define HFI1_IOCTL_SET_PKEY		_IOW(RDMA_IOCTL_MAGIC,  0xEB, __u16)
+/* reset context's HW send context */
+#define HFI1_IOCTL_CTXT_RESET		_IO(RDMA_IOCTL_MAGIC,   0xEC)
+/* read TID cache invalidations */
+#define HFI1_IOCTL_TID_INVAL_READ	_IOWR(RDMA_IOCTL_MAGIC, 0xED, struct hfi1_tid_info)
+/* get the version of the user cdev */
+#define HFI1_IOCTL_GET_VERS		_IOR(RDMA_IOCTL_MAGIC,  0xEE, int)

 #endif /* RDMA_USER_IOCTL_H */
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
