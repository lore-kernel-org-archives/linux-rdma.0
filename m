From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm/osm_lid_mgr.c: Allow switch lids to be non LMC aligned
Date: Tue, 29 Jun 2010 16:49:25 +0300
Message-ID: <4C29F9E5.6030905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fixes a bug of failover between SM's that are running on a switch.
Both have lids below LMC start lid (equals to 2^LMC - 1)
In case of failover the LID range between 1 and start lid was considered not free
and their (switch's) lids were changed.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_lid_mgr.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 97b1de6..5d0247a 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -563,10 +563,6 @@ static boolean_t lid_mgr_is_range_not_persistent(IN osm_lid_mgr_t * p_mgr,
 						 IN uint16_t num_lids)
 {
 	uint16_t i;
-	uint8_t start_lid = (uint8_t) (1 << p_mgr->p_subn->opt.lmc);
-
-	if (lid < start_lid)
-		return FALSE;
 
 	for (i = lid; i < lid + num_lids; i++)
 		if (p_mgr->used_lids[i])
-- 
1.5.3.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
