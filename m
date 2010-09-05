From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] inifiband-diags: Support Voltaire switch ISR4200
Date: Sun, 05 Sep 2010 11:30:37 +0300
Message-ID: <4C83552D.2080007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Support Voltaire switch (ISR4200) grouping.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c |   49 ++++++++++++++++++++++++---
 infiniband-diags/libibnetdisc/src/chassis.h |    3 +-
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 7762d22..6bfc45b 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -50,9 +50,9 @@
 #include "internal.h"
 #include "chassis.h"
 
-static char *ChassisTypeStr[6] =
-{ "", "ISR9288", "ISR9096", "ISR2012", "ISR2004", "ISR4700" };
-static char *ChassisSlotTypeStr[4] = { "", "Line", "Spine", "SRBD" };
+static char *ChassisTypeStr[] =
+{ "", "ISR9288", "ISR9096", "ISR2012", "ISR2004", "ISR4700", "ISR4200" };
+static char *ChassisSlotTypeStr[] = { "", "Line", "Spine", "SRBD" };
 
 typedef struct chassis_scan {
 	ibnd_chassis_t *first_chassis;
@@ -72,7 +72,7 @@ char *ibnd_get_chassis_type(ibnd_node_t * node)
 		return NULL;
 	if (!node->chassis)
 		return NULL;
-	if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR4700_CT)
+	if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR4200_CT)
 		return NULL;
 	return ChassisTypeStr[node->ch_type];
 }
@@ -286,11 +286,18 @@ static int is_spine_4700x2(ibnd_node_t * n)
 	return (devid == VTR_DEVID_SFB4700X2);
 }
 
+static int is_spine_4200(ibnd_node_t * n)
+{
+	uint32_t devid = mad_get_field(n->info, 0, IB_NODE_DEVID_F);
+	return (devid == VTR_DEVID_SFB4200);
+}
+
 static int is_spine(ibnd_node_t * n)
 {
 	return (is_spine_9096(n) || is_spine_9288(n) ||
 		is_spine_2004(n) || is_spine_2012(n) ||
-		is_spine_4700(n) || is_spine_4700x2(n));
+		is_spine_4700(n) || is_spine_4700x2(n) ||
+		is_spine_4200(n));
 }
 
 static int is_line_24(ibnd_node_t * n)
@@ -376,6 +383,18 @@ char anafa_line_slot_2_sfb18x2[37] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
+/* LB slot = table[spine port] */
+char line_slot_2_sfb4200[37] = {
+	0,
+	1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5,
+	5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9};
+/* LB asic num = table[spine port] */
+char anafa_line_slot_2_sfb4200[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
+};
+
 /* IPR FCR modules connectivity while using sFB4 port as reference */
 char ipr_slot_2_sfb4_port[37] = {
 	0,
@@ -424,6 +443,18 @@ char anafa_spine18x2_slot_2_slb[37] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
+/* FB slot = table[line port] */
+char sfb4200_slot_2_slb[37] = {
+	0,
+	1, 1, 1, 1, 0, 0, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+/* FB asic = table[line port] */
+char anafa_sfb4200_slot_2_slb[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
 
 /*	reference                     { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 }; */
 
@@ -454,6 +485,10 @@ static int get_sfb_slot(ibnd_node_t * n, ibnd_port_t * lineport)
 		n->ch_type = ISR4700_CT;
 		n->ch_slotnum = spine18_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine18x2_slot_2_slb[lineport->portnum];
+	} else if (is_spine_4200(n)) {
+		n->ch_type = ISR4200_CT;
+		n->ch_slotnum = sfb4200_slot_2_slb[lineport->portnum];
+		n->ch_anafanum = anafa_sfb4200_slot_2_slb[lineport->portnum];
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   n->guid);
@@ -528,6 +563,10 @@ static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 		n->ch_type = ISR4700_CT;
 		n->ch_slotnum = line_slot_2_sfb18x2[spineport->portnum];
 		n->ch_anafanum = anafa_line_slot_2_sfb18x2[spineport->portnum];
+	} else if (is_spine_4200(spineport->node)) {
+		n->ch_type = ISR4200_CT;
+		n->ch_slotnum = line_slot_2_sfb4200[spineport->portnum];
+		n->ch_anafanum = anafa_line_slot_2_sfb4200[spineport->portnum];
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   spineport->node->guid);
diff --git a/infiniband-diags/libibnetdisc/src/chassis.h b/infiniband-diags/libibnetdisc/src/chassis.h
index f8e0ee2..004156e 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.h
+++ b/infiniband-diags/libibnetdisc/src/chassis.h
@@ -73,6 +73,7 @@
 #define VTR_DEVID_SLB4018		0x5a5b
 #define VTR_DEVID_SFB4700		0x5a5c
 #define VTR_DEVID_SFB4700X2		0x5a5d
+#define VTR_DEVID_SFB4200		0x5a60
 
 /* Vendor IDs (for chassis based systems) */
 #define VTR_VENDOR_ID			0x8f1	/* Voltaire */
@@ -82,7 +83,7 @@
 
 enum ibnd_chassis_type {
 	UNRESOLVED_CT, ISR9288_CT, ISR9096_CT, ISR2012_CT, ISR2004_CT,
-	ISR4700_CT
+	ISR4700_CT, ISR4200_CT
 };
 enum ibnd_chassis_slot_type { UNRESOLVED_CS, LINE_CS, SPINE_CS, SRBD_CS };
 
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
