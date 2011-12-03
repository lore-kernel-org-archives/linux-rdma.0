From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/src/ibccquery.c: Fix off by one output
	bug, ccti_limit is 0 based not 1 based
Date: Fri, 02 Dec 2011 16:00:10 -0800
Message-ID: <1322870410.5518.418.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 src/ibccquery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/ibccquery.c b/src/ibccquery.c
index a7fd79f..69db8d0 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -309,7 +309,7 @@ static char *congestion_control_table(ib_portid_t * dest, char **argv, int argc)
 	if (!limit)
 		return NULL;
 
-	for (i = 0; i < ((limit - 1)/64) + 1; i++) {
+	for (i = 0; i < (limit/64) + 1; i++) {
 
 		/* first query done */
 		if (i)
@@ -317,7 +317,7 @@ static char *congestion_control_table(ib_portid_t * dest, char **argv, int argc)
 					  i, 0, NULL, srcport, cckey))
 				return "congestion control table query failed";
 
-		for (j = 0; j < 64 && outputcount < limit; j++) {
+		for (j = 0; j < 64 && outputcount <= limit; j++) {
 			printf("Entry:...........................%u\n", i*64 + j);
 			mad_dump_cc_congestioncontroltableentry(buf, sizeof buf,
 								data + 4 + j * 2,
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
