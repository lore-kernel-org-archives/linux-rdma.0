From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 3/7] IB/hfi1: Add ioctl() interface for user commands
Date: Thu, 14 Apr 2016 08:41:53 -0700
Message-ID: <20160414154153.6387.9905.stgit@scvm10.sc.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Mitko Haralanov <mitko.haralanov@intel.com>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

IOCTL is more suited to what user space commands need to do than the
write() interface. Add IOCTL definitions for all existing write commands
and the handling for those. The write() interface will be removed in a
follow on patch.

Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/staging/rdma/hfi1/common.h   |    6 +
 drivers/staging/rdma/hfi1/diag.c     |   13 --
 drivers/staging/rdma/hfi1/file_ops.c |  224 ++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/hfi.h      |   14 ++
 include/uapi/rdma/hfi/hfi1_user.h    |   48 +++++++
 5 files changed, 294 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index e9b6bb3..37ac229 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -178,7 +178,8 @@
 		     HFI1_CAP_PKEY_CHECK |		\
 		     HFI1_CAP_NO_INTEGRITY)
 
-#define HFI1_USER_SWVERSION ((HFI1_USER_SWMAJOR << 16) | HFI1_USER_SWMINOR)
+#define HFI1_USER_SWVERSION ((HFI1_USER_SWMAJOR << HFI1_SWMAJOR_SHIFT) | \
+			     HFI1_USER_SWMINOR)
 
 #ifndef HFI1_KERN_TYPE
 #define HFI1_KERN_TYPE 0
