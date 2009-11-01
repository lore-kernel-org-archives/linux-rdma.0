From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: fsmall code optimization
Date: Mon, 02 Nov 2009 00:38:19 +0200
Message-ID: <4AEE0DDB.3050606@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Further optimization in comparison to zero mgid -
use existing function to check whether the mgid
is all zero.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 18dc22c..4ae6be6 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -731,7 +731,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 						OUT osm_mgrp_t ** pp_mgrp)
 {
 	ib_net16_t mlid;
-	unsigned zero_mgid = 1;
 	uint8_t scope;
 	ib_gid_t *p_mgid;
 	ib_api_status_t status = IB_SUCCESS;
@@ -739,11 +738,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,

 	OSM_LOG_ENTER(sa->p_log);

-	/* but what if the given MGID was not 0 ? */
-	if (p_recvd_mcmember_rec->mgid.unicast.prefix != 0 ||
-	    p_recvd_mcmember_rec->mgid.unicast.interface_id != 0)
-		zero_mgid = 0;
-
 	/*
 	   we allocate a new mlid number before we might use it
 	   for MGID ...
@@ -761,7 +755,7 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 		"Obtained new mlid 0x%X\n", cl_ntoh16(mlid));

 	/* we need to create the new MGID if it was not defined */
-	if (zero_mgid) {
+	if (!ib_gid_is_notzero(&p_recvd_mcmember_rec->mgid)) {
 		/* create a new MGID */
 		char gid_str[INET6_ADDRSTRLEN];

-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
