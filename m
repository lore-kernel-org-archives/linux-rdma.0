From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_sa_mcmember_record.c validate_requested_mgid returning
 boolean
Date: Wed, 26 Jun 2013 01:18:13 -0700 (PDT)
Message-ID: <0f65d8e3-ddef-4d04-b00c-9b08038e1df2@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changed return type in function prototype to match actual return type.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index dcc43af..1699baa 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -554,9 +554,8 @@ static boolean_t validate_delete(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
  *    scope bits set. (EZ: the idea here is that SA created MGIDs are the
  *    only source for this signature with link-local scope)
  */
-static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
-					       IN const ib_member_rec_t *
-					       p_mcm_rec)
+static boolean_t validate_requested_mgid(IN osm_sa_t * sa,
+					 IN const ib_member_rec_t * p_mcm_rec)
 {
 	uint16_t signature;
 	boolean_t valid = TRUE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
