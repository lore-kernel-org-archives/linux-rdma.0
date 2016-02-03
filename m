From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/54] staging/rdma/hfi1: Fix for generic I2C interface
Date: Wed, 03 Feb 2016 14:34:15 -0800
Message-ID: <20160203223412.5923.12778.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pablo Cacho <pablo.cacho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The original I2C interface was geared for QSFP accesses. Modify
the interface to behave more like a generic I2C controller such
that reads and writes can accept multi-byte offsets. Removed
reads following writes and moved reset to top level.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Pablo Cacho <pablo.cacho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/debugfs.c |    6 +-
 drivers/staging/rdma/hfi1/qsfp.c    |   88 +++++++++++++++--------
 drivers/staging/rdma/hfi1/qsfp.h    |    4 +
 drivers/staging/rdma/hfi1/twsi.c    |  134 +++++++++++++++--------------------
 4 files changed, 122 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index acd2269..d6dc339 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -463,7 +463,8 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 		goto _free;
 	}
 
-	i2c_addr = (*ppos >> 16) & 0xff;
+	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
+	i2c_addr = (*ppos >> 16) & 0xffff;
 	offset = *ppos & 0xffff;
 
 	total_written = i2c_write(ppd, target, i2c_addr, offset, buff, count);
@@ -517,7 +518,8 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 		goto _return;
 	}
 
-	i2c_addr = (*ppos >> 16) & 0xff;
+	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
+	i2c_addr = (*ppos >> 16) & 0xffff;
 	offset = *ppos & 0xffff;
 
 	total_read = i2c_read(ppd, target, i2c_addr, offset, buff, count);
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 0d2ec97..0e1a492 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -71,14 +71,6 @@ static int __i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 	int ret, cnt;
 	u8 *buff = bp;
 
