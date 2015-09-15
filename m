From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/hfi1: fix copy_to/from_user() error handling
Date: Tue, 15 Sep 2015 13:35:25 +0300
Message-ID: <20150915103525.GA20813@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <infinipath@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

copy_to/from_user() returns the number of bytes which we were not able
to copy.  It doesn't return an error code.

Also a couple places had a printk() on error and I removed that because
people can take advantage of it to fill /var/log/messages with spam.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This patch has some checkpatch warnings because the alignment is off.
That was a problem in the original code and needs to be fixed in a separate patch.

Also there is another bug:

drivers/staging/rdma/hfi1/diag.c:1160 hfi1_ioctl() error: scheduling with locks held: 'spin_lock:snoop_lock'

That function needs to be re-worked and simplified and technically I'm
still on vacation so I didn't address it.

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 6777d6b..ce01dee 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1012,11 +1012,10 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		case HFI1_SNOOP_IOCSETLINKSTATE_EXTRA:
 			memset(&link_info, 0, sizeof(link_info));
 
-			ret = copy_from_user(&link_info,
+			if (copy_from_user(&link_info,
 				(struct hfi1_link_info __user *)arg,
-				sizeof(link_info));
-			if (ret)
-				break;
+				sizeof(link_info)))
+				ret = -EFAULT;
 
 			value = link_info.port_state;
 			index = link_info.port_number;
@@ -1080,9 +1079,10 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		case HFI1_SNOOP_IOCGETLINKSTATE_EXTRA:
 			if (cmd == HFI1_SNOOP_IOCGETLINKSTATE_EXTRA) {
 				memset(&link_info, 0, sizeof(link_info));
-				ret = copy_from_user(&link_info,
+				if (copy_from_user(&link_info,
 					(struct hfi1_link_info __user *)arg,
-					sizeof(link_info));
+					sizeof(link_info)))
+					ret = -EFAULT;
 				index = link_info.port_number;
 			} else {
 				ret = __get_user(index, (int __user *) arg);
@@ -1114,9 +1114,10 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 							ppd->link_speed_active;
 				link_info.link_width_active =
 							ppd->link_width_active;
-				ret = copy_to_user(
+				if (copy_to_user(
 					(struct hfi1_link_info __user *)arg,
-					&link_info, sizeof(link_info));
+					&link_info, sizeof(link_info)))
+					ret = -EFAULT;
 			} else {
 				ret = __put_user(value, (int __user *)arg);
 			}
@@ -1142,10 +1143,9 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			snoop_dbg("Setting filter");
 			/* just copy command structure */
 			argp = (unsigned long *)arg;
-			ret = copy_from_user(&filter_cmd, (void __user *)argp,
-					     sizeof(filter_cmd));
-			if (ret < 0) {
-				pr_alert("Error copying filter command\n");
+			if (copy_from_user(&filter_cmd, (void __user *)argp,
+					     sizeof(filter_cmd))) {
+				ret = -EFAULT;
 				break;
 			}
 			if (filter_cmd.opcode >= HFI1_MAX_FILTERS) {
@@ -1167,12 +1167,11 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				break;
 			}
 			/* copy remaining data from userspace */
-			ret = copy_from_user((u8 *)filter_value,
+			if (copy_from_user((u8 *)filter_value,
 					(void __user *)filter_cmd.value_ptr,
-					filter_cmd.length);
-			if (ret < 0) {
+					filter_cmd.length)) {
 				kfree(filter_value);
-				pr_alert("Error copying filter data\n");
+				ret = -EFAULT;
 				break;
 			}
 			/* Drain packets first */
