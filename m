From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 3/7] staging/rdma/hfi1: Return early from hfi1_ioctl parameter errors
Date: Mon, 16 Nov 2015 17:32:36 -0500
Message-ID: <1447713160-24858-4-git-send-email-ira.weiny@intel.com>
References: <1447713160-24858-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447713160-24858-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rather than have a switch in a large else clause make the parameter checks
return immediately.

Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 348 +++++++++++++++++++--------------------
 1 file changed, 173 insertions(+), 175 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index c2839473f983..2bb857b2a103 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -979,17 +979,15 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	if (dd == NULL)
 		return -ENODEV;
 
-	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
-
 	mode_flag = dd->hfi1_snoop.mode_flag;
 
 	if (((_IOC_DIR(cmd) & _IOC_READ)
 	    && !access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd)))
 	    || ((_IOC_DIR(cmd) & _IOC_WRITE)
 	    && !access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd)))) {
-		ret = -EFAULT;
+		return -EFAULT;
 	} else if (!capable(CAP_SYS_ADMIN)) {
-		ret = -EPERM;
+		return -EPERM;
 	} else if ((mode_flag & HFI1_PORT_CAPTURE_MODE) &&
 		   (cmd != HFI1_SNOOP_IOCCLEARQUEUE) &&
 		   (cmd != HFI1_SNOOP_IOCCLEARFILTER) &&
@@ -1000,208 +998,208 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		 * 3.Set capture filter
 		 * Other are invalid.
 		 */
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
+
+	switch (cmd) {
+	case HFI1_SNOOP_IOCSETLINKSTATE:
+		snoop_dbg("HFI1_SNOOP_IOCSETLINKSTATE is not valid");
 		ret = -EINVAL;
-	} else {
-		switch (cmd) {
-		case HFI1_SNOOP_IOCSETLINKSTATE:
-			snoop_dbg("HFI1_SNOOP_IOCSETLINKSTATE is not valid");
+		break;
+
+	case HFI1_SNOOP_IOCSETLINKSTATE_EXTRA:
+		memset(&link_info, 0, sizeof(link_info));
+
+		if (copy_from_user(&link_info,
+				   (struct hfi1_link_info __user *)arg,
+				   sizeof(link_info)))
+			ret = -EFAULT;
+
+		value = link_info.port_state;
+		index = link_info.port_number;
+		if (index > dd->num_pports - 1) {
 			ret = -EINVAL;
 			break;
+		}
 
-		case HFI1_SNOOP_IOCSETLINKSTATE_EXTRA:
-			memset(&link_info, 0, sizeof(link_info));
+		ppd = &dd->pport[index];
+		if (!ppd) {
+			ret = -EINVAL;
+			break;
+		}
 
-			if (copy_from_user(&link_info,
-				(struct hfi1_link_info __user *)arg,
-				sizeof(link_info)))
-				ret = -EFAULT;
+		/* What we want to transition to */
+		phys_state = (value >> 4) & 0xF;
+		link_state = value & 0xF;
+		snoop_dbg("Setting link state 0x%x", value);
 
-			value = link_info.port_state;
-			index = link_info.port_number;
-			if (index > dd->num_pports - 1) {
-				ret = -EINVAL;
+		switch (link_state) {
+		case IB_PORT_NOP:
+			if (phys_state == 0)
 				break;
-			}
-
-			ppd = &dd->pport[index];
-			if (!ppd) {
-				ret = -EINVAL;
-				break;
-			}
-
-			/* What we want to transition to */
-			phys_state = (value >> 4) & 0xF;
-			link_state = value & 0xF;
-			snoop_dbg("Setting link state 0x%x", value);
-
-			switch (link_state) {
-			case IB_PORT_NOP:
-				if (phys_state == 0)
-					break;
-					/* fall through */
-			case IB_PORT_DOWN:
-				switch (phys_state) {
-				case 0:
-					dev_state = HLS_DN_DOWNDEF;
-					break;
-				case 2:
-					dev_state = HLS_DN_POLL;
-					break;
-				case 3:
-					dev_state = HLS_DN_DISABLE;
-					break;
-				default:
-					ret = -EINVAL;
-					goto done;
-				}
-				ret = set_link_state(ppd, dev_state);
+				/* fall through */
+		case IB_PORT_DOWN:
+			switch (phys_state) {
+			case 0:
+				dev_state = HLS_DN_DOWNDEF;
 				break;
-			case IB_PORT_ARMED:
-				ret = set_link_state(ppd, HLS_UP_ARMED);
-				if (!ret)
-					send_idle_sma(dd, SMA_IDLE_ARM);
+			case 2:
+				dev_state = HLS_DN_POLL;
 				break;
-			case IB_PORT_ACTIVE:
-				ret = set_link_state(ppd, HLS_UP_ACTIVE);
-				if (!ret)
-					send_idle_sma(dd, SMA_IDLE_ACTIVE);
+			case 3:
+				dev_state = HLS_DN_DISABLE;
 				break;
 			default:
 				ret = -EINVAL;
-				break;
-			}
-
-			if (ret)
-				break;
-			/* fall through */
-		case HFI1_SNOOP_IOCGETLINKSTATE:
-		case HFI1_SNOOP_IOCGETLINKSTATE_EXTRA:
-			if (cmd == HFI1_SNOOP_IOCGETLINKSTATE_EXTRA) {
-				memset(&link_info, 0, sizeof(link_info));
-				if (copy_from_user(&link_info,
-					(struct hfi1_link_info __user *)arg,
-					sizeof(link_info)))
-					ret = -EFAULT;
-				index = link_info.port_number;
-			} else {
-				ret = __get_user(index, (int __user *) arg);
-				if (ret !=  0)
-					break;
-			}
-
-			if (index > dd->num_pports - 1) {
-				ret = -EINVAL;
-				break;
-			}
-
-			ppd = &dd->pport[index];
-			if (!ppd) {
-				ret = -EINVAL;
-				break;
-			}
-			value = hfi1_ibphys_portstate(ppd);
-			value <<= 4;
-			value |= driver_lstate(ppd);
-
-			snoop_dbg("Link port | Link State: %d", value);
-
-			if ((cmd == HFI1_SNOOP_IOCGETLINKSTATE_EXTRA) ||
-			    (cmd == HFI1_SNOOP_IOCSETLINKSTATE_EXTRA)) {
-				link_info.port_state = value;
-				link_info.node_guid = cpu_to_be64(ppd->guid);
-				link_info.link_speed_active =
-							ppd->link_speed_active;
-				link_info.link_width_active =
-							ppd->link_width_active;
-				if (copy_to_user(
-					(struct hfi1_link_info __user *)arg,
-					&link_info, sizeof(link_info)))
-					ret = -EFAULT;
-			} else {
-				ret = __put_user(value, (int __user *)arg);
+				goto done;
 			}
+			ret = set_link_state(ppd, dev_state);
 			break;
-
-		case HFI1_SNOOP_IOCCLEARQUEUE:
-			snoop_dbg("Clearing snoop queue");
-			drain_snoop_list(&dd->hfi1_snoop.queue);
+		case IB_PORT_ARMED:
+			ret = set_link_state(ppd, HLS_UP_ARMED);
+			if (!ret)
+				send_idle_sma(dd, SMA_IDLE_ARM);
 			break;
-
-		case HFI1_SNOOP_IOCCLEARFILTER:
-			snoop_dbg("Clearing filter");
-			if (dd->hfi1_snoop.filter_callback) {
-				/* Drain packets first */
-				drain_snoop_list(&dd->hfi1_snoop.queue);
-				dd->hfi1_snoop.filter_callback = NULL;
-			}
-			kfree(dd->hfi1_snoop.filter_value);
-			dd->hfi1_snoop.filter_value = NULL;
+		case IB_PORT_ACTIVE:
+			ret = set_link_state(ppd, HLS_UP_ACTIVE);
+			if (!ret)
+				send_idle_sma(dd, SMA_IDLE_ACTIVE);
+			break;
+		default:
+			ret = -EINVAL;
 			break;
+		}
 
-		case HFI1_SNOOP_IOCSETFILTER:
-			snoop_dbg("Setting filter");
-			/* just copy command structure */
-			argp = (unsigned long *)arg;
-			if (copy_from_user(&filter_cmd, (void __user *)argp,
-					     sizeof(filter_cmd))) {
+		if (ret)
+			break;
+		/* fall through */
+	case HFI1_SNOOP_IOCGETLINKSTATE:
+	case HFI1_SNOOP_IOCGETLINKSTATE_EXTRA:
+		if (cmd == HFI1_SNOOP_IOCGETLINKSTATE_EXTRA) {
+			memset(&link_info, 0, sizeof(link_info));
+			if (copy_from_user(&link_info,
+					   (struct hfi1_link_info __user *)arg,
+					   sizeof(link_info)))
 				ret = -EFAULT;
+			index = link_info.port_number;
+		} else {
+			ret = __get_user(index, (int __user *)arg);
+			if (ret !=  0)
 				break;
-			}
-			if (filter_cmd.opcode >= HFI1_MAX_FILTERS) {
-				pr_alert("Invalid opcode in request\n");
-				ret = -EINVAL;
-				break;
-			}
+		}
 
-			snoop_dbg("Opcode %d Len %d Ptr %p",
-				   filter_cmd.opcode, filter_cmd.length,
-				   filter_cmd.value_ptr);
+		if (index > dd->num_pports - 1) {
+			ret = -EINVAL;
+			break;
+		}
 
-			filter_value = kcalloc(filter_cmd.length, sizeof(u8),
-					       GFP_KERNEL);
-			if (!filter_value) {
-				pr_alert("Not enough memory\n");
-				ret = -ENOMEM;
-				break;
-			}
-			/* copy remaining data from userspace */
-			if (copy_from_user((u8 *)filter_value,
-					(void __user *)filter_cmd.value_ptr,
-					filter_cmd.length)) {
-				kfree(filter_value);
+		ppd = &dd->pport[index];
+		if (!ppd) {
+			ret = -EINVAL;
+			break;
+		}
+		value = hfi1_ibphys_portstate(ppd);
+		value <<= 4;
+		value |= driver_lstate(ppd);
+
+		snoop_dbg("Link port | Link State: %d", value);
+
+		if ((cmd == HFI1_SNOOP_IOCGETLINKSTATE_EXTRA) ||
+		    (cmd == HFI1_SNOOP_IOCSETLINKSTATE_EXTRA)) {
+			link_info.port_state = value;
+			link_info.node_guid = cpu_to_be64(ppd->guid);
+			link_info.link_speed_active =
+						ppd->link_speed_active;
+			link_info.link_width_active =
+						ppd->link_width_active;
+			if (copy_to_user((struct hfi1_link_info __user *)arg,
+					 &link_info, sizeof(link_info)))
 				ret = -EFAULT;
-				break;
-			}
+		} else {
+			ret = __put_user(value, (int __user *)arg);
+		}
+		break;
+
+	case HFI1_SNOOP_IOCCLEARQUEUE:
+		snoop_dbg("Clearing snoop queue");
+		drain_snoop_list(&dd->hfi1_snoop.queue);
+		break;
+
+	case HFI1_SNOOP_IOCCLEARFILTER:
+		snoop_dbg("Clearing filter");
+		if (dd->hfi1_snoop.filter_callback) {
 			/* Drain packets first */
 			drain_snoop_list(&dd->hfi1_snoop.queue);
-			dd->hfi1_snoop.filter_callback =
-				hfi1_filters[filter_cmd.opcode].filter;
-			/* just in case we see back to back sets */
-			kfree(dd->hfi1_snoop.filter_value);
-			dd->hfi1_snoop.filter_value = filter_value;
+			dd->hfi1_snoop.filter_callback = NULL;
+		}
+		kfree(dd->hfi1_snoop.filter_value);
+		dd->hfi1_snoop.filter_value = NULL;
+		break;
 
+	case HFI1_SNOOP_IOCSETFILTER:
+		snoop_dbg("Setting filter");
+		/* just copy command structure */
+		argp = (unsigned long *)arg;
+		if (copy_from_user(&filter_cmd, (void __user *)argp,
+				   sizeof(filter_cmd))) {
+			ret = -EFAULT;
 			break;
-		case HFI1_SNOOP_IOCGETVERSION:
-			value = SNOOP_CAPTURE_VERSION;
-			snoop_dbg("Getting version: %d", value);
-			ret = __put_user(value, (int __user *)arg);
+		}
+		if (filter_cmd.opcode >= HFI1_MAX_FILTERS) {
+			pr_alert("Invalid opcode in request\n");
+			ret = -EINVAL;
 			break;
-		case HFI1_SNOOP_IOCSET_OPTS:
-			snoop_flags = 0;
-			ret = __get_user(value, (int __user *) arg);
-			if (ret != 0)
-				break;
+		}
 
-			snoop_dbg("Setting snoop option %d", value);
-			if (value & SNOOP_DROP_SEND)
-				snoop_flags |= SNOOP_DROP_SEND;
-			if (value & SNOOP_USE_METADATA)
-				snoop_flags |= SNOOP_USE_METADATA;
+		snoop_dbg("Opcode %d Len %d Ptr %p",
+			  filter_cmd.opcode, filter_cmd.length,
+			  filter_cmd.value_ptr);
+
+		filter_value = kcalloc(filter_cmd.length, sizeof(u8),
+				       GFP_KERNEL);
+		if (!filter_value) {
+			ret = -ENOMEM;
 			break;
-		default:
-			ret = -ENOTTY;
+		}
+		/* copy remaining data from userspace */
+		if (copy_from_user((u8 *)filter_value,
+				   (void __user *)filter_cmd.value_ptr,
+				   filter_cmd.length)) {
+			kfree(filter_value);
+			ret = -EFAULT;
 			break;
 		}
+		/* Drain packets first */
+		drain_snoop_list(&dd->hfi1_snoop.queue);
+		dd->hfi1_snoop.filter_callback =
+			hfi1_filters[filter_cmd.opcode].filter;
+		/* just in case we see back to back sets */
+		kfree(dd->hfi1_snoop.filter_value);
+		dd->hfi1_snoop.filter_value = filter_value;
+
+		break;
+	case HFI1_SNOOP_IOCGETVERSION:
+		value = SNOOP_CAPTURE_VERSION;
+		snoop_dbg("Getting version: %d", value);
+		ret = __put_user(value, (int __user *)arg);
+		break;
+	case HFI1_SNOOP_IOCSET_OPTS:
+		snoop_flags = 0;
+		ret = __get_user(value, (int __user *)arg);
+		if (ret != 0)
+			break;
+
+		snoop_dbg("Setting snoop option %d", value);
+		if (value & SNOOP_DROP_SEND)
+			snoop_flags |= SNOOP_DROP_SEND;
+		if (value & SNOOP_USE_METADATA)
+			snoop_flags |= SNOOP_USE_METADATA;
+		break;
+	default:
+		ret = -ENOTTY;
+		break;
 	}
 done:
 	spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
