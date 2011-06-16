From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery; reuse dump_one_mcmember_record
 function
Date: Thu, 16 Jun 2011 11:10:24 -0700
Message-ID: <20110616111024.fde795bc.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 2 Jun 2011 00:17:21 -0700
Subject: [PATCH] infiniband-diags: saquery; reuse dump_one_mcmember_record function

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 7933fec..e1ab7dd 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -486,7 +486,6 @@ static void dump_multicast_group_record(void *data)
 static void dump_multicast_member_record(void *data)
 {
 	char gid_str[INET6_ADDRSTRLEN];
-	char gid_str2[INET6_ADDRSTRLEN];
 	ib_member_rec_t *p_mcmr = data;
 	uint16_t mlid = cl_ntoh16(p_mcmr->mlid);
 	unsigned i = 0;
@@ -512,19 +511,8 @@ static void dump_multicast_member_record(void *data)
 			       inet_ntop(AF_INET6, p_mcmr->port_gid.raw,
 					 gid_str, sizeof gid_str), node_name);
 	} else {
-		printf("MCMemberRecord member dump:\n"
-		       "\t\tMGID....................%s\n"
-		       "\t\tMlid....................0x%X\n"
-		       "\t\tPortGid.................%s\n"
-		       "\t\tScopeState..............0x%X\n"
-		       "\t\tProxyJoin...............0x%X\n"
-		       "\t\tNodeDescription.........%s\n",
-		       inet_ntop(AF_INET6, p_mcmr->mgid.raw, gid_str,
-				 sizeof gid_str),
-		       cl_ntoh16(p_mcmr->mlid),
-		       inet_ntop(AF_INET6, p_mcmr->port_gid.raw,
-				 gid_str2, sizeof gid_str2),
-		       p_mcmr->scope_state, p_mcmr->proxy_join, node_name);
+		dump_one_mcmember_record(data);
+		printf("\t\tNodeDescription.........%s\n", node_name);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
