From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH for infiniband-diags] get_lid_from_name(): Remove an unused
 variable
Date: Sun, 18 Aug 2013 10:57:07 +0200
Message-ID: <52108C63.9080101@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that the following compiler warning is triggered:

src/saquery.c:869:18: warning: variable 'p_ni' set but not used [-Wunused-but-set-variable]

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/saquery.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index e4fbc87..d6fd017 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -866,7 +866,6 @@ static int get_and_dump_all_records(struct sa_handle * h, uint16_t attr_id,
 static int get_lid_from_name(struct sa_handle * h, const char *name, uint16_t * lid)
 {
 	ib_node_record_t *node_record = NULL;
-	ib_node_info_t *p_ni = NULL;
 	unsigned i;
 	int ret;
 	struct sa_query_result result;
@@ -878,7 +877,6 @@ static int get_lid_from_name(struct sa_handle * h, const char *name, uint16_t *
 	ret = ENONET;
 	for (i = 0; i < result.result_cnt; i++) {
 		node_record = sa_get_query_rec(result.p_result_madw, i);
-		p_ni = &(node_record->node_info);
 		if (name
 		    && strncmp(name, (char *)node_record->node_desc.description,
 			       sizeof(node_record->node_desc.description)) ==
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
