From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 7/7] IB/hfi1: Move eprom to its own device
Date: Thu, 14 Apr 2016 08:42:17 -0700
Message-ID: <20160414154216.6387.9499.stgit@scvm10.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dean Luick <dean.luick@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

The eprom writing capability of the driver is currently residing in the
same handler for applications that wish to send/receive packets. This is
better suited as a diagnostic device with its own device file.

Create an eprom device file and add its own IOCTL handling.

Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c     |  107 ++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/eprom.c    |  121 ++--------------------------------
 drivers/staging/rdma/hfi1/eprom.h    |   16 ++++
 drivers/staging/rdma/hfi1/file_ops.c |   23 ------
 drivers/staging/rdma/hfi1/hfi.h      |    8 ++
 include/uapi/rdma/hfi/hfi1_user.h    |   21 +++---
 6 files changed, 146 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 776ccee..0947d29 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -70,6 +70,7 @@
 #include "common.h"
 #include "verbs_txreq.h"
 #include "trace.h"
+#include "eprom.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -157,6 +158,9 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 static unsigned int hfi1_snoop_poll(struct file *fp,
 				    struct poll_table_struct *wait);
 static int hfi1_snoop_release(struct inode *in, struct file *fp);
+static int hfi1_eprom_open(struct inode *in, struct file *fp);
+static long hfi1_eprom_ioctl(struct file *fp, unsigned int cmd,
+			     unsigned long arg);
 
 struct hfi1_packet_filter_command {
 	int opcode;
@@ -189,6 +193,12 @@ static const struct file_operations snoop_file_ops = {
 	.release = hfi1_snoop_release
 };
 
+static const struct file_operations eprom_file_ops = {
+	.owner = THIS_MODULE,
+	.open = hfi1_eprom_open,
+	.unlocked_ioctl = hfi1_eprom_ioctl
+};
+
 struct hfi1_filter_array {
 	int (*filter)(void *, void *, void *);
 };
@@ -236,6 +246,13 @@ int hfi1_diag_add(struct hfi1_devdata *dd)
 	if (ret)
 		dd_dev_err(dd, "Unable to init snoop/capture device");
 
+	snprintf(name, sizeof(name), "%s_eprom%d", class_name(),
+		 dd->unit);
+	ret = hfi1_cdev_init(HFI1_EPROM_BASE + dd->unit, name,
+			     &eprom_file_ops,
+			     &dd->hfi1_eprom.cdev, &dd->hfi1_eprom.class_dev,
+			     false);
+
 	snprintf(name, sizeof(name), "%s_diagpkt", class_name());
 	if (atomic_inc_return(&diagpkt_count) == 1) {
 		ret = hfi1_cdev_init(HFI1_DIAGPKT_MINOR, name,
@@ -275,6 +292,7 @@ void hfi1_diag_remove(struct hfi1_devdata *dd)
 	if (atomic_dec_and_test(&diagpkt_count))
 		hfi1_cdev_cleanup(&diagpkt_cdev, &diagpkt_device);
 	hfi1_cdev_cleanup(&dd->diag_cdev, &dd->diag_device);
+	hfi1_cdev_cleanup(&dd->hfi1_eprom.cdev, &dd->hfi1_eprom.class_dev);
 }
 
 /*
@@ -1868,3 +1886,92 @@ void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 inline_pio_out:
 	pio_copy(dd, pbuf, pbc, from, count);
 }
+
+static int hfi1_eprom_open(struct inode *in, struct file *fp)
+{
+	return 0;
+}
+
+static long hfi1_eprom_ioctl(struct file *fp, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct hfi1_devdata *dd = NULL;
+	int read_cmd, write_cmd, read_ok, write_ok;
+	struct hfi1_eprom_cmd ec;
+	u32 dev_id, rlen, rstart;
+	int ret;
+	int unit;
+
+	hfi1_cdbg(IOCTL, "IOCTL recv: 0x%x", cmd);
+
+	if (check_ioctl_access(cmd, arg))
+		return -EFAULT;
+
+	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
+	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
+	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
+	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
+
+	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
+		return -EFAULT;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* All commands need user struct except erase chip */
+	if (cmd != HFI1_IOCTL_EP_ERASE_CHIP) {
+		memset(&ec, 0, sizeof(ec));
+		if (copy_from_user(&ec, (struct hfi1_eprom_cmd __user *)arg,
+				   sizeof(ec)))
+			return -EFAULT;
+	}
+
+	unit = iminor(fp->f_inode) - HFI1_EPROM_BASE;
+	dd = hfi1_lookup(unit);
+	if (!dd)
+		return -ENODEV;
+
+	/* some devices do not have an EPROM */
+	if (!dd->eprom_available)
+		return -EOPNOTSUPP;
+
+	ret = acquire_chip_resource(dd, CR_EPROM, EPROM_TIMEOUT);
+	if (ret) {
+		dd_dev_err(dd, "%s: unable to acquire EPROM resource\n",
+			   __func__);
+		return ret;
+	}
+
+	switch (cmd) {
+	case HFI1_IOCTL_EP_INFO:
+		dev_id = hfi1_eprom_read_device_id(dd);
+		if (copy_to_user((void __user *)ec.addr, &dev_id,
+				 sizeof(dev_id)))
+			ret = -EFAULT;
+		break;
+	case HFI1_IOCTL_EP_ERASE_CHIP:
+		ret = hfi1_eprom_erase_chip(dd);
+		break;
+	case HFI1_IOCTL_EP_ERASE_RANGE:
+		rlen = ec.length;
+		rstart = ec.start;
+		ret = hfi1_eprom_erase_range(dd, rstart, rlen);
+		break;
+	case HFI1_IOCTL_EP_READ_RANGE:
+		rlen = ec.length;
+		rstart = ec.start;
+		ret = hfi1_eprom_read_length(dd, rstart, rlen, ec.addr);
+		break;
+	case HFI1_IOCTL_EP_WRITE_RANGE:
+		rlen = ec.length;
+		rstart = ec.start;
+		ret = hfi1_eprom_write_length(dd, rstart, rlen, ec.addr);
+		break;
+	default:
+		dd_dev_err(dd, "%s: unexpected command %d\n",
+			   __func__, cmd);
+		ret = -EINVAL;
+	}
+	release_chip_resource(dd, CR_EPROM);
+	return ret;
+}
diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index bd87715..73d7104 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -102,13 +102,6 @@
 #define EPROM_WP_N BIT_ULL(14)	/* EPROM write line */
 
 /*
- * How long to wait for the EPROM to become available, in ms.
- * The spec 32 Mb EPROM takes around 40s to erase then write.
- * Double it for safety.
- */
-#define EPROM_TIMEOUT 80000 /* ms */
-
-/*
  * Turn on external enable line that allows writing on the flash.
  */
 static void write_enable(struct hfi1_devdata *dd)
@@ -166,7 +159,7 @@ static int wait_for_not_busy(struct hfi1_devdata *dd)
 /*
  * Read the device ID from the SPI controller.
  */
-static u32 read_device_id(struct hfi1_devdata *dd)
+u32 hfi1_eprom_read_device_id(struct hfi1_devdata *dd)
 {
 	/* read the Manufacture Device ID */
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_MANUF_DEV_ID);
@@ -176,7 +169,7 @@ static u32 read_device_id(struct hfi1_devdata *dd)
 /*
  * Erase the whole flash.
  */
-static int erase_chip(struct hfi1_devdata *dd)
+int hfi1_eprom_erase_chip(struct hfi1_devdata *dd)
 {
 	int ret;
 
@@ -194,7 +187,7 @@ static int erase_chip(struct hfi1_devdata *dd)
 /*
  * Erase a range.
  */
-static int erase_range(struct hfi1_devdata *dd, u32 start, u32 len)
+int hfi1_eprom_erase_range(struct hfi1_devdata *dd, u32 start, u32 len)
 {
 	u32 end = start + len;
 	int ret = 0;
@@ -257,7 +250,8 @@ static void read_page(struct hfi1_devdata *dd, u32 offset, u32 *result)
 /*
  * Read length bytes starting at offset.  Copy to user address addr.
  */
-static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
+int hfi1_eprom_read_length(struct hfi1_devdata *dd, u32 start, u32 len,
+			   u64 addr)
 {
 	u32 offset;
 	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
@@ -300,7 +294,8 @@ static int write_page(struct hfi1_devdata *dd, u32 offset, u32 *data)
 /*
  * Write length bytes starting at offset.  Read from user address addr.
  */
-static int write_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
+int hfi1_eprom_write_length(struct hfi1_devdata *dd, u32 start, u32 len,
+			    u64 addr)
 {
 	u32 offset;
 	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
@@ -328,108 +323,6 @@ done:
 	return ret;
 }
 
-/* convert an range composite to a length, in bytes */
-static inline u32 extract_rlen(u32 composite)
-{
-	return (composite & 0xffff) * EP_PAGE_SIZE;
-}
-
-/* convert an range composite to a start, in bytes */
-static inline u32 extract_rstart(u32 composite)
-{
-	return (composite >> 16) * EP_PAGE_SIZE;
-}
-
-/*
- * Perform the given operation on the EPROM.  Called from user space.  The
- * user credentials have already been checked.
- *
- * Return 0 on success, -ERRNO on error
- */
-int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
-{
-	struct hfi1_devdata *dd;
-	u32 dev_id;
-	u32 rlen;	/* range length */
-	u32 rstart;	/* range start */
-	int i_minor;
-	int ret = 0;
-
-	/*
-	 * Map the device file to device data using the relative minor.
-	 * The device file minor number is the unit number + 1.  0 is
-	 * the generic device file - reject it.
-	 */
-	i_minor = iminor(file_inode(fp)) - HFI1_USER_MINOR_BASE;
-	if (i_minor <= 0)
-		return -EINVAL;
-	dd = hfi1_lookup(i_minor - 1);
-	if (!dd) {
-		pr_err("%s: cannot find unit %d!\n", __func__, i_minor);
-		return -EINVAL;
-	}
-
-	/* some devices do not have an EPROM */
-	if (!dd->eprom_available)
-		return -EOPNOTSUPP;
-
-	ret = acquire_chip_resource(dd, CR_EPROM, EPROM_TIMEOUT);
-	if (ret) {
-		dd_dev_err(dd, "%s: unable to acquire EPROM resource\n",
-			   __func__);
-		goto done_asic;
-	}
-
-	dd_dev_info(dd, "%s: cmd: type %d, len 0x%x, addr 0x%016llx\n",
-		    __func__, cmd->type, cmd->len, cmd->addr);
-
-	switch (cmd->type) {
-	case HFI1_CMD_EP_INFO:
-		if (cmd->len != sizeof(u32)) {
-			ret = -ERANGE;
-			break;
-		}
-		dev_id = read_device_id(dd);
-		/* addr points to a u32 user buffer */
-		if (copy_to_user((void __user *)cmd->addr, &dev_id,
-				 sizeof(u32)))
-			ret = -EFAULT;
-		break;
-
-	case HFI1_CMD_EP_ERASE_CHIP:
-		ret = erase_chip(dd);
-		break;
-
-	case HFI1_CMD_EP_ERASE_RANGE:
-		rlen = extract_rlen(cmd->len);
-		rstart = extract_rstart(cmd->len);
-		ret = erase_range(dd, rstart, rlen);
-		break;
-
-	case HFI1_CMD_EP_READ_RANGE:
-		rlen = extract_rlen(cmd->len);
-		rstart = extract_rstart(cmd->len);
-		ret = read_length(dd, rstart, rlen, cmd->addr);
-		break;
-
-	case HFI1_CMD_EP_WRITE_RANGE:
-		rlen = extract_rlen(cmd->len);
-		rstart = extract_rstart(cmd->len);
-		ret = write_length(dd, rstart, rlen, cmd->addr);
-		break;
-
-	default:
-		dd_dev_err(dd, "%s: unexpected command %d\n",
-			   __func__, cmd->type);
-		ret = -EINVAL;
-		break;
-	}
-
-	release_chip_resource(dd, CR_EPROM);
-done_asic:
-	return ret;
-}
-
 /*
  * Initialize the EPROM handler.
  */
diff --git a/drivers/staging/rdma/hfi1/eprom.h b/drivers/staging/rdma/hfi1/eprom.h
index d41f0b1..60c1e08 100644
--- a/drivers/staging/rdma/hfi1/eprom.h
+++ b/drivers/staging/rdma/hfi1/eprom.h
@@ -45,8 +45,20 @@
  *
  */
 
-struct hfi1_cmd;
+/*
+ * How long to wait for the EPROM to become available, in ms.
+ * The spec 32 Mb EPROM takes around 40s to erase then write.
+ * Double it for safety.
+ */
+#define EPROM_TIMEOUT 80000 /* ms */
+
 struct hfi1_devdata;
 
 int eprom_init(struct hfi1_devdata *dd);
-int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd);
+u32 hfi1_eprom_read_device_id(struct hfi1_devdata *dd);
+int hfi1_eprom_erase_chip(struct hfi1_devdata *dd);
+int hfi1_eprom_read_length(struct hfi1_devdata *dd, u32 start, u32 len,
+			   u64 addr);
+int hfi1_eprom_write_length(struct hfi1_devdata *dd, u32 start, u32 len,
+			    u64 addr);
+int hfi1_eprom_erase_range(struct hfi1_devdata *dd, u32 start, u32 len);
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 26f3d8f..752a927 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -181,8 +181,6 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_info uinfo;
 	struct hfi1_tid_info tinfo;
-	struct hfi1_cmd ucmd;
-	int uctxt_required = 1;
 	int ret = 0;
 	unsigned long addr;
 	int uval = 0;
@@ -195,28 +193,9 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 
 	hfi1_cdbg(IOCTL, "IOCTL recv: 0x%x", cmd);
 
-	switch (cmd) {
-	case HFI1_IOCTL_ASSIGN_CTXT:
-		uctxt_required = 0; /* assigned user context not required */
-		break;
-	case HFI1_IOCTL_EP_INFO:
-	case HFI1_IOCTL_EP_ERASE_CHIP:
-	case HFI1_IOCTL_EP_ERASE_RANGE:
-	case HFI1_IOCTL_EP_READ_RANGE:
-	case HFI1_IOCTL_EP_WRITE_RANGE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (copy_from_user(&ucmd,
-				   (struct hfi11_cmd __user *)arg,
-				   sizeof(ucmd)))
-			return -EFAULT;
-		return handle_eprom_command(fp, &ucmd);
-	}
-
-	if (uctxt_required && !uctxt)
+	if (cmd != HFI1_IOCTL_ASSIGN_CTXT && !uctxt)
 		return -EINVAL;
 
-	/* Checked for root/context process the IOCTL */
 	switch (cmd) {
 	case HFI1_IOCTL_ASSIGN_CTXT:
 		if (copy_from_user(&uinfo,
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 7351898..81b2028 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -387,6 +387,11 @@ struct hfi1_snoop_data {
 	u64 dcc_cfg; /* saved value of DCC Cfg register */
 };
 
+struct hfi1_eprom_data {
+	struct cdev cdev;
+	struct device *class_dev;
+};
+
 /* snoop mode_flag values */
 #define HFI1_PORT_SNOOP_MODE     1U
 #define HFI1_PORT_CAPTURE_MODE   2U
@@ -1098,6 +1103,7 @@ struct hfi1_devdata {
 	size_t portcntrnameslen;
 
 	struct hfi1_snoop_data hfi1_snoop;
+	struct hfi1_eprom_data hfi1_eprom;
 
 	struct err_info_rcvport err_info_rcvport;
 	struct err_info_constraint err_info_rcv_constraint;
@@ -1770,8 +1776,8 @@ extern struct mutex hfi1_mutex;
 #define HFI1_DIAGPKT_MINOR       128
 #define HFI1_DIAG_MINOR_BASE     129
 #define HFI1_SNOOP_CAPTURE_BASE  200
+#define HFI1_EPROM_BASE		 220
 #define HFI1_NMINORS             255
-
 #define PCI_VENDOR_ID_INTEL 0x8086
 #define PCI_DEVICE_ID_INTEL0 0x24f0
 #define PCI_DEVICE_ID_INTEL1 0x24f1
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 5503451..a486eec 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -149,7 +149,7 @@
 
 #define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.txt */
 
-struct hfi1_cmd;
+struct hfi1_eprom_cmd;
 #define HFI1_PSM_IOC_BASE_SEQ 0x0
 
 #define HFI1_IOCTL_ASSIGN_CTXT \
@@ -177,15 +177,15 @@ struct hfi1_cmd;
 #define HFI1_IOCTL_TID_INVAL_READ \
 	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_INVAL_READ, struct hfi1_tid_info)
 #define HFI1_IOCTL_EP_INFO \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_INFO, struct hfi1_cmd)
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_INFO, struct hfi1_eprom_cmd)
 #define HFI1_IOCTL_EP_ERASE_CHIP \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_CHIP, struct hfi1_cmd)
+	_IO(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_CHIP)
 #define HFI1_IOCTL_EP_ERASE_RANGE \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_RANGE, struct hfi1_cmd)
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_RANGE, struct hfi1_eprom_cmd)
 #define HFI1_IOCTL_EP_READ_RANGE \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_READ_RANGE, struct hfi1_cmd)
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_READ_RANGE, struct hfi1_eprom_cmd)
 #define HFI1_IOCTL_EP_WRITE_RANGE \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_WRITE_RANGE, struct hfi1_cmd)
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_WRITE_RANGE, struct hfi1_eprom_cmd)
 
 #define HFI1_SNOOP_IOC_BASE_SEQ 0x80 /* leaves plenty of room for psm */
 #define HFI1_SNOOP_IOC_MAGIC IB_IOCTL_MAGIC
@@ -337,11 +337,10 @@ struct hfi1_tid_info {
 	__u32 length;
 };
 
-/* hfi1_cmd is used for EPROM commands only */
-struct hfi1_cmd {
-	__u32 type;        /* command type */
-	__u32 len;         /* length of struct pointed to by add */
-	__u64 addr;        /* pointer to user structure */
+struct hfi1_eprom_cmd {
+	__u32 start;       /* start for a range request */
+	__u32 length;	   /* length of  a range request */
+	__u64 addr;        /* pointer to user memory */
 };
 
 enum hfi1_sdma_comp_state {
