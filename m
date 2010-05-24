From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/vendstat: code simplifications
Date: Mon, 24 May 2010 23:56:11 +0300
Message-ID: <20100524205611.GJ28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Simplify and consolidate the code by using helper function do_vendor().

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/vendstat.c |   94 ++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 49 deletions(-)

diff --git a/infiniband-diags/src/vendstat.c b/infiniband-diags/src/vendstat.c
index abff83a..0de5722 100644
--- a/infiniband-diags/src/vendstat.c
+++ b/infiniband-diags/src/vendstat.c
@@ -97,14 +97,12 @@ typedef struct {
 } is3_general_info_t;
 
 typedef struct {
-	uint32_t address;
-	uint32_t data;
-	uint32_t mask;
-} is3_record_t;
-
-typedef struct {
 	uint8_t reserved[8];
-	is3_record_t record[18];
+	struct is3_record {
+		uint32_t address;
+		uint32_t data;
+		uint32_t mask;
+	} record[18];
 } is3_config_space_t;
 
 #define COUNTER_GROUPS_NUM 2
@@ -127,23 +125,35 @@ typedef struct {
 	is4_group_select_t group_selects[COUNTER_GROUPS_NUM];
 } is4_config_counter_groups_t;
 
-void counter_groups_info(ib_portid_t * portid, int port)
+static int do_vendor(ib_portid_t *portid, struct ibmad_port *srcport,
+		     uint8_t class, uint8_t method, uint16_t attr_id,
+		     uint32_t attr_mod, void *data)
 {
-	char buf[1024];
 	ib_vendor_call_t call;
-	is4_counter_group_info_t *cg_info;
-	int i, num_cg;
 
 	memset(&call, 0, sizeof(call));
-	call.mgmt_class = IB_MLX_VENDOR_CLASS;
-	call.method = IB_MAD_METHOD_GET;
+	call.mgmt_class = class;
+	call.method = method;
 	call.timeout = ibd_timeout;
-	call.attrid = IB_MLX_IS4_COUNTER_GROUP_INFO;
-	call.mod = port;
+	call.attrid = attr_id;
+	call.mod = attr_mod;
+
+	if (!ib_vendor_call_via(data, portid, &call, srcport))
+		IBERROR("vendstat: method %u, attribute %u", method, attr_id);
+
+	return 0;
+}
+
+static void counter_groups_info(ib_portid_t * portid, int port)
+{
+	char buf[1024];
+	is4_counter_group_info_t *cg_info;
+	int i, num_cg;
 
 	/* Counter Group Info */
 	memset(&buf, 0, sizeof(buf));
-	if (!ib_vendor_call_via(&buf, portid, &call, srcport))
+	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
+		      IB_MLX_IS4_COUNTER_GROUP_INFO, port, buf))
 		IBERROR("counter group info query");
 
 	cg_info = (is4_counter_group_info_t *) & buf;
@@ -166,20 +176,12 @@ void counter_groups_info(ib_portid_t * portid, int port)
 
 static int cg0, cg1;
 
-void config_counter_groups(ib_portid_t * portid, int port)
+static void config_counter_groups(ib_portid_t * portid, int port)
 {
 	char buf[1024];
-	ib_vendor_call_t call;
 	is4_config_counter_groups_t *cg_config;
 
-	memset(&call, 0, sizeof(call));
-	call.mgmt_class = IB_MLX_VENDOR_CLASS;
-	call.attrid = IB_MLX_IS4_CONFIG_COUNTER_GROUP;
-	call.timeout = ibd_timeout;
-	call.mod = port;
 	/* configure counter groups for groups 0 and 1 */
-	call.method = IB_MAD_METHOD_SET;
-
 	memset(&buf, 0, sizeof(buf));
 	cg_config = (is4_config_counter_groups_t *) & buf;
 
@@ -188,14 +190,15 @@ void config_counter_groups(ib_portid_t * portid, int port)
 	cg_config->group_selects[0].group_select = (uint8_t) cg0;
 	cg_config->group_selects[1].group_select = (uint8_t) cg1;
 
-	if (!ib_vendor_call_via(&buf, portid, &call, srcport))
+	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_SET,
+		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf))
 		IBERROR("config counter group set");
 
 	/* get config counter groups */
 	memset(&buf, 0, sizeof(buf));
