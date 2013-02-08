From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] ibsim: Output error on bad input to PerformanceSet
Date: Thu, 07 Feb 2013 16:45:12 -0800
Message-ID: <1360284312.17736.155.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_cmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 83ad52d..4822a0b 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -1086,6 +1086,7 @@ static int do_perf_counter_set(FILE *f, char *line)
 		pc->vl_xmit_wait_counters.PortVLXmitWait[vl] =
 			check_limit(&value, GS_PERF_VL_XMIT_WAIT_COUNTERS_LIMIT);
 	} else {
+		fprintf(f, "# attribute %s not found\n", attr);
 		return -1;
 	}
 	fprintf(f, "%s.%s has been set to %"PRIu64"\n", attr, field, value);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
