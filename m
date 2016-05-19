From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/10] IB/hfi1: Remove write(), use ioctl() for user cmds
Date: Thu, 19 May 2016 05:26:31 -0700
Message-ID: <20160519122629.22041.18330.stgit@scvm10.sc.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519122318.22041.58871.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the write() handler for user space commands now that ioctl
handling is available. User apps will need to change to use ioctl from
this point forward.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |  226 ----------------------------------
 include/uapi/rdma/hfi/hfi1_user.h    |    8 -
 2 files changed, 1 insertions(+), 233 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index a338238..c46eada 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -72,8 +72,6 @@
  */
 static int hfi1_file_open(struct inode *, struct file *);
 static int hfi1_file_close(struct inode *, struct file *);
-static ssize_t hfi1_file_write(struct file *, const char __user *,
-			       size_t, loff_t *);
 static ssize_t hfi1_write_iter(struct kiocb *, struct iov_iter *);
 static unsigned int hfi1_poll(struct file *, struct poll_table_struct *);
 static int hfi1_file_mmap(struct file *, struct vm_area_struct *);
@@ -101,7 +99,6 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 
 static const struct file_operations hfi1_file_ops = {
 	.owner = THIS_MODULE,
-	.write = hfi1_file_write,
 	.write_iter = hfi1_write_iter,
 	.open = hfi1_file_open,
 	.release = hfi1_file_close,
@@ -379,229 +376,6 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 	return ret;
 }
 
