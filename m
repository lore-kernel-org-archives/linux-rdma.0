From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] IB/hfi1: Remove EPROM functionality from data device
Date: Thu, 12 May 2016 10:28:08 -0700
Message-ID: <20160512172807.11667.68143.stgit@scvm10.sc.intel.com>
References: <20160512172500.11667.11333.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172500.11667.11333.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove EPROM handling from the cdev which is used for user application
data traffic.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/eprom.c    |  369 ----------------------------------
 drivers/staging/rdma/hfi1/file_ops.c |   22 --
 include/uapi/rdma/hfi/hfi1_user.h    |   24 --
 3 files changed, 1 insertions(+), 414 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index bd87715..36b7794 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -49,387 +49,18 @@
 #include "common.h"
 #include "eprom.h"
 
-/*
- * The EPROM is logically divided into three partitions:
- *	partition 0: the first 128K, visible from PCI ROM BAR
- *	partition 1: 4K config file (sector size)
- *	partition 2: the rest
- */
-#define P0_SIZE (128 * 1024)
-#define P1_SIZE   (4 * 1024)
-#define P1_START P0_SIZE
-#define P2_START (P0_SIZE + P1_SIZE)
-
-/* erase sizes supported by the controller */
-#define SIZE_4KB (4 * 1024)
-#define MASK_4KB (SIZE_4KB - 1)
-
-#define SIZE_32KB (32 * 1024)
-#define MASK_32KB (SIZE_32KB - 1)
-
-#define SIZE_64KB (64 * 1024)
-#define MASK_64KB (SIZE_64KB - 1)
-
-/* controller page size, in bytes */
-#define EP_PAGE_SIZE 256
-#define EEP_PAGE_MASK (EP_PAGE_SIZE - 1)
-
-/* controller commands */
 #define CMD_SHIFT 24
-#define CMD_NOP			    (0)
-#define CMD_PAGE_PROGRAM(addr)	    ((0x02 << CMD_SHIFT) | addr)
-#define CMD_READ_DATA(addr)	    ((0x03 << CMD_SHIFT) | addr)
-#define CMD_READ_SR1		    ((0x05 << CMD_SHIFT))
-#define CMD_WRITE_ENABLE	    ((0x06 << CMD_SHIFT))
-#define CMD_SECTOR_ERASE_4KB(addr)  ((0x20 << CMD_SHIFT) | addr)
-#define CMD_SECTOR_ERASE_32KB(addr) ((0x52 << CMD_SHIFT) | addr)
-#define CMD_CHIP_ERASE		    ((0x60 << CMD_SHIFT))
-#define CMD_READ_MANUF_DEV_ID	    ((0x90 << CMD_SHIFT))
 #define CMD_RELEASE_POWERDOWN_NOID  ((0xab << CMD_SHIFT))
-#define CMD_SECTOR_ERASE_64KB(addr) ((0xd8 << CMD_SHIFT) | addr)
 
 /* controller interface speeds */
 #define EP_SPEED_FULL 0x2	/* full speed */
 
-/* controller status register 1 bits */
-#define SR1_BUSY 0x1ull		/* the BUSY bit in SR1 */
-
-/* sleep length while waiting for controller */
-#define WAIT_SLEEP_US 100	/* must be larger than 5 (see usage) */
-#define COUNT_DELAY_SEC(n) ((n) * (1000000 / WAIT_SLEEP_US))
-
-/* GPIO pins */
-#define EPROM_WP_N BIT_ULL(14)	/* EPROM write line */
-
 /*
  * How long to wait for the EPROM to become available, in ms.
  * The spec 32 Mb EPROM takes around 40s to erase then write.
  * Double it for safety.
  */
 #define EPROM_TIMEOUT 80000 /* ms */
