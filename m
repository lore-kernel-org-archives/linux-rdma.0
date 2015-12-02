From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 13/13] staging/rdma/hfi1: Return immediately on error
Date: Wed,  2 Dec 2015 00:43:38 -0500
Message-ID: <1449035018-26396-14-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Now that the spinlock is not taken throughout hfi1_ioctl it is safe to return
early rather than setting a variable and falling through the switch.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Squashed removal of goto which is safe after this patch
	    staging/rdma/hfi1: remove unneeded goto done

 drivers/staging/rdma/hfi1/diag.c | 62 ++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 2f35834eb3de..cb6c5411bf87 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1011,20 +1011,16 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&link_info,
 				   (struct hfi1_link_info __user *)arg,
 				   sizeof(link_info)))
-			ret = -EFAULT;
+			return -EFAULT;
 
 		value = link_info.port_state;
 		index = link_info.port_number;
-		if (index > dd->num_pports - 1) {
-			ret = -EINVAL;
-			break;
-		}
+		if (index > dd->num_pports - 1)
+			return -EINVAL;
 
 		ppd = &dd->pport[index];
-		if (!ppd) {
-			ret = -EINVAL;
-			break;
-		}
+		if (!ppd)
+			return -EINVAL;
 
 		/* What we want to transition to */
 		phys_state = (value >> 4) & 0xF;
@@ -1048,8 +1044,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				dev_state = HLS_DN_DISABLE;
 				break;
 			default:
-				ret = -EINVAL;
-				goto done;
+				return -EINVAL;
 			}
 			ret = set_link_state(ppd, dev_state);
 			break;
@@ -1064,8 +1059,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				send_idle_sma(dd, SMA_IDLE_ACTIVE);
 			break;
 		default:
-			ret = -EINVAL;
-			break;
+			return -EINVAL;
 		}
 
 		if (ret)
@@ -1078,7 +1072,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			if (copy_from_user(&link_info,
 					   (struct hfi1_link_info __user *)arg,
 					   sizeof(link_info)))
-				ret = -EFAULT;
+				return -EFAULT;
 			index = link_info.port_number;
 		} else {
 			ret = __get_user(index, (int __user *)arg);
@@ -1086,16 +1080,13 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				break;
 		}
 
-		if (index > dd->num_pports - 1) {
-			ret = -EINVAL;
-			break;
-		}
+		if (index > dd->num_pports - 1)
+			return -EINVAL;
 
 		ppd = &dd->pport[index];
-		if (!ppd) {
-			ret = -EINVAL;
-			break;
-		}
+		if (!ppd)
+			return -EINVAL;
+
 		value = hfi1_ibphys_portstate(ppd);
 		value <<= 4;
 		value |= driver_lstate(ppd);
@@ -1112,7 +1103,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 						ppd->link_width_active;
 			if (copy_to_user((struct hfi1_link_info __user *)arg,
 					 &link_info, sizeof(link_info)))
-				ret = -EFAULT;
+				return -EFAULT;
 		} else {
 			ret = __put_user(value, (int __user *)arg);
 		}
@@ -1143,14 +1134,12 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		/* just copy command structure */
 		argp = (unsigned long *)arg;
 		if (copy_from_user(&filter_cmd, (void __user *)argp,
-				   sizeof(filter_cmd))) {
-			ret = -EFAULT;
-			break;
-		}
+				   sizeof(filter_cmd)))
+			return -EFAULT;
+
 		if (filter_cmd.opcode >= HFI1_MAX_FILTERS) {
 			pr_alert("Invalid opcode in request\n");
-			ret = -EINVAL;
-			break;
+			return -EINVAL;
 		}
 
 		snoop_dbg("Opcode %d Len %d Ptr %p",
@@ -1159,17 +1148,15 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 
 		filter_value = kcalloc(filter_cmd.length, sizeof(u8),
 				       GFP_KERNEL);
-		if (!filter_value) {
-			ret = -ENOMEM;
-			break;
-		}
+		if (!filter_value)
+			return -ENOMEM;
+
 		/* copy remaining data from userspace */
 		if (copy_from_user((u8 *)filter_value,
 				   (void __user *)filter_cmd.value_ptr,
 				   filter_cmd.length)) {
 			kfree(filter_value);
-			ret = -EFAULT;
-			break;
+			return -EFAULT;
 		}
 		/* Drain packets first */
 		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -1199,10 +1186,9 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			snoop_flags |= SNOOP_USE_METADATA;
 		break;
 	default:
-		ret = -ENOTTY;
-		break;
+		return -ENOTTY;
 	}
-done:
+
 	return ret;
 }
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
