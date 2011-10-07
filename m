From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery: add qkey to -g output
Date: Thu, 6 Oct 2011 17:24:30 -0700
Message-ID: <20111006172430.46425150.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index bdf5e9a..1f30d2a 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -344,12 +344,14 @@ static void dump_multicast_group_record(void *data)
 	ib_member_get_sl_flow_hop(p_mcmr->sl_flow_hop, &sl, NULL, NULL);
 	printf("MCMemberRecord group dump:\n"
 	       "\t\tMGID....................%s\n"
+	       "\t\tQ_Key...................0x%X\n"
 	       "\t\tMlid....................0x%X\n"
 	       "\t\tMtu.....................0x%X\n"
 	       "\t\tpkey....................0x%X\n"
 	       "\t\tRate....................0x%X\n"
 	       "\t\tSL......................0x%X\n",
 	       inet_ntop(AF_INET6, p_mcmr->mgid.raw, gid_str, sizeof gid_str),
+	       cl_ntoh32(p_mcmr->qkey),
 	       cl_ntoh16(p_mcmr->mlid),
 	       p_mcmr->mtu, cl_ntoh16(p_mcmr->pkey), p_mcmr->rate, sl);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
