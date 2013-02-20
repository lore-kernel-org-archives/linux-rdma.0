From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_qos_policy.c: fix memory leak when parsing policy
 file
Date: Wed, 20 Feb 2013 14:03:01 -0500
Message-ID: <51251DE5.2090703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


We need to free the pkey_range_arr before parsing the qos file.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index 1751849..e61392f 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -283,15 +283,16 @@ void
osm_qos_policy_qos_level_destroy(osm_qos_level_t * p)
 	if (!p)
 		return;

-	if (p->name)
-		free(p->name);
-	if (p->use)
-		free(p->use);
+	free(p->name);
+	free(p->use);

 	for (i = 0; i < p->path_bits_range_len; i++)
 		free(p->path_bits_range_arr[i]);
-	if (p->path_bits_range_arr)
-		free(p->path_bits_range_arr);
+	free(p->path_bits_range_arr);
+
+	for(i = 0; i < p->pkey_range_len; i++)
+		free((p->pkey_range_arr[i]));
+	free(p->pkey_range_arr);

 	free(p);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
