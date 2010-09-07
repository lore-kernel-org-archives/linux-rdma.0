From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] osmtest/osmtest.c: handle timeouts in PR stress test
Date: Tue, 7 Sep 2010 18:01:42 +0300
Message-ID: <4C8653D6.1000201@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There was some "preparation" code for handling
PathRecord timeouts in SA stress codes: variable
num_timeouts exists, and it's value is checked.
What was missing is actually increasing the
num_timeouts value when timeout happens.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osmtest/osmtest.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index 7412ce7..b2ec3fa 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -2753,7 +2753,11 @@ static ib_api_status_t osmtest_stress_small_rmpp(IN osmtest_t * const p_osmt)

 		status = osmtest_stress_port_recs_small(p_osmt, &delta_recs,
 							&delta_queries);
-		if (status != IB_SUCCESS)
+		if (status == IB_TIMEOUT) {
+			num_timeouts++;
+			continue;
+		}
+		else if (status != IB_SUCCESS)
 			goto Exit;

 		num_recs += delta_recs;
@@ -2889,7 +2893,11 @@ static ib_api_status_t osmtest_stress_get_pr(IN osmtest_t * const p_osmt)
 		status = osmtest_stress_path_recs_by_lid(p_osmt,
 							 &delta_recs,
 							 &delta_queries);
-		if (status != IB_SUCCESS)
+		if (status == IB_TIMEOUT) {
+			num_timeouts++;
+			continue;
+		}
+		else if (status != IB_SUCCESS)
 			goto Exit;

 		num_recs += delta_recs;
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
