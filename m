From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/20] IB/hfi1: Return SC2VL mappings to FM with VL15
 instead of ILLEGAL_VL
Date: Sun, 09 Apr 2017 10:16:09 -0700
Message-ID: <20170409171608.10579.69358.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

VL15 in the SC2VL table is used to indicate an invalid SC
for the FM, however, internally the driver remaps SCs from
VL15 to ILLEGAL_VL to prevent error counts. This mapping
confuses the FM when performing a sweep, making it return
a table mismatch error. Have SMA convert ILLEGAL_VL
to VL15 entries for the SC2VL table queries.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   41 +++++++++++++++++++++++---------------
 1 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index de34131..db5494d 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015-2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -1470,25 +1470,15 @@ static int __subn_set_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 	return __subn_get_opa_pkeytable(smp, am, data, ibdev, port, resp_len);
 }
 
-static int get_sc2vlt_tables(struct hfi1_devdata *dd, void *data)
-{
-	u64 *val = data;
-
-	*val++ = read_csr(dd, SEND_SC2VLT0);
-	*val++ = read_csr(dd, SEND_SC2VLT1);
-	*val++ = read_csr(dd, SEND_SC2VLT2);
-	*val++ = read_csr(dd, SEND_SC2VLT3);
-	return 0;
-}
-
 #define ILLEGAL_VL 12
 /*
  * filter_sc2vlt changes mappings to VL15 to ILLEGAL_VL (except
  * for SC15, which must map to VL15). If we don't remap things this
  * way it is possible for VL15 counters to increment when we try to
  * send on a SC which is mapped to an invalid VL.
+ * When getting the table convert ILLEGAL_VL back to VL15.
  */
-static void filter_sc2vlt(void *data)
+static void filter_sc2vlt(void *data, bool set)
 {
 	int i;
 	u8 *pd = data;
@@ -1496,8 +1486,14 @@ static void filter_sc2vlt(void *data)
 	for (i = 0; i < OPA_MAX_SCS; i++) {
 		if (i == 15)
 			continue;
-		if ((pd[i] & 0x1f) == 0xf)
-			pd[i] = ILLEGAL_VL;
+
+		if (set) {
+			if ((pd[i] & 0x1f) == 0xf)
+				pd[i] = ILLEGAL_VL;
+		} else {
+			if ((pd[i] & 0x1f) == ILLEGAL_VL)
+				pd[i] = 0xf;
+		}
 	}
 }
 
@@ -1505,7 +1501,7 @@ static int set_sc2vlt_tables(struct hfi1_devdata *dd, void *data)
 {
 	u64 *val = data;
 
-	filter_sc2vlt(data);
+	filter_sc2vlt(data, true);
 
 	write_csr(dd, SEND_SC2VLT0, *val++);
 	write_csr(dd, SEND_SC2VLT1, *val++);
@@ -1517,6 +1513,19 @@ static int set_sc2vlt_tables(struct hfi1_devdata *dd, void *data)
 	return 0;
 }
 
+static int get_sc2vlt_tables(struct hfi1_devdata *dd, void *data)
+{
+	u64 *val = (u64 *)data;
+
+	*val++ = read_csr(dd, SEND_SC2VLT0);
+	*val++ = read_csr(dd, SEND_SC2VLT1);
+	*val++ = read_csr(dd, SEND_SC2VLT2);
+	*val++ = read_csr(dd, SEND_SC2VLT3);
+
+	filter_sc2vlt((u64 *)data, false);
+	return 0;
+}
+
 static int __subn_get_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
 				   struct ib_device *ibdev, u8 port,
 				   u32 *resp_len)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
