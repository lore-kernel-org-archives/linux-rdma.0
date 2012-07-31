From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 12/27] opensm/osm_sa_mcmember_record.c: Dump MCMemberRecord in mcmr_query_mgrp
Date: Tue, 31 Jul 2012 19:04:40 +0300
Message-ID: <1343750695-28063-12-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 651bc95..e591801 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1405,6 +1405,11 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Dump of record\n");
+		osm_dump_mc_record_v2(sa->p_log, p_rcvd_rec, FILE_ID, OSM_LOG_DEBUG);
+	}
+
 	cl_qlist_init(&rec_list);
 
 	CL_PLOCK_ACQUIRE(sa->p_lock);
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
