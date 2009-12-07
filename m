From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: trivial optimization
Date: Mon, 07 Dec 2009 12:26:20 +0200
Message-ID: <4B1CD84C.3060902@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Small optimization: spare the function call if this is not proxy join.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index a4d86e3..07aeb6c 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -1013,7 +1013,9 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}

-	if (!osm_physp_share_pkey(sa->p_log, p_physp, p_request_physp)) {
+	proxy = (p_physp != p_request_physp);
+
+	if (proxy && !osm_physp_share_pkey(sa->p_log, p_physp, p_request_physp)) {
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 			"Port and requester don't share pkey\n");
@@ -1021,8 +1023,6 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}

-	proxy = (p_physp != p_request_physp);
-
 	ib_member_get_scope_state(p_recvd_mcmember_rec->scope_state, NULL,
 				  &join_state);

-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