-	/* Make sure TWSI bus is in sane state. */
-	ret = hfi1_twsi_reset(dd, target);
-	if (ret) {
-		hfi1_dev_porterr(dd, ppd->port,
-				 "I2C interface Reset for write failed\n");
-		return -EIO;
-	}
-
 	cnt = 0;
 	while (cnt < len) {
 		int wlen = len - cnt;
@@ -106,11 +98,22 @@ int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	int ret;
 
 	ret = mutex_lock_interruptible(&dd->qsfp_i2c_mutex);
-	if (!ret) {
-		ret = __i2c_write(ppd, target, i2c_addr, offset, bp, len);
-		mutex_unlock(&dd->qsfp_i2c_mutex);
+	if (ret)
+		return ret;
+
+	/* make sure the TWSI bus is in a sane state */
+	ret = hfi1_twsi_reset(ppd->dd, target);
+	if (ret) {
+		hfi1_dev_porterr(ppd->dd, ppd->port,
+				 "I2C write interface reset failed\n");
+		ret = -EIO;
+		goto done;
 	}
 
+	ret = __i2c_write(ppd, target, i2c_addr, offset, bp, len);
+
+done:
+	mutex_unlock(&dd->qsfp_i2c_mutex);
 	return ret;
 }
 
@@ -125,16 +128,6 @@ static int __i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 	int stuck = 0;
 	u8 *buff = bp;
 
-	/* Make sure TWSI bus is in sane state. */
-	ret = hfi1_twsi_reset(dd, target);
-	if (ret) {
-		hfi1_dev_porterr(dd, ppd->port,
-				 "I2C interface Reset for read failed\n");
-		ret = -EIO;
-		stuck = 1;
-		goto exit;
-	}
-
 	cnt = 0;
 	while (cnt < len) {
 		int rlen = len - cnt;
@@ -178,11 +171,22 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	int ret;
 
 	ret = mutex_lock_interruptible(&dd->qsfp_i2c_mutex);
-	if (!ret) {
-		ret = __i2c_read(ppd, target, i2c_addr, offset, bp, len);
-		mutex_unlock(&dd->qsfp_i2c_mutex);
+	if (ret)
+		return ret;
+
+	/* make sure the TWSI bus is in a sane state */
+	ret = hfi1_twsi_reset(ppd->dd, target);
+	if (ret) {
+		hfi1_dev_porterr(ppd->dd, ppd->port,
+				 "I2C read interface reset failed\n");
+		ret = -EIO;
+		goto done;
 	}
 
+	ret = __i2c_read(ppd, target, i2c_addr, offset, bp, len);
+
+done:
+	mutex_unlock(&dd->qsfp_i2c_mutex);
 	return ret;
 }
 
@@ -203,6 +207,15 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	if (ret)
 		return ret;
 
+	/* make sure the TWSI bus is in a sane state */
+	ret = hfi1_twsi_reset(ppd->dd, target);
+	if (ret) {
+		hfi1_dev_porterr(ppd->dd, ppd->port,
+				 "QSFP write interface reset failed\n");
+		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
+		return -EIO;
+	}
+
 	while (count < len) {
 		/*
 		 * Set the qsfp page based on a zero-based addresss
@@ -210,8 +223,8 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		 */
 		page = (u8)(addr / QSFP_PAGESIZE);
 
-		ret = __i2c_write(ppd, target, QSFP_DEV,
-					QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
+		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
+				  QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
 		if (ret != 1) {
 			hfi1_dev_porterr(
 			ppd->dd,
@@ -227,8 +240,8 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		if (((addr % QSFP_RW_BOUNDARY) + nwrite) > QSFP_RW_BOUNDARY)
 			nwrite = QSFP_RW_BOUNDARY - (addr % QSFP_RW_BOUNDARY);
 
-		ret = __i2c_write(ppd, target, QSFP_DEV, offset, bp + count,
-					nwrite);
+		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
+				  offset, bp + count, nwrite);
 		if (ret <= 0)	/* stop on error or nothing written */
 			break;
 
@@ -260,14 +273,23 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	if (ret)
 		return ret;
 
+	/* make sure the TWSI bus is in a sane state */
+	ret = hfi1_twsi_reset(ppd->dd, target);
+	if (ret) {
+		hfi1_dev_porterr(ppd->dd, ppd->port,
+				 "QSFP read interface reset failed\n");
+		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
+		return -EIO;
+	}
+
 	while (count < len) {
 		/*
 		 * Set the qsfp page based on a zero-based address
 		 * and a page size of QSFP_PAGESIZE bytes.
 		 */
 		page = (u8)(addr / QSFP_PAGESIZE);
-		ret = __i2c_write(ppd, target, QSFP_DEV,
-					QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
+		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
+				  QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
 		if (ret != 1) {
 			hfi1_dev_porterr(
 			ppd->dd,
@@ -283,8 +305,10 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		if (((addr % QSFP_RW_BOUNDARY) + nread) > QSFP_RW_BOUNDARY)
 			nread = QSFP_RW_BOUNDARY - (addr % QSFP_RW_BOUNDARY);
 
-		ret = __i2c_read(ppd, target, QSFP_DEV, offset, bp + count,
-					nread);
+		/* QSFPs require a 5-10msec delay after write operations */
+		mdelay(5);
+		ret = __i2c_read(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
+				 offset, bp + count, nread);
 		if (ret <= 0)	/* stop on error or nothing read */
 			break;
 
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index b1b9e4a..af59a43 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -70,6 +70,10 @@
 /* Reads/writes cannot cross 128 byte boundaries */
 #define QSFP_RW_BOUNDARY 128
 
+/* number of bytes in i2c offset for QSFP devices */
+#define __QSFP_OFFSET_SIZE 1                           /* num address bytes */
+#define QSFP_OFFSET_SIZE (__QSFP_OFFSET_SIZE << 8)     /* shifted value */
+
 /* Defined fields that Intel requires of qualified cables */
 /* Byte 0 is Identifier, not checked */
 /* Byte 1 is reserved "status MSB" */
diff --git a/drivers/staging/rdma/hfi1/twsi.c b/drivers/staging/rdma/hfi1/twsi.c
index ea54fd2..7c579b3 100644
--- a/drivers/staging/rdma/hfi1/twsi.c
+++ b/drivers/staging/rdma/hfi1/twsi.c
@@ -365,17 +365,25 @@ static int twsi_wr(struct hfi1_devdata *dd, u32 target, int data, int flags)
  * HFI1_TWSI_NO_DEV and does the correct operation for the legacy part,
  * which responded to all TWSI device codes, interpreting them as
  * address within device. On all other devices found on board handled by
- * this driver, the device is followed by a one-byte "address" which selects
+ * this driver, the device is followed by a N-byte "address" which selects
  * the "register" or "offset" within the device from which data should
  * be read.
  */
 int hfi1_twsi_blk_rd(struct hfi1_devdata *dd, u32 target, int dev, int addr,
 		     void *buffer, int len)
 {
-	int ret;
 	u8 *bp = buffer;
+	int ret = 1;
+	int i;
+	int offset_size;
+
+	/* obtain the offset size, strip it from the device address */
+	offset_size = (dev >> 8) & 0xff;
+	dev &= 0xff;
 
-	ret = 1;
+	/* allow at most a 2 byte offset */
+	if (offset_size > 2)
+		goto bail;
 
 	if (dev == HFI1_TWSI_NO_DEV) {
 		/* legacy not-really-I2C */
@@ -383,34 +391,29 @@ int hfi1_twsi_blk_rd(struct hfi1_devdata *dd, u32 target, int dev, int addr,
 		ret = twsi_wr(dd, target, addr, HFI1_TWSI_START);
 	} else {
 		/* Actual I2C */
-		ret = twsi_wr(dd, target, dev | WRITE_CMD, HFI1_TWSI_START);
-		if (ret) {
-			stop_cmd(dd, target);
-			ret = 1;
-			goto bail;
-		}
-		/*
-		 * SFF spec claims we do _not_ stop after the addr
-		 * but simply issue a start with the "read" dev-addr.
-		 * Since we are implicitly waiting for ACK here,
-		 * we need t_buf (nominally 20uSec) before that start,
-		 * and cannot rely on the delay built in to the STOP
-		 */
-		ret = twsi_wr(dd, target, addr, 0);
-		udelay(TWSI_BUF_WAIT_USEC);
+		if (offset_size) {
+			ret = twsi_wr(dd, target,
+				      dev | WRITE_CMD, HFI1_TWSI_START);
+			if (ret) {
+				stop_cmd(dd, target);
+				goto bail;
+			}
 
-		if (ret) {
-			dd_dev_err(dd,
-				"Failed to write interface read addr %02X\n",
-				addr);
-			ret = 1;
-			goto bail;
+			for (i = 0; i < offset_size; i++) {
+				ret = twsi_wr(dd, target,
+					      (addr >> (i * 8)) & 0xff, 0);
+				udelay(TWSI_BUF_WAIT_USEC);
+				if (ret) {
+					dd_dev_err(dd, "Failed to write byte %d of offset 0x%04X\n",
+						   i, addr);
+					goto bail;
+				}
+			}
 		}
 		ret = twsi_wr(dd, target, dev | READ_CMD, HFI1_TWSI_START);
 	}
 	if (ret) {
 		stop_cmd(dd, target);
-		ret = 1;
 		goto bail;
 	}
 
@@ -442,76 +445,55 @@ bail:
  * HFI1_TWSI_NO_DEV and does the correct operation for the legacy part,
  * which responded to all TWSI device codes, interpreting them as
  * address within device. On all other devices found on board handled by
- * this driver, the device is followed by a one-byte "address" which selects
+ * this driver, the device is followed by a N-byte "address" which selects
  * the "register" or "offset" within the device to which data should
  * be written.
  */
 int hfi1_twsi_blk_wr(struct hfi1_devdata *dd, u32 target, int dev, int addr,
 		     const void *buffer, int len)
 {
-	int sub_len;
 	const u8 *bp = buffer;
-	int max_wait_time, i;
 	int ret = 1;
+	int i;
+	int offset_size;
 
-	while (len > 0) {
-		if (dev == HFI1_TWSI_NO_DEV) {
-			if (twsi_wr(dd, target, (addr << 1) | WRITE_CMD,
-				    HFI1_TWSI_START)) {
-				goto failed_write;
-			}
-		} else {
-			/* Real I2C */
-			if (twsi_wr(dd, target,
-				    dev | WRITE_CMD, HFI1_TWSI_START))
-				goto failed_write;
-			ret = twsi_wr(dd, target, addr, 0);
-			if (ret) {
-				dd_dev_err(dd,
-					"Failed to write interface write addr %02X\n",
-					addr);
-				goto failed_write;
-			}
-		}
+	/* obtain the offset size, strip it from the device address */
+	offset_size = (dev >> 8) & 0xff;
+	dev &= 0xff;
 
-		sub_len = min(len, 4);
-		addr += sub_len;
-		len -= sub_len;
-
-		for (i = 0; i < sub_len; i++)
-			if (twsi_wr(dd, target, *bp++, 0))
-				goto failed_write;
+	/* allow at most a 2 byte offset */
+	if (offset_size > 2)
+		goto bail;
 
-		stop_cmd(dd, target);
+	if (dev == HFI1_TWSI_NO_DEV) {
+		if (twsi_wr(dd, target, (addr << 1) | WRITE_CMD,
+			    HFI1_TWSI_START)) {
+			goto failed_write;
+		}
+	} else {
+		/* Real I2C */
+		if (twsi_wr(dd, target, dev | WRITE_CMD, HFI1_TWSI_START))
+			goto failed_write;
+	}
 
-		/*
-		 * Wait for write complete by waiting for a successful
-		 * read (the chip replies with a zero after the write
-		 * cmd completes, and before it writes to the eeprom.
-		 * The startcmd for the read will fail the ack until
-		 * the writes have completed.   We do this inline to avoid
-		 * the debug prints that are in the real read routine
-		 * if the startcmd fails.
-		 * We also use the proper device address, so it doesn't matter
-		 * whether we have real eeprom_dev. Legacy likes any address.
-		 */
-		max_wait_time = 100;
-		while (twsi_wr(dd, target,
-			       dev | READ_CMD, HFI1_TWSI_START)) {
-			stop_cmd(dd, target);
-			if (!--max_wait_time)
-				goto failed_write;
+	for (i = 0; i < offset_size; i++) {
+		ret = twsi_wr(dd, target, (addr >> (i * 8)) & 0xff, 0);
+		udelay(TWSI_BUF_WAIT_USEC);
+		if (ret) {
+			dd_dev_err(dd, "Failed to write byte %d of offset 0x%04X\n",
+				   i, addr);
+			goto bail;
 		}
-		/* now read (and ignore) the resulting byte */
-		rd_byte(dd, target, 1);
 	}
 
+	for (i = 0; i < len; i++)
+		if (twsi_wr(dd, target, *bp++, 0))
+			goto failed_write;
+
 	ret = 0;
-	goto bail;
 
 failed_write:
 	stop_cmd(dd, target);
-	ret = 1;
 
 bail:
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
