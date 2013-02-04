From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_qos_policy.c: fix segmentation fault on osm_qos_policy_match_rule_destroy (osm_qos_policy.c)
Date: Mon,  4 Feb 2013 15:20:02 +0200
Message-ID: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_qos_policy.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index c8526b9..ad5eaa0 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -373,20 +373,23 @@ void osm_qos_policy_match_rule_destroy(osm_qos_match_rule_t * p)
 	if (p->use)
 		free(p->use);
 
-	for (i = 0; i < p->service_id_range_len; i++)
-		free(p->service_id_range_arr[i]);
-	if (p->service_id_range_arr)
+	if (p->service_id_range_arr) {
+		for (i = 0; i < p->service_id_range_len; i++)
+			free(p->service_id_range_arr[i]);
 		free(p->service_id_range_arr);
+	}
 
-	for (i = 0; i < p->qos_class_range_len; i++)
-		free(p->qos_class_range_arr[i]);
-	if (p->qos_class_range_arr)
+	if (p->qos_class_range_arr) {
+		for (i = 0; i < p->qos_class_range_len; i++)
+			free(p->qos_class_range_arr[i]);
 		free(p->qos_class_range_arr);
+	}
 
-	for (i = 0; i < p->pkey_range_len; i++)
-		free(p->pkey_range_arr[i]);
-	if (p->pkey_range_arr)
+	if (p->pkey_range_arr) {
+		for (i = 0; i < p->pkey_range_len; i++)
+			free(p->pkey_range_arr[i]);
 		free(p->pkey_range_arr);
+	}
 
 	cl_list_apply_func(&p->source_list, __free_single_element, NULL);
 	cl_list_remove_all(&p->source_list);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
