From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] ibsim: Fix PerformanceSet parsing corner case
Date: Thu, 07 Feb 2013 16:45:01 -0800
Message-ID: <1360284301.17736.154.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Parse of attribute did not properly remove whitespace before it.  So

PerformanceSet "H-0002c90300325280" PortCounters.SymbolErrorCounter=3

would work but

PerformanceSet "H-0002c90300325280"  PortCounters.SymbolErrorCounter=3\

would not.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_cmd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index f44df93..83ad52d 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -911,7 +911,9 @@ static int do_perf_counter_set(FILE *f, char *line)
 		return -1;
 	}
 
-	strsep(&s, " ");
+	if (s && *s)
+		while (isspace(*s))
+			s++;
 	attr = strsep(&s, ".");
 	if(s == NULL)
 		goto format_error;
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