-static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
-			       size_t count, loff_t *offset)
-{
-	const struct hfi1_cmd __user *ucmd;
-	struct hfi1_filedata *fd = fp->private_data;
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct hfi1_cmd cmd;
-	struct hfi1_user_info uinfo;
-	struct hfi1_tid_info tinfo;
-	unsigned long addr;
-	ssize_t consumed = 0, copy = 0, ret = 0;
-	void *dest = NULL;
-	__u64 user_val = 0;
-	int uctxt_required = 1;
-
-	/* FIXME: This interface cannot continue out of staging */
-	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
-		return -EACCES;
-
-	if (count < sizeof(cmd)) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	ucmd = (const struct hfi1_cmd __user *)data;
-	if (copy_from_user(&cmd, ucmd, sizeof(cmd))) {
-		ret = -EFAULT;
-		goto bail;
-	}
-
-	consumed = sizeof(cmd);
-
-	switch (cmd.type) {
-	case HFI1_CMD_ASSIGN_CTXT:
-		uctxt_required = 0;	/* assigned user context not required */
-		copy = sizeof(uinfo);
-		dest = &uinfo;
-		break;
-	case HFI1_CMD_CREDIT_UPD:
-		copy = 0;
-		break;
-	case HFI1_CMD_TID_UPDATE:
-	case HFI1_CMD_TID_FREE:
-	case HFI1_CMD_TID_INVAL_READ:
-		copy = sizeof(tinfo);
-		dest = &tinfo;
-		break;
-	case HFI1_CMD_USER_INFO:
-	case HFI1_CMD_RECV_CTRL:
-	case HFI1_CMD_POLL_TYPE:
-	case HFI1_CMD_ACK_EVENT:
-	case HFI1_CMD_CTXT_INFO:
-	case HFI1_CMD_SET_PKEY:
-	case HFI1_CMD_CTXT_RESET:
-		copy = 0;
-		user_val = cmd.addr;
-		break;
-	default:
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	/* If the command comes with user data, copy it. */
-	if (copy) {
-		if (copy_from_user(dest, (void __user *)cmd.addr, copy)) {
-			ret = -EFAULT;
-			goto bail;
-		}
-		consumed += copy;
-	}
-
-	/*
-	 * Make sure there is a uctxt when needed.
-	 */
-	if (uctxt_required && !uctxt) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	switch (cmd.type) {
-	case HFI1_CMD_ASSIGN_CTXT:
-		ret = assign_ctxt(fp, &uinfo);
-		if (ret < 0)
-			goto bail;
-		ret = setup_ctxt(fp);
-		if (ret)
-			goto bail;
-		ret = user_init(fp);
-		break;
-	case HFI1_CMD_CTXT_INFO:
-		ret = get_ctxt_info(fp, (void __user *)(unsigned long)
-				    user_val, cmd.len);
-		break;
-	case HFI1_CMD_USER_INFO:
-		ret = get_base_info(fp, (void __user *)(unsigned long)
-				    user_val, cmd.len);
-		break;
-	case HFI1_CMD_CREDIT_UPD:
-		if (uctxt && uctxt->sc)
-			sc_return_credits(uctxt->sc);
-		break;
-	case HFI1_CMD_TID_UPDATE:
-		ret = hfi1_user_exp_rcv_setup(fp, &tinfo);
-		if (!ret) {
-			/*
-			 * Copy the number of tidlist entries we used
-			 * and the length of the buffer we registered.
-			 * These fields are adjacent in the structure so
-			 * we can copy them at the same time.
-			 */
-			addr = (unsigned long)cmd.addr +
-				offsetof(struct hfi1_tid_info, tidcnt);
-			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-					 sizeof(tinfo.tidcnt) +
-					 sizeof(tinfo.length)))
-				ret = -EFAULT;
-		}
-		break;
-	case HFI1_CMD_TID_INVAL_READ:
-		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
-		if (ret)
-			break;
-		addr = (unsigned long)cmd.addr +
-			offsetof(struct hfi1_tid_info, tidcnt);
-		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-				 sizeof(tinfo.tidcnt)))
-			ret = -EFAULT;
-		break;
-	case HFI1_CMD_TID_FREE:
-		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
-		if (ret)
-			break;
-		addr = (unsigned long)cmd.addr +
-			offsetof(struct hfi1_tid_info, tidcnt);
-		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-				 sizeof(tinfo.tidcnt)))
-			ret = -EFAULT;
-		break;
-	case HFI1_CMD_RECV_CTRL:
-		ret = manage_rcvq(uctxt, fd->subctxt, (int)user_val);
-		break;
-	case HFI1_CMD_POLL_TYPE:
-		uctxt->poll_type = (typeof(uctxt->poll_type))user_val;
-		break;
-	case HFI1_CMD_ACK_EVENT:
-		ret = user_event_ack(uctxt, fd->subctxt, user_val);
-		break;
-	case HFI1_CMD_SET_PKEY:
-		if (HFI1_CAP_IS_USET(PKEY_CHECK))
-			ret = set_ctxt_pkey(uctxt, fd->subctxt, user_val);
-		else
-			ret = -EPERM;
-		break;
-	case HFI1_CMD_CTXT_RESET: {
-		struct send_context *sc;
-		struct hfi1_devdata *dd;
-
-		if (!uctxt || !uctxt->dd || !uctxt->sc) {
-			ret = -EINVAL;
-			break;
-		}
-		/*
-		 * There is no protection here. User level has to
-		 * guarantee that no one will be writing to the send
-		 * context while it is being re-initialized.
-		 * If user level breaks that guarantee, it will break
-		 * it's own context and no one else's.
-		 */
-		dd = uctxt->dd;
-		sc = uctxt->sc;
-		/*
-		 * Wait until the interrupt handler has marked the
-		 * context as halted or frozen. Report error if we time
-		 * out.
-		 */
-		wait_event_interruptible_timeout(
-			sc->halt_wait, (sc->flags & SCF_HALTED),
-			msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
-		if (!(sc->flags & SCF_HALTED)) {
-			ret = -ENOLCK;
-			break;
-		}
-		/*
-		 * If the send context was halted due to a Freeze,
-		 * wait until the device has been "unfrozen" before
-		 * resetting the context.
-		 */
-		if (sc->flags & SCF_FROZEN) {
-			wait_event_interruptible_timeout(
-				dd->event_queue,
-				!(ACCESS_ONCE(dd->flags) & HFI1_FROZEN),
-				msecs_to_jiffies(SEND_CTXT_HALT_TIMEOUT));
-			if (dd->flags & HFI1_FROZEN) {
-				ret = -ENOLCK;
-				break;
-			}
-			if (dd->flags & HFI1_FORCED_FREEZE) {
-				/*
-				 * Don't allow context reset if we are into
-				 * forced freeze
-				 */
-				ret = -ENODEV;
-				break;
-			}
-			sc_disable(sc);
-			ret = sc_enable(sc);
-			hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB,
-				     uctxt->ctxt);
-		} else {
-			ret = sc_restart(sc);
-		}
-		if (!ret)
-			sc_return_credits(sc);
-		break;
-	}
-	}
-
-	if (ret >= 0)
-		ret = consumed;
-bail:
-	return ret;
-}
-
 static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 {
 	struct hfi1_filedata *fd = kiocb->ki_filp->private_data;
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 9fd8725..5727c09 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -66,7 +66,7 @@
  * The major version changes when data structures change in an incompatible
  * way. The driver must be the same for initialization to succeed.
  */
-#define HFI1_USER_SWMAJOR 5
+#define HFI1_USER_SWMAJOR 6
 
 /*
  * Minor version differences are always compatible
@@ -260,12 +260,6 @@ struct hfi1_tid_info {
 	__u32 length;
 };
 
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
