From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo query
Date: Tue,  9 Aug 2016 11:17:18 -0400
Message-ID: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The monitor values from bytes 22 through 81 of the QSFP memory space
(SFF 8636) are dynamic and serving them out of the QSFP memory cache
maintained by the driver provides stale data to the CableInfo SMA query.
This patch refreshes the dynamic values from the QSFP memory on request
and overwrites the stale data from the cache for the overlap between the
requested range and the monitor range.


Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qsfp.c | 32 ++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/qsfp.h |  3 +++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
index a207717ade2a..4e95ad810847 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.c
+++ b/drivers/infiniband/hw/hfi1/qsfp.c
@@ -706,8 +706,8 @@ int get_cable_info(struct hfi1_devdata *dd, u32 port_num, u32 addr, u32 len,
 		   u8 *data)
 {
 	struct hfi1_pportdata *ppd;
-	u32 excess_len = 0;
-	int ret = 0;
+	u32 excess_len = len;
+	int ret = 0, offset = 0;
 
 	if (port_num > dd->num_pports || port_num < 1) {
 		dd_dev_info(dd, "%s: Invalid port number %d\n",
@@ -740,6 +740,34 @@ int get_cable_info(struct hfi1_devdata *dd, u32 port_num, u32 addr, u32 len,
 	}
 
 	memcpy(data, &ppd->qsfp_info.cache[addr], len);
+
+	if (addr <= QSFP_MONITOR_VAL_END &&
+	    (addr + len) >= QSFP_MONITOR_VAL_START) {
+		/* Overlap with the dynamic channel monitor range */
+		if (addr < QSFP_MONITOR_VAL_START) {
+			if (addr + len <= QSFP_MONITOR_VAL_END)
+				len = addr + len - QSFP_MONITOR_VAL_START;
+			else
+				len = QSFP_MONITOR_RANGE;
+			offset = QSFP_MONITOR_VAL_START - addr;
+			addr = QSFP_MONITOR_VAL_START;
+		} else if (addr == QSFP_MONITOR_VAL_START) {
+			offset = 0;
+			if (addr + len > QSFP_MONITOR_VAL_END)
+				len = QSFP_MONITOR_RANGE;
+		} else {
+			offset = 0;
+			if (addr + len > QSFP_MONITOR_VAL_END)
+				len = QSFP_MONITOR_VAL_END - addr + 1;
+		}
+		/* Refresh the values of the dynamic monitors from the cable */
+		ret = one_qsfp_read(ppd, dd->hfi1_id, addr, data + offset, len);
+		if (ret != len) {
+			ret = -EAGAIN;
+			goto set_zeroes;
+		}
+	}
+
 	return 0;
 
 set_zeroes:
diff --git a/drivers/infiniband/hw/hfi1/qsfp.h b/drivers/infiniband/hw/hfi1/qsfp.h
index 69275ebd9597..36cf52359848 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.h
+++ b/drivers/infiniband/hw/hfi1/qsfp.h
@@ -74,6 +74,9 @@
 /* Defined fields that Intel requires of qualified cables */
 /* Byte 0 is Identifier, not checked */
 /* Byte 1 is reserved "status MSB" */
+#define QSFP_MONITOR_VAL_START 22
+#define QSFP_MONITOR_VAL_END 81
+#define QSFP_MONITOR_RANGE (QSFP_MONITOR_VAL_END - QSFP_MONITOR_VAL_START + 1)
 #define QSFP_TX_CTRL_BYTE_OFFS 86
 #define QSFP_PWR_CTRL_BYTE_OFFS 93
 #define QSFP_CDR_CTRL_BYTE_OFFS 98
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