-
-/*
- * Turn on external enable line that allows writing on the flash.
- */
-static void write_enable(struct hfi1_devdata *dd)
-{
-	/* raise signal */
-	write_csr(dd, ASIC_GPIO_OUT, read_csr(dd, ASIC_GPIO_OUT) | EPROM_WP_N);
-	/* raise enable */
-	write_csr(dd, ASIC_GPIO_OE, read_csr(dd, ASIC_GPIO_OE) | EPROM_WP_N);
-}
-
-/*
- * Turn off external enable line that allows writing on the flash.
- */
-static void write_disable(struct hfi1_devdata *dd)
-{
-	/* lower signal */
-	write_csr(dd, ASIC_GPIO_OUT, read_csr(dd, ASIC_GPIO_OUT) & ~EPROM_WP_N);
-	/* lower enable */
-	write_csr(dd, ASIC_GPIO_OE, read_csr(dd, ASIC_GPIO_OE) & ~EPROM_WP_N);
-}
-
-/*
- * Wait for the device to become not busy.  Must be called after all
- * write or erase operations.
- */
-static int wait_for_not_busy(struct hfi1_devdata *dd)
-{
-	unsigned long count = 0;
-	u64 reg;
-	int ret = 0;
-
-	/* starts page mode */
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_SR1);
-	while (1) {
-		udelay(WAIT_SLEEP_US);
-		usleep_range(WAIT_SLEEP_US - 5, WAIT_SLEEP_US + 5);
-		count++;
-		reg = read_csr(dd, ASIC_EEP_DATA);
-		if ((reg & SR1_BUSY) == 0)
-			break;
-		/* 200s is the largest time for a 128Mb device */
-		if (count > COUNT_DELAY_SEC(200)) {
-			dd_dev_err(dd, "waited too long for SPI FLASH busy to clear - failing\n");
-			ret = -ETIMEDOUT;
-			break; /* break, not goto - must stop page mode */
-		}
-	}
-
-	/* stop page mode with a NOP */
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_NOP);
-
-	return ret;
-}
-
-/*
- * Read the device ID from the SPI controller.
- */
-static u32 read_device_id(struct hfi1_devdata *dd)
-{
-	/* read the Manufacture Device ID */
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_MANUF_DEV_ID);
-	return (u32)read_csr(dd, ASIC_EEP_DATA);
-}
-
-/*
- * Erase the whole flash.
- */
-static int erase_chip(struct hfi1_devdata *dd)
-{
-	int ret;
-
-	write_enable(dd);
-
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_WRITE_ENABLE);
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_CHIP_ERASE);
-	ret = wait_for_not_busy(dd);
-
-	write_disable(dd);
-
-	return ret;
-}
-
-/*
- * Erase a range.
- */
-static int erase_range(struct hfi1_devdata *dd, u32 start, u32 len)
-{
-	u32 end = start + len;
-	int ret = 0;
-
-	if (end < start)
-		return -EINVAL;
-
-	/* check the end points for the minimum erase */
-	if ((start & MASK_4KB) || (end & MASK_4KB)) {
-		dd_dev_err(dd,
-			   "%s: non-aligned range (0x%x,0x%x) for a 4KB erase\n",
-			   __func__, start, end);
-		return -EINVAL;
-	}
-
-	write_enable(dd);
-
-	while (start < end) {
-		write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_WRITE_ENABLE);
-		/* check in order of largest to smallest */
-		if (((start & MASK_64KB) == 0) && (start + SIZE_64KB <= end)) {
-			write_csr(dd, ASIC_EEP_ADDR_CMD,
-				  CMD_SECTOR_ERASE_64KB(start));
-			start += SIZE_64KB;
-		} else if (((start & MASK_32KB) == 0) &&
-			   (start + SIZE_32KB <= end)) {
-			write_csr(dd, ASIC_EEP_ADDR_CMD,
-				  CMD_SECTOR_ERASE_32KB(start));
-			start += SIZE_32KB;
-		} else {	/* 4KB will work */
-			write_csr(dd, ASIC_EEP_ADDR_CMD,
-				  CMD_SECTOR_ERASE_4KB(start));
-			start += SIZE_4KB;
-		}
-		ret = wait_for_not_busy(dd);
-		if (ret)
-			goto done;
-	}
-
-done:
-	write_disable(dd);
-
-	return ret;
-}
-
-/*
- * Read a 256 byte (64 dword) EPROM page.
- * All callers have verified the offset is at a page boundary.
- */
-static void read_page(struct hfi1_devdata *dd, u32 offset, u32 *result)
-{
-	int i;
-
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_DATA(offset));
-	for (i = 0; i < EP_PAGE_SIZE / sizeof(u32); i++)
-		result[i] = (u32)read_csr(dd, ASIC_EEP_DATA);
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_NOP); /* close open page */
-}
-
-/*
- * Read length bytes starting at offset.  Copy to user address addr.
- */
-static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
-{
-	u32 offset;
-	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
-	int ret = 0;
-
-	/* reject anything not on an EPROM page boundary */
-	if ((start & EEP_PAGE_MASK) || (len & EEP_PAGE_MASK))
-		return -EINVAL;
-
-	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
-		read_page(dd, start + offset, buffer);
-		if (copy_to_user((void __user *)(addr + offset),
-				 buffer, EP_PAGE_SIZE)) {
-			ret = -EFAULT;
-			goto done;
-		}
-	}
-
-done:
-	return ret;
-}
-
-/*
- * Write a 256 byte (64 dword) EPROM page.
- * All callers have verified the offset is at a page boundary.
- */
-static int write_page(struct hfi1_devdata *dd, u32 offset, u32 *data)
-{
-	int i;
-
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_WRITE_ENABLE);
-	write_csr(dd, ASIC_EEP_DATA, data[0]);
-	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_PAGE_PROGRAM(offset));
-	for (i = 1; i < EP_PAGE_SIZE / sizeof(u32); i++)
-		write_csr(dd, ASIC_EEP_DATA, data[i]);
-	/* will close the open page */
-	return wait_for_not_busy(dd);
-}
-
-/*
- * Write length bytes starting at offset.  Read from user address addr.
- */
-static int write_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
-{
-	u32 offset;
-	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
-	int ret = 0;
-
-	/* reject anything not on an EPROM page boundary */
-	if ((start & EEP_PAGE_MASK) || (len & EEP_PAGE_MASK))
-		return -EINVAL;
-
-	write_enable(dd);
-
-	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
-		if (copy_from_user(buffer, (void __user *)(addr + offset),
-				   EP_PAGE_SIZE)) {
-			ret = -EFAULT;
-			goto done;
-		}
-		ret = write_page(dd, start + offset, buffer);
-		if (ret)
-			goto done;
-	}
-
-done:
-	write_disable(dd);
-	return ret;
-}
-
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
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 60f8885..fcbbc12 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -182,8 +182,6 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_info uinfo;
 	struct hfi1_tid_info tinfo;
