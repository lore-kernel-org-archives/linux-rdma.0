From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 6/7] IB/hfi1: Consolidate IOCTL defines
Date: Thu, 14 Apr 2016 08:42:11 -0700
Message-ID: <20160414154210.6387.63374.stgit@scvm10.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

Consolidate all the IOCTL defines which are supported by the driver into
a common location. This header file is made available to user space and
will now allow user applications to determine IOCTL numbers directly.

Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/staging/rdma/hfi1/common.h |    3 --
 drivers/staging/rdma/hfi1/diag.c   |   50 +-------------------------------
 include/uapi/rdma/hfi/hfi1_user.h  |   56 +++++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index 37ac229..b729445 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -350,9 +350,6 @@ struct hfi1_message_header {
 #define HFI1_BECN_MASK 1
 #define HFI1_BECN_SMASK BIT(HFI1_BECN_SHIFT)
 
-#define HFI1_PSM_IOC_BASE_SEQ 0x0
-#define HFI1_SNOOP_IOC_BASE_SEQ 0x80 /* leaves plenty of room for psm */
-
 static inline __u64 rhf_to_cpu(const __le32 *rbuf)
 {
 	return __le64_to_cpu(*((__le64 *)rbuf));
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 4cf6e8d..776ccee 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -64,6 +64,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <rdma/ib_smi.h>
+#include <rdma/hfi/hfi1_user.h>
 #include "hfi.h"
 #include "device.h"
 #include "common.h"
@@ -142,60 +143,11 @@ static const struct file_operations diagpkt_file_ops = {
 };
 
 /*
- * This is used for communication with user space for snoop extended IOCTLs
- */
-struct hfi1_link_info {
-	__be64 node_guid;
-	u8 port_mode;
-	u8 port_state;
-	u16 link_speed_active;
-	u16 link_width_active;
-	u16 vl15_init;
-	u8 port_number;
-	/*
-	 * Add padding to make this a full IB SMP payload. Note: changing the
-	 * size of this structure will make the IOCTLs created with _IOWR
-	 * change.
-	 * Be sure to run tests on all IOCTLs when making changes to this
-	 * structure.
-	 */
-	u8 res[47];
-};
-
-/*
  * This starts our ioctl sequence numbers *way* off from the ones
  * defined in ib_core.
  */
 #define SNOOP_CAPTURE_VERSION 0x1
 
-#define HFI1_SNOOP_IOC_MAGIC IB_IOCTL_MAGIC
-
-#define HFI1_SNOOP_IOCGETLINKSTATE \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ)
-#define HFI1_SNOOP_IOCSETLINKSTATE \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 1)
-#define HFI1_SNOOP_IOCCLEARQUEUE \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 2)
-#define HFI1_SNOOP_IOCCLEARFILTER \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 3)
-#define HFI1_SNOOP_IOCSETFILTER \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 4)
-#define HFI1_SNOOP_IOCGETVERSION \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 5)
-#define HFI1_SNOOP_IOCSET_OPTS \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 6)
-
-/*
- * These offsets +6/+7 could change, but these are already known and used
- * IOCTL numbers so don't change them without a good reason.
- */
-#define HFI1_SNOOP_IOCGETLINKSTATE_EXTRA \
-	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 6, \
-		struct hfi1_link_info)
-#define HFI1_SNOOP_IOCSETLINKSTATE_EXTRA \
-	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 7, \
-		struct hfi1_link_info)
-
 static int hfi1_snoop_open(struct inode *in, struct file *fp);
 static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
 			       size_t pkt_len, loff_t *off);
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 383d036..5503451 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -147,13 +147,11 @@
 #define HFI1_CMD_EP_READ_RANGE   76      /* read EPROM range */
 #define HFI1_CMD_EP_WRITE_RANGE  77      /* write EPROM range */
 
-/*
- * User IOCTLs can not go above 128 if they do then see common.h and change the
- * base for the snoop ioctl
- */
 #define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.txt */
 
 struct hfi1_cmd;
+#define HFI1_PSM_IOC_BASE_SEQ 0x0
+
 #define HFI1_IOCTL_ASSIGN_CTXT \
 	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_ASSIGN_CTXT, struct hfi1_user_info)
 #define HFI1_IOCTL_CTXT_INFO \
@@ -189,6 +187,56 @@ struct hfi1_cmd;
 #define HFI1_IOCTL_EP_WRITE_RANGE \
 	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_WRITE_RANGE, struct hfi1_cmd)
 
+#define HFI1_SNOOP_IOC_BASE_SEQ 0x80 /* leaves plenty of room for psm */
+#define HFI1_SNOOP_IOC_MAGIC IB_IOCTL_MAGIC
+
+#define HFI1_SNOOP_IOCGETLINKSTATE \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ)
+#define HFI1_SNOOP_IOCSETLINKSTATE \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 1)
+#define HFI1_SNOOP_IOCCLEARQUEUE \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 2)
+#define HFI1_SNOOP_IOCCLEARFILTER \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 3)
+#define HFI1_SNOOP_IOCSETFILTER \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 4)
+#define HFI1_SNOOP_IOCGETVERSION \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 5)
+#define HFI1_SNOOP_IOCSET_OPTS \
+	_IO(IB_IOCTL_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 6)
+
+/*
+ * This is used for communication with user space for snoop extended IOCTLs
+ */
+struct hfi1_link_info {
+	__be64 node_guid;
+	__u8 port_mode;
+	__u8 port_state;
+	__u16 link_speed_active;
+	__u16 link_width_active;
+	__u16 vl15_init;
+	__u8 port_number;
+	/*
+	 * Add padding to make this a full IB SMP payload. Note: changing the
+	 * size of this structure will make the IOCTLs created with _IOWR
+	 * change.
+	 * Be sure to run tests on all IOCTLs when making changes to this
+	 * structure.
+	 */
+	__u8 res[47];
+};
+
+/*
+ * These offsets +6/+7 could change, but these are already known and used
+ * IOCTL numbers so don't change them without a good reason.
+ */
+#define HFI1_SNOOP_IOCGETLINKSTATE_EXTRA \
+	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 6, \
+		struct hfi1_link_info)
+#define HFI1_SNOOP_IOCSETLINKSTATE_EXTRA \
+	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 7, \
+		struct hfi1_link_info)
+
 #define _HFI1_EVENT_FROZEN_BIT         0
 #define _HFI1_EVENT_LINKDOWN_BIT       1
 #define _HFI1_EVENT_LID_CHANGE_BIT     2