@@ -349,6 +350,9 @@ struct hfi1_message_header {
 #define HFI1_BECN_MASK 1
 #define HFI1_BECN_SMASK BIT(HFI1_BECN_SHIFT)
 
+#define HFI1_PSM_IOC_BASE_SEQ 0x0
+#define HFI1_SNOOP_IOC_BASE_SEQ 0x80 /* leaves plenty of room for psm */
+
 static inline __u64 rhf_to_cpu(const __le32 *rbuf)
 {
 	return __le64_to_cpu(*((__le64 *)rbuf));
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index bb2409a..4cf6e8d 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -168,9 +168,7 @@ struct hfi1_link_info {
  */
 #define SNOOP_CAPTURE_VERSION 0x1
 
-#define IB_IOCTL_MAGIC          0x1b /* See Documentation/ioctl-number.txt */
 #define HFI1_SNOOP_IOC_MAGIC IB_IOCTL_MAGIC
-#define HFI1_SNOOP_IOC_BASE_SEQ 0x80
 
 #define HFI1_SNOOP_IOCGETLINKSTATE \
 	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ)
@@ -1040,21 +1038,16 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	struct hfi1_pportdata *ppd = NULL;
 	unsigned int index;
 	struct hfi1_link_info link_info;
-	int read_cmd, write_cmd, read_ok, write_ok;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
 	if (!dd)
 		return -ENODEV;
 
-	mode_flag = dd->hfi1_snoop.mode_flag;
-	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
-	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
-	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
-	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
-
-	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
+	if (check_ioctl_access(cmd, arg))
 		return -EFAULT;
 
+	mode_flag = dd->hfi1_snoop.mode_flag;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 00d1b34..fab8676 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -95,6 +95,8 @@ static int user_event_ack(struct hfi1_ctxtdata *, int, unsigned long);
 static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned, u16);
 static int manage_rcvq(struct hfi1_ctxtdata *, unsigned, int);
 static int vma_fault(struct vm_area_struct *, struct vm_fault *);
+static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
+			    unsigned long arg);
 
 static const struct file_operations hfi1_file_ops = {
 	.owner = THIS_MODULE,
@@ -102,6 +104,7 @@ static const struct file_operations hfi1_file_ops = {
 	.write_iter = hfi1_write_iter,
 	.open = hfi1_file_open,
 	.release = hfi1_file_close,
+	.unlocked_ioctl = hfi1_file_ioctl,
 	.poll = hfi1_poll,
 	.mmap = hfi1_file_mmap,
 	.llseek = noop_llseek,
@@ -174,6 +177,227 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 	return fp->private_data ? 0 : -ENOMEM;
 }
 
+static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_user_info uinfo;
+	struct hfi1_tid_info tinfo;
+	struct hfi1_cmd ucmd;
+	int uctxt_required = 1;
+	int ret = 0;
+	unsigned long addr;
+	int uval = 0;
+	unsigned long ul_uval = 0;
+	u16 uval16 = 0;
+
+	ret = check_ioctl_access(cmd, arg);
+	if (ret)
+		return ret;
+
+	switch (cmd) {
+	case HFI1_IOCTL_ASSIGN_CTXT:
+		uctxt_required = 0; /* assigned user context not required */
+		break;
+	case HFI1_IOCTL_EP_INFO:
+	case HFI1_IOCTL_EP_ERASE_CHIP:
+	case HFI1_IOCTL_EP_ERASE_RANGE:
+	case HFI1_IOCTL_EP_READ_RANGE:
+	case HFI1_IOCTL_EP_WRITE_RANGE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		if (copy_from_user(&ucmd,
+				   (struct hfi11_cmd __user *)arg,
+				   sizeof(ucmd)))
+			return -EFAULT;
+		return handle_eprom_command(fp, &ucmd);
+	}
+
+	if (uctxt_required && !uctxt)
+		return -EINVAL;
+
+	/* Checked for root/context process the IOCTL */
+	switch (cmd) {
+	case HFI1_IOCTL_ASSIGN_CTXT:
+		if (copy_from_user(&uinfo,
+				   (struct hfi1_user_info __user *)arg,
+				   sizeof(uinfo)))
+			return -EFAULT;
+
+		ret = assign_ctxt(fp, &uinfo);
+		if (ret < 0)
+			return ret;
+		setup_ctxt(fp);
+		if (ret)
+			return ret;
+		ret = user_init(fp);
+		break;
+	case HFI1_IOCTL_CTXT_INFO:
+		ret = get_ctxt_info(fp, (void __user *)(unsigned long)arg,
+				    sizeof(struct hfi1_ctxt_info));
+		break;
+	case HFI1_IOCTL_USER_INFO:
+		ret = get_base_info(fp, (void __user *)(unsigned long)arg,
+				    sizeof(struct hfi1_base_info));
+		break;
+	case HFI1_IOCTL_CREDIT_UPD:
+		if (uctxt && uctxt->sc)
+			sc_return_credits(uctxt->sc);
+		break;
+
+	case HFI1_IOCTL_TID_UPDATE:
+		if (copy_from_user(&tinfo,
+				   (struct hfi11_tid_info __user *)arg,
+				   sizeof(tinfo)))
+			return -EFAULT;
+
+		ret = hfi1_user_exp_rcv_setup(fp, &tinfo);
+		if (!ret) {
+			/*
+			 * Copy the number of tidlist entries we used
+			 * and the length of the buffer we registered.
+			 * These fields are adjacent in the structure so
+			 * we can copy them at the same time.
+			 */
+			addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
+			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+					 sizeof(tinfo.tidcnt) +
+					 sizeof(tinfo.length)))
+				ret = -EFAULT;
+		}
+		break;
+
+	case HFI1_IOCTL_TID_FREE:
+		if (copy_from_user(&tinfo,
+				   (struct hfi11_tid_info __user *)arg,
+				   sizeof(tinfo)))
+			return -EFAULT;
+
+		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
+		if (ret)
+			break;
+		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			ret = -EFAULT;
+		break;
+
+	case HFI1_IOCTL_TID_INVAL_READ:
+		if (copy_from_user(&tinfo,
+				   (struct hfi11_tid_info __user *)arg,
+				   sizeof(tinfo)))
+			return -EFAULT;
+
+		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
+		if (ret)
+			break;
+		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			ret = -EFAULT;
+		break;
+
+	case HFI1_IOCTL_RECV_CTRL:
+		ret = __get_user(uval, (int __user *)arg);
+		if (ret != 0)
+			return -EFAULT;
+		ret = manage_rcvq(uctxt, fd->subctxt, uval);
+		break;
+
+	case HFI1_IOCTL_POLL_TYPE:
+		ret = __get_user(uval, (int __user *)arg);
+		if (ret != 0)
+			return -EFAULT;
+		uctxt->poll_type = (typeof(uctxt->poll_type))uval;
+		break;
+
+	case HFI1_IOCTL_ACK_EVENT:
+		ret = __get_user(ul_uval, (unsigned long __user *)arg);
+		if (ret != 0)
+			return -EFAULT;
+		ret = user_event_ack(uctxt, fd->subctxt, ul_uval);
+		break;
+
+	case HFI1_IOCTL_SET_PKEY:
+		ret = __get_user(uval16, (u16 __user *)arg);
+		if (ret != 0)
+			return -EFAULT;
+		if (HFI1_CAP_IS_USET(PKEY_CHECK))
+			ret = set_ctxt_pkey(uctxt, fd->subctxt, uval16);
+		else
+			ret = -EPERM;
+		break;
+
+	case HFI1_IOCTL_CTXT_RESET: {
+		struct send_context *sc;
+		struct hfi1_devdata *dd;
+
+		if (!uctxt || !uctxt->dd || !uctxt->sc) {
+			ret = -EINVAL;
+			break;
+		}
+		/*
+		 * There is no protection here. User level has to
+		 * guarantee that no one will be writing to the send
+		 * context while it is being re-initialized.
+		 * If user level breaks that guarantee, it will break
+		 * it's own context and no one else's.
+		 */
+		dd = uctxt->dd;
+		sc = uctxt->sc;
+		/*
+		 * Wait until the interrupt handler has marked the
+		 * context as halted or frozen. Report error if we time
+		 * out.
+		 */
+		wait_event_interruptible_timeout(
+			sc->halt_wait, (sc->flags & SCF_HALTED),
+			msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
+		if (!(sc->flags & SCF_HALTED)) {
+			ret = -ENOLCK;
+			break;
+		}
+		/*
+		 * If the send context was halted due to a Freeze,
+		 * wait until the device has been "unfrozen" before
+		 * resetting the context.
+		 */
+		if (sc->flags & SCF_FROZEN) {
+			wait_event_interruptible_timeout(
+				dd->event_queue,
+				!(ACCESS_ONCE(dd->flags) & HFI1_FROZEN),
+				msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
+			if (dd->flags & HFI1_FROZEN) {
+				ret = -ENOLCK;
+				break;
+			}
+			if (dd->flags & HFI1_FORCED_FREEZE) {
+				/*
+				 * Don't allow context reset if we are into
+				 * forced freeze
+				 */
+				ret = -ENODEV;
+				break;
+			}
+			sc_disable(sc);
+			ret = sc_enable(sc);
+			hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB,
+				     uctxt->ctxt);
+		} else {
+			ret = sc_restart(sc);
+		}
+		if (!ret)
+			sc_return_credits(sc);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
 static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 			       size_t count, loff_t *offset)
 {
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 7b78d56..7351898 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1946,4 +1946,18 @@ static inline u32 qsfp_resource(struct hfi1_devdata *dd)
 
 int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp);
 
+static inline int check_ioctl_access(unsigned int cmd, unsigned long arg)
+{
+	int read_cmd, write_cmd, read_ok, write_ok;
+
+	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
+	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
+	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
+	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
+
+	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
+		return -EFAULT;
+
+	return 0;
+}
 #endif                          /* _HFI1_KERNEL_H */
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 46f6caa..37a9697 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -78,6 +78,11 @@
 #define HFI1_USER_SWMINOR 0
 
 /*
+ * We will encode the major/minor inside a single 32bit version number.
+ */
+#define HFI1_SWMAJOR_SHIFT 16
+
+/*
  * Set of HW and driver capability/feature bits.
  * These bit values are used to configure enabled/disabled HW and
  * driver features. The same set of bits are communicated to user
@@ -142,6 +147,48 @@
 #define HFI1_CMD_EP_READ_RANGE   76      /* read EPROM range */
 #define HFI1_CMD_EP_WRITE_RANGE  77      /* write EPROM range */
 
+/*
+ * User IOCTLs can not go above 128 if they do then see common.h and change the
+ * base for the snoop ioctl
+ */
+#define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.txt */
+
+struct hfi1_cmd;
+#define HFI1_IOCTL_ASSIGN_CTXT \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_ASSIGN_CTXT, struct hfi1_user_info)
+#define HFI1_IOCTL_CTXT_INFO \
+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_INFO, struct hfi1_ctxt_info)
+#define HFI1_IOCTL_USER_INFO \
+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_USER_INFO, struct hfi1_base_info)
+#define HFI1_IOCTL_TID_UPDATE \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_UPDATE, struct hfi1_tid_info)
+#define HFI1_IOCTL_TID_FREE \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_FREE, struct hfi1_tid_info)
+#define HFI1_IOCTL_CREDIT_UPD \
+	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CREDIT_UPD)
+#define HFI1_IOCTL_RECV_CTRL \
+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_RECV_CTRL, int)
+#define HFI1_IOCTL_POLL_TYPE \
+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_POLL_TYPE, int)
+#define HFI1_IOCTL_ACK_EVENT \
+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_ACK_EVENT, unsigned long)
+#define HFI1_IOCTL_SET_PKEY \
+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_SET_PKEY, __u16)
+#define HFI1_IOCTL_CTXT_RESET \
+	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_RESET)
+#define HFI1_IOCTL_TID_INVAL_READ \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_INVAL_READ, struct hfi1_tid_info)
+#define HFI1_IOCTL_EP_INFO \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_INFO, struct hfi1_cmd)
+#define HFI1_IOCTL_EP_ERASE_CHIP \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_CHIP, struct hfi1_cmd)
+#define HFI1_IOCTL_EP_ERASE_RANGE \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_ERASE_RANGE, struct hfi1_cmd)
+#define HFI1_IOCTL_EP_READ_RANGE \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_READ_RANGE, struct hfi1_cmd)
+#define HFI1_IOCTL_EP_WRITE_RANGE \
+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_EP_WRITE_RANGE, struct hfi1_cmd)
+
 #define _HFI1_EVENT_FROZEN_BIT         0
 #define _HFI1_EVENT_LINKDOWN_BIT       1
 #define _HFI1_EVENT_LID_CHANGE_BIT     2
@@ -242,6 +289,7 @@ struct hfi1_tid_info {
 	__u32 length;
 };
 
+/* hfi1_cmd is used for EPROM commands only */
 struct hfi1_cmd {
 	__u32 type;        /* command type */
 	__u32 len;         /* length of struct pointed to by add */
