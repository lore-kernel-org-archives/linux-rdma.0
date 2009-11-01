From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: optimization in zero mgid
 comparison
Date: Sun, 01 Nov 2009 11:37:04 +0200
Message-ID: <4AED56C0.4080006@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Small optimization in comparison to zero mgid in new
mcast group creation.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index dd01eed..18dc22c 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -731,7 +731,7 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 						OUT osm_mgrp_t ** pp_mgrp)
 {
 	ib_net16_t mlid;
-	unsigned zero_mgid, i;
+	unsigned zero_mgid = 1;
 	uint8_t scope;
 	ib_gid_t *p_mgid;
 	ib_api_status_t status = IB_SUCCESS;
@@ -740,12 +740,9 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 	OSM_LOG_ENTER(sa->p_log);

 	/* but what if the given MGID was not 0 ? */
-	zero_mgid = 1;
-	for (i = 0; i < sizeof(p_recvd_mcmember_rec->mgid); i++)
-		if (p_recvd_mcmember_rec->mgid.raw[i] != 0) {
-			zero_mgid = 0;
-			break;
-		}
+	if (p_recvd_mcmember_rec->mgid.unicast.prefix != 0 ||
+	    p_recvd_mcmember_rec->mgid.unicast.interface_id != 0)
+		zero_mgid = 0;

 	/*
 	   we allocate a new mlid number before we might use it
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
