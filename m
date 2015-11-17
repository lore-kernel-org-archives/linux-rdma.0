From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 13/13] staging/rdma/hfi1: Adjust EPROM partitions, add EPROM commands
Date: Mon, 16 Nov 2015 21:59:35 -0500
Message-ID: <1447729175-28745-14-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a new EPROM partition, adjusting partition placement.

Add EPROM range commands as a supserset of the partition
commands.  Remove old partition commands.

Enhance EPROM erase, creating a range function and using the
largest erase (sub) commands when possible.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/eprom.c    |  119 +++++++++++++++++++---------------
 drivers/staging/rdma/hfi1/file_ops.c |   18 ++----
 include/uapi/rdma/hfi/hfi1_user.h    |   10 +--
 3 files changed, 77 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index b61d3ae..fb620c9 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -53,17 +53,26 @@
 #include "eprom.h"
 
 /*
- * The EPROM is logically divided into two partitions:
+ * The EPROM is logically divided into three partitions:
  *	partition 0: the first 128K, visible from PCI ROM BAR
- *	partition 1: the rest
+ *	partition 1: 4K config file (sector size)
+ *	partition 2: the rest
  */
 #define P0_SIZE (128 * 1024)
+#define P1_SIZE   (4 * 1024)
 #define P1_START P0_SIZE
+#define P2_START (P0_SIZE + P1_SIZE)
+
+/* erase sizes supported by the controller */
+#define SIZE_4KB (4 * 1024)
+#define MASK_4KB (SIZE_4KB - 1)
 
-/* largest erase size supported by the controller */
 #define SIZE_32KB (32 * 1024)
 #define MASK_32KB (SIZE_32KB - 1)
 
+#define SIZE_64KB (64 * 1024)
+#define MASK_64KB (SIZE_64KB - 1)
+
 /* controller page size, in bytes */
 #define EP_PAGE_SIZE 256
 #define EEP_PAGE_MASK (EP_PAGE_SIZE - 1)
@@ -75,10 +84,12 @@
 #define CMD_READ_DATA(addr)	    ((0x03 << CMD_SHIFT) | addr)
 #define CMD_READ_SR1		    ((0x05 << CMD_SHIFT))
 #define CMD_WRITE_ENABLE	    ((0x06 << CMD_SHIFT))
+#define CMD_SECTOR_ERASE_4KB(addr)  ((0x20 << CMD_SHIFT) | addr)
 #define CMD_SECTOR_ERASE_32KB(addr) ((0x52 << CMD_SHIFT) | addr)
 #define CMD_CHIP_ERASE		    ((0x60 << CMD_SHIFT))
 #define CMD_READ_MANUF_DEV_ID	    ((0x90 << CMD_SHIFT))
 #define CMD_RELEASE_POWERDOWN_NOID  ((0xab << CMD_SHIFT))
+#define CMD_SECTOR_ERASE_64KB(addr) ((0xd8 << CMD_SHIFT) | addr)
 
 /* controller interface speeds */
 #define EP_SPEED_FULL 0x2	/* full speed */
@@ -188,28 +199,43 @@ static int erase_chip(struct hfi1_devdata *dd)
 }
 
 /*
- * Erase a range using the 32KB erase command.
+ * Erase a range.
  */
