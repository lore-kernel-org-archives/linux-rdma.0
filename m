From: "Huang, Parry W." <huang32-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] ibsim/sim_cmd.c: Fixed help output for dump command
Date: Thu, 31 May 2012 15:05:44 -0700
Message-ID: <94B19291-0F4A-4AF1-BF1F-D09815D5660D@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In dump_help, fixed help output of the dump command to correspond with the rest of the response.

Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 6d3a893..2da8c28 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -799,7 +799,7 @@ static int dump_help(FILE * f)
 	fprintf(f, "sim> Commands:\n");
 	fprintf(f, "\t!<filename> - run commands from the file\n");
 	fprintf(f, "\tStart network\n");
-	fprintf(f, "\tDump [nodeid] (def all network)\n");
+        fprintf(f, "\tDump [\"nodeid\"] : dump node information in network\n");
 	fprintf(f, "\tRoute <from-lid> <to-lid>\n");
 	fprintf(f, "\tLink \"nodeid\"[port] \"remoteid\"[port]\n");
 	fprintf(f, "\tReLink \"nodeid\" : restore previously unconnected link(s) of the node\n");
-- 
1.7.1--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