-	call.method = IB_MAD_METHOD_GET;
 
-	if (!ib_vendor_call_via(&buf, portid, &call, srcport))
+	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
+		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf))
 		IBERROR("config counter group query");
 }
 
@@ -234,10 +237,7 @@ int main(int argc, char **argv)
 	ib_portid_t portid = { 0 };
 	int port = 0;
 	char buf[1024];
-	ib_vendor_call_t call;
 	is3_general_info_t *gi;
-	is3_config_space_t *cs;
-	int i;
 
 	const struct ibdiag_opt opts[] = {
 		{"N", 'N', 0, NULL, "show IS3 or IS4 general information"},
@@ -299,22 +299,16 @@ int main(int argc, char **argv)
 	/* Would need a list of these and it might not be complete */
 	/* so for right now, punt on this */
 
-	memset(&call, 0, sizeof(call));
-	call.mgmt_class = IB_MLX_VENDOR_CLASS;
-	call.method = IB_MAD_METHOD_GET;
-	call.timeout = ibd_timeout;
-
-	memset(&buf, 0, sizeof(buf));
 	/* vendor ClassPortInfo is required attribute if class supported */
-	call.attrid = CLASS_PORT_INFO;
-	if (!ib_vendor_call_via(&buf, &portid, &call, srcport))
+	memset(&buf, 0, sizeof(buf));
+	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
+		      CLASS_PORT_INFO, 0, buf))
 		IBERROR("classportinfo query");
 
 	memset(&buf, 0, sizeof(buf));
-	call.attrid = IB_MLX_IS3_GENERAL_INFO;
-	if (!ib_vendor_call_via(&buf, &portid, &call, srcport))
-		IBERROR("vendstat");
 	gi = (is3_general_info_t *) & buf;
+	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
+		      IB_MLX_IS3_GENERAL_INFO, 0, gi))
 
 	if (general_info) {
 		/* dump IS3 or IS4 general info here */
@@ -336,20 +330,22 @@ int main(int argc, char **argv)
 	}
 
 	if (xmit_wait) {
+		is3_config_space_t *cs;
+		unsigned i;
+
 		if (ntohs(gi->hw_info.device_id) != IS3_DEVICE_ID)
 			IBERROR("Unsupported device ID 0x%x",
 				ntohs(gi->hw_info.device_id));
 
 		memset(&buf, 0, sizeof(buf));
-		call.attrid = IB_MLX_IS3_CONFIG_SPACE_ACCESS;
-		/* Limit of 18 accesses per MAD ? */
-		call.mod = 2 << 22 | 16 << 16;	/* 16 records */
 		/* Set record addresses for each port */
 		cs = (is3_config_space_t *) & buf;
 		for (i = 0; i < 16; i++)
 			cs->record[i].address =
 			    htonl(IB_MLX_IS3_PORT_XMIT_WAIT + ((i + 1) << 12));
-		if (!ib_vendor_call_via(&buf, &portid, &call, srcport))
+		if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS,
+			      IB_MAD_METHOD_GET, IB_MLX_IS3_CONFIG_SPACE_ACCESS,
+			      2 << 22 | 16 << 16, cs))
 			IBERROR("vendstat");
 
 		for (i = 0; i < 16; i++)
@@ -358,14 +354,14 @@ int main(int argc, char **argv)
 
 		/* Last 8 ports is another query */
 		memset(&buf, 0, sizeof(buf));
-		call.attrid = IB_MLX_IS3_CONFIG_SPACE_ACCESS;
-		call.mod = 2 << 22 | 8 << 16;	/* 8 records */
 		/* Set record addresses for each port */
 		cs = (is3_config_space_t *) & buf;
 		for (i = 0; i < 8; i++)
 			cs->record[i].address =
 			    htonl(IB_MLX_IS3_PORT_XMIT_WAIT + ((i + 17) << 12));
-		if (!ib_vendor_call_via(&buf, &portid, &call, srcport))
+		if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS,
+			      IB_MAD_METHOD_GET, IB_MLX_IS3_CONFIG_SPACE_ACCESS,
+			      2 << 22 | 8 << 16, cs))
 			IBERROR("vendstat");
 
 		for (i = 0; i < 8; i++)
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
