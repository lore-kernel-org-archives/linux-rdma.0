From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibsim/sim_cmd.c: Allow error command on attributes for switch
 port 0
Date: Mon, 25 Jun 2012 10:26:24 -0400
Message-ID: <4FE87510.8070003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 6d3a893..81e9bfa 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -288,7 +288,7 @@ static int do_seterror(FILE * f, char *line)
 	char *s = line;
 	char *nodeid = 0, name[NAMELEN], *sp, *orig = 0;
 	int portnum = -1;	// def - all ports
-	int numports, set = 0, rate = 0;
+	int startport, numports, set = 0, rate = 0;
 	uint16_t attr = 0;
 
 	if (strsep(&s, "\""))
@@ -309,8 +309,12 @@ static int do_seterror(FILE * f, char *line)
 	}
 
 	if (sp) {
+		if (node->type == SWITCH_NODE)
+			startport = 0;
+		else
+			startport = 1;
 		portnum = strtoul(sp, 0, 0);
-		if (portnum < 1 || portnum > node->numports) {
+		if (portnum < startport || portnum > node->numports) {
 			fprintf(f, "# bad port number %d at nodeid \"%s\"\n",
 				portnum, nodeid);
 			return -1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
