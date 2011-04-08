From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3] infiniband-diags: saquery, properly free mad when no
 results are found
Date: Fri, 8 Apr 2011 13:45:59 -0700
Message-ID: <20110408134559.4856be60.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Subject: [PATCH 2/3] infiniband-diags: saquery, properly free mad when no results are found

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index d7c8e6f..9314e4f 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -876,11 +876,15 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 	if (ret)
 		return ret;
 
-	if (result.result_cnt == 0)
-		return ENODEV;
+	if (result.result_cnt == 0) {
+		ret = ENODEV;
+		goto Exit;
+	}
 
 	dump_results(&result, dump_func);
 
+Exit:
+	return_mad();
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
