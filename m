From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibcc[config query].c: Make
 SwitchPortCongestionSetting IBA 1.3 compliant
Date: Mon, 31 Jul 2017 12:57:09 -0400
Message-ID: <e64732ac-b93f-cc12-3d01-d2a38363bd8a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IBA 1.3 supports 48 ports rather than 32 ports as at IBA 1.2.1
for SwitchCongestionSetting attribute.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibccconfig.c |  2 +-
 src/ibccquery.c  | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index 22b16db..64aa804 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -412,7 +412,7 @@ static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
 			 &cong_parm_marking_rate);
 
 	if (!cc_config_status_via(payload, rcv, dest, IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
-				  portnum / 32, 0, NULL, srcport, cckey))
+				  portnum / 48, 0, NULL, srcport, cckey))
 		return "switch port congestion setting config failed";
 
 	return NULL;
diff --git a/src/ibccquery.c b/src/ibccquery.c
index 39e45b7..95e553d 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -224,11 +224,11 @@ static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
 
 		memset(data, '\0', sizeof data);
 		if (!cc_query_status_via(data, dest, IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
-					 portnum / 32, 0, NULL, srcport, cckey))
+					 portnum / 48, 0, NULL, srcport, cckey))
 			return "switch port congestion setting query failed";
 
 		mad_dump_cc_switchportcongestionsettingelement(buf, sizeof buf,
-							       data + ((portnum % 32) * 4),
+							       data + ((portnum % 48) * 4),
 							       4);
 		printf("%s", buf);
 		return NULL;
@@ -236,7 +236,7 @@ static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
 
 	/* else get all port info */
 
-	maxblocks = numports / 32 + 1;
+	maxblocks = numports / 48 + 1;
 
 	for (i = 0; i < maxblocks; i++) {
 		memset(data, '\0', sizeof data);
@@ -244,8 +244,8 @@ static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
 					 i, 0, NULL, srcport, cckey))
 			return "switch port congestion setting query failed";
 
-		for (j = 0; j < 32 && outputcount <= numports; j++) {
-			printf("Port:............................%u\n", i * 32 + j);
+		for (j = 0; j < 48 && outputcount <= numports; j++) {
+			printf("Port:............................%u\n", i * 48 + j);
 			mad_dump_cc_switchportcongestionsettingelement(buf, sizeof buf,
 								       data + j * 4,
 								       4);
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