-	struct hfi1_cmd ucmd;
-	int uctxt_required = 1;
 	int ret = 0;
 	unsigned long addr;
 	int uval = 0;
@@ -196,25 +194,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 
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
+	if ((cmd != HFI1_IOCTL_ASSIGN_CTXT) && !uctxt)
 		return -EINVAL;
 
 	/* Checked for root/context process the IOCTL */
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 33a9b1a..c9a8276 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -126,13 +126,6 @@
 #define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
 #define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
 #define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
-/* separate EPROM commands from normal PSM commands */
-#define HFI1_CMD_EP_INFO         64      /* read EPROM device ID */
-#define HFI1_CMD_EP_ERASE_CHIP   65      /* erase whole EPROM */
-/* range 66-74 no longer used */
-#define HFI1_CMD_EP_ERASE_RANGE  75      /* erase EPROM range */
-#define HFI1_CMD_EP_READ_RANGE   76      /* read EPROM range */
-#define HFI1_CMD_EP_WRITE_RANGE  77      /* write EPROM range */
 
 /*
  * User IOCTLs can not go above 128 if they do then see common.h and change the
@@ -165,16 +158,6 @@ struct hfi1_cmd;
 	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_RESET)
 #define HFI1_IOCTL_TID_INVAL_READ \
 	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_INVAL_READ, struct hfi1_tid_info)
-#define HFI1_IOCTL_EP_INFO \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_INFO, struct hfi1_cmd)
-#define HFI1_IOCTL_EP_ERASE_CHIP \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_CHIP, struct hfi1_cmd)
-#define HFI1_IOCTL_EP_ERASE_RANGE \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_RANGE, struct hfi1_cmd)
-#define HFI1_IOCTL_EP_READ_RANGE \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_READ_RANGE, struct hfi1_cmd)
-#define HFI1_IOCTL_EP_WRITE_RANGE \
-	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_WRITE_RANGE, struct hfi1_cmd)
 
 #define _HFI1_EVENT_FROZEN_BIT         0
 #define _HFI1_EVENT_LINKDOWN_BIT       1
@@ -274,13 +257,6 @@ struct hfi1_tid_info {
 	__u32 length;
 };
 
-/* hfi1_cmd is used for EPROM commands only */
-struct hfi1_cmd {
-	__u32 type;        /* command type */
-	__u32 len;         /* length of struct pointed to by add */
-	__u64 addr;        /* pointer to user structure */
-};
-
 enum hfi1_sdma_comp_state {
 	FREE = 0,
 	QUEUED,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
