From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/2] scsi: use kernel's '%pM' format option to print MAC
Date: Thu, 25 Aug 2011 10:26:26 +0300
Message-ID: <224be049a8c395b8cc368559c5f5bf7d11016f42.1314257148.git.andriy.shevchenko@linux.intel.com>
References: <39b2e50def30f0941aa1db2eab751f56fa85a652.1314257148.git.andriy.shevchenko@linux.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <39b2e50def30f0941aa1db2eab751f56fa85a652.1314257148.git.andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
In-Reply-To: <39b2e50def30f0941aa1db2eab751f56fa85a652.1314257148.git.andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
References: <39b2e50def30f0941aa1db2eab751f56fa85a652.1314257148.git.andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/scsi/fnic/vnic_dev.c  |   10 ++--------
 drivers/scsi/qla4xxx/ql4_nx.c |    8 ++------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index b576be7..0cb8ad0 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -499,10 +499,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		printk(KERN_ERR "Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
@@ -517,10 +514,7 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		printk(KERN_ERR "Can't del addr [%pM], %d\n", addr, err);
 }
 
 int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 52a1063..950749f 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2267,12 +2267,8 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 	memcpy(ha->serial_number, &sys_info->serial_number,
 	    min(sizeof(ha->serial_number), sizeof(sys_info->serial_number)));
 
-	DEBUG2(printk("scsi%ld: %s: "
-	    "mac %02x:%02x:%02x:%02x:%02x:%02x "
-	    "serial %s\n", ha->host_no, __func__,
-	    ha->my_mac[0], ha->my_mac[1], ha->my_mac[2],
-	    ha->my_mac[3], ha->my_mac[4], ha->my_mac[5],
-	    ha->serial_number));
+	DEBUG2(printk("scsi%ld: %s: mac %pM serial %s\n", ha->host_no, __func__,
+		ha->my_mac, ha->serial_number));
 
 	status = QLA_SUCCESS;
 
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