-static int erase_32kb_range(struct hfi1_devdata *dd, u32 start, u32 end)
+static int erase_range(struct hfi1_devdata *dd, u32 start, u32 len)
 {
+	u32 end = start + len;
 	int ret = 0;
 
 	if (end < start)
 		return -EINVAL;
 
-	if ((start & MASK_32KB) || (end & MASK_32KB)) {
+	/* check the end points for the minimum erase */
+	if ((start & MASK_4KB) || (end & MASK_4KB)) {
 		dd_dev_err(dd,
-			"%s: non-aligned range (0x%x,0x%x) for a 32KB erase\n",
+			"%s: non-aligned range (0x%x,0x%x) for a 4KB erase\n",
 			__func__, start, end);
 		return -EINVAL;
 	}
 
 	write_enable(dd);
 
-	for (; start < end; start += SIZE_32KB) {
+	while (start < end) {
 		write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_WRITE_ENABLE);
-		write_csr(dd, ASIC_EEP_ADDR_CMD,
-						CMD_SECTOR_ERASE_32KB(start));
+		/* check in order of largest to smallest */
+		if (((start & MASK_64KB) == 0) && (start + SIZE_64KB <= end)) {
+			write_csr(dd, ASIC_EEP_ADDR_CMD,
+				  CMD_SECTOR_ERASE_64KB(start));
+			start += SIZE_64KB;
+		} else if (((start & MASK_32KB) == 0) &&
+			   (start + SIZE_32KB <= end)) {
+			write_csr(dd, ASIC_EEP_ADDR_CMD,
+				  CMD_SECTOR_ERASE_32KB(start));
+			start += SIZE_32KB;
+		} else {	/* 4KB will work */
+			write_csr(dd, ASIC_EEP_ADDR_CMD,
+				  CMD_SECTOR_ERASE_4KB(start));
+			start += SIZE_4KB;
+		}
 		ret = wait_for_not_busy(dd);
 		if (ret)
 			goto done;
@@ -309,6 +335,18 @@ done:
 	return ret;
 }
 
+/* convert an range composite to a length, in bytes */
+static inline u32 extract_rlen(u32 composite)
+{
+	return (composite & 0xffff) * EP_PAGE_SIZE;
+}
+
+/* convert an range composite to a start, in bytes */
+static inline u32 extract_rstart(u32 composite)
+{
+	return (composite >> 16) * EP_PAGE_SIZE;
+}
+
 /*
  * Perform the given operation on the EPROM.  Called from user space.  The
  * user credentials have already been checked.
@@ -319,6 +357,8 @@ int handle_eprom_command(const struct hfi1_cmd *cmd)
 {
 	struct hfi1_devdata *dd;
 	u32 dev_id;
+	u32 rlen;	/* range length */
+	u32 rstart;	/* range start */
 	int ret = 0;
 
 	/*
@@ -364,54 +404,29 @@ int handle_eprom_command(const struct hfi1_cmd *cmd)
 								sizeof(u32)))
 			ret = -EFAULT;
 		break;
+
 	case HFI1_CMD_EP_ERASE_CHIP:
 		ret = erase_chip(dd);
 		break;
-	case HFI1_CMD_EP_ERASE_P0:
-		if (cmd->len != P0_SIZE) {
-			ret = -ERANGE;
-			break;
-		}
-		ret = erase_32kb_range(dd, 0, cmd->len);
-		break;
-	case HFI1_CMD_EP_ERASE_P1:
-		/* check for overflow */
-		if (P1_START + cmd->len > ASIC_EEP_ADDR_CMD_EP_ADDR_MASK) {
-			ret = -ERANGE;
-			break;
-		}
-		ret = erase_32kb_range(dd, P1_START, P1_START + cmd->len);
-		break;
-	case HFI1_CMD_EP_READ_P0:
-		if (cmd->len != P0_SIZE) {
-			ret = -ERANGE;
-			break;
-		}
-		ret = read_length(dd, 0, cmd->len, cmd->addr);
-		break;
-	case HFI1_CMD_EP_READ_P1:
-		/* check for overflow */
-		if (P1_START + cmd->len > ASIC_EEP_ADDR_CMD_EP_ADDR_MASK) {
-			ret = -ERANGE;
-			break;
-		}
-		ret = read_length(dd, P1_START, cmd->len, cmd->addr);
+
+	case HFI1_CMD_EP_ERASE_RANGE:
+		rlen = extract_rlen(cmd->len);
+		rstart = extract_rstart(cmd->len);
+		ret = erase_range(dd, rstart, rlen);
 		break;
-	case HFI1_CMD_EP_WRITE_P0:
-		if (cmd->len > P0_SIZE) {
-			ret = -ERANGE;
-			break;
-		}
-		ret = write_length(dd, 0, cmd->len, cmd->addr);
+
+	case HFI1_CMD_EP_READ_RANGE:
+		rlen = extract_rlen(cmd->len);
+		rstart = extract_rstart(cmd->len);
+		ret = read_length(dd, rstart, rlen, cmd->addr);
 		break;
-	case HFI1_CMD_EP_WRITE_P1:
-		/* check for overflow */
-		if (P1_START + cmd->len > ASIC_EEP_ADDR_CMD_EP_ADDR_MASK) {
-			ret = -ERANGE;
-			break;
-		}
-		ret = write_length(dd, P1_START, cmd->len, cmd->addr);
+
+	case HFI1_CMD_EP_WRITE_RANGE:
+		rlen = extract_rlen(cmd->len);
+		rstart = extract_rstart(cmd->len);
+		ret = write_length(dd, rstart, rlen, cmd->addr);
 		break;
+
 	default:
 		dd_dev_err(dd, "%s: unexpected command %d\n",
 			__func__, cmd->type);
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 22037ce..874305f 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -234,12 +234,9 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		break;
 	case HFI1_CMD_EP_INFO:
 	case HFI1_CMD_EP_ERASE_CHIP:
-	case HFI1_CMD_EP_ERASE_P0:
-	case HFI1_CMD_EP_ERASE_P1:
-	case HFI1_CMD_EP_READ_P0:
-	case HFI1_CMD_EP_READ_P1:
-	case HFI1_CMD_EP_WRITE_P0:
-	case HFI1_CMD_EP_WRITE_P1:
+	case HFI1_CMD_EP_ERASE_RANGE:
+	case HFI1_CMD_EP_READ_RANGE:
+	case HFI1_CMD_EP_WRITE_RANGE:
 		uctxt_required = 0;	/* assigned user context not required */
 		must_be_root = 1;	/* validate user */
 		copy = 0;
@@ -393,12 +390,9 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 	}
 	case HFI1_CMD_EP_INFO:
 	case HFI1_CMD_EP_ERASE_CHIP:
-	case HFI1_CMD_EP_ERASE_P0:
-	case HFI1_CMD_EP_ERASE_P1:
-	case HFI1_CMD_EP_READ_P0:
-	case HFI1_CMD_EP_READ_P1:
-	case HFI1_CMD_EP_WRITE_P0:
-	case HFI1_CMD_EP_WRITE_P1:
+	case HFI1_CMD_EP_ERASE_RANGE:
+	case HFI1_CMD_EP_READ_RANGE:
+	case HFI1_CMD_EP_WRITE_RANGE:
 		ret = handle_eprom_command(&cmd);
 		break;
 	}
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index a2fc6cb..288694e 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -137,12 +137,10 @@
 /* separate EPROM commands from normal PSM commands */
 #define HFI1_CMD_EP_INFO         64      /* read EPROM device ID */
 #define HFI1_CMD_EP_ERASE_CHIP   65      /* erase whole EPROM */
-#define HFI1_CMD_EP_ERASE_P0     66      /* erase EPROM partition 0 */
-#define HFI1_CMD_EP_ERASE_P1     67      /* erase EPROM partition 1 */
-#define HFI1_CMD_EP_READ_P0      68      /* read EPROM partition 0 */
-#define HFI1_CMD_EP_READ_P1      69      /* read EPROM partition 1 */
-#define HFI1_CMD_EP_WRITE_P0     70      /* write EPROM partition 0 */
-#define HFI1_CMD_EP_WRITE_P1     71      /* write EPROM partition 1 */
+/* range 66-74 no longer used */
+#define HFI1_CMD_EP_ERASE_RANGE  75      /* erase EPROM range */
+#define HFI1_CMD_EP_READ_RANGE   76      /* read EPROM range */
+#define HFI1_CMD_EP_WRITE_RANGE  77      /* write EPROM range */
 
 #define _HFI1_EVENT_FROZEN_BIT         0
 #define _HFI1_EVENT_LINKDOWN_BIT       1
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
