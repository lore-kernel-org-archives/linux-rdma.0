From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibccquery.c: Account for enhanced switch
 port 0 in SwitchPortCongestionSetting handling
Date: Fri, 09 Jan 2015 10:17:30 -0500
Message-ID: <54AFF10A.4050806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enhanced switch port 0 can support CC (indicated in CC ClassPortInfo:CapabilityMask.EnhancedPort0CC).

portnum 0 is a valid port number and offsets should be calculated based on port 0
rather than port 1.

Also, fix some error messages to indicate switch port congestion setting
rather then switch congestion setting failure.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibccquery.c b/src/ibccquery.c
index ac8bca2..39e45b7 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -224,11 +224,11 @@ static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
 
 		memset(data, '\0', sizeof data);
 		if (!cc_query_status_via(data, dest, IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
-					 (portnum - 1) / 32, 0, NULL, srcport, cckey))
-			return "switch congestion setting query failed";
+					 portnum / 32, 0, NULL, srcport, cckey))
+			return "switch port congestion setting query failed";
 
 		mad_dump_cc_switchportcongestionsettingelement(buf, sizeof buf,
-							       data + (((portnum % 32) - 1) * 4),
+							       data + ((portnum % 32) * 4),
 							       4);
 		printf("%s", buf);
 		return NULL;
@@ -236,16 +236,16 @@ static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
 
 	/* else get all port info */
 
-	maxblocks = ((numports - 1) / 32) + 1;
+	maxblocks = numports / 32 + 1;
 
 	for (i = 0; i < maxblocks; i++) {
 		memset(data, '\0', sizeof data);
 		if (!cc_query_status_via(data, dest, IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
 					 i, 0, NULL, srcport, cckey))
-			return "switch congestion setting query failed";
+			return "switch port congestion setting query failed";
 
-		for (j = 0; j < 32 && outputcount < numports; j++) {
-			printf("Port:............................%u\n", i * 32 + j + 1);
+		for (j = 0; j < 32 && outputcount <= numports; j++) {
+			printf("Port:............................%u\n", i * 32 + j);
 			mad_dump_cc_switchportcongestionsettingelement(buf, sizeof buf,
 								       data + j * 4,
 								       4);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
