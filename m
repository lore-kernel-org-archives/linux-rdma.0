From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_prtn.c: removing TopSpin hack
Date: Tue, 7 Sep 2010 17:50:33 +0300
Message-ID: <4C865139.7010705@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Removing hack that was supposed to support TopSpin's non-compliant
join compmask for IPoIB v4 multicast group ff12:401b:<pkey>::1

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_prtn.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/opensm/opensm/osm_prtn.c b/opensm/opensm/osm_prtn.c
index f953876..4b087a4 100644
--- a/opensm/opensm/osm_prtn.c
+++ b/opensm/opensm/osm_prtn.c
@@ -167,21 +167,6 @@ static const ib_gid_t osm_ipoib_mgid = {
 	 },
 };

-/*
- * HACK: Until TS resolves their noncompliant join compmask,
- * we have to pre-define the MGID
- */
-static const ib_gid_t osm_ts_ipoib_mgid = {
-	{
-	 0xff,			/*  multicast field */
-	 0x12,			/*  non-permanent bit, link local scope */
-	 0x40, 0x1b,		/*  IPv4 signature */
-	 0xff, 0xff,		/*  16 bits of P_Key (to be filled in) */
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/*  48 bits of zeros */
-	 0x00, 0x00, 0x00, 0x01,	/*  32 bit IPv4 broadcast address */
-	 },
-};
-
 ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 				     osm_prtn_t * p, uint8_t rate, uint8_t mtu,
 				     uint8_t scope)
@@ -229,22 +214,6 @@ ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 		p->mgrp = p_mgrp;
 	}

-	/* workaround for TS */
-	/* FIXME: remove this upon TS fixes */
-	mc_rec.mgid = osm_ts_ipoib_mgid;
-	memcpy(&mc_rec.mgid.raw[4], &pkey, sizeof(pkey));
-	/* Scope in MCMemberRecord (if present) needs to be consistent with MGID */
-	mc_rec.scope_state = ib_member_set_scope_state(scope, IB_MC_REC_STATE_FULL_MEMBER);
-	ib_mgid_set_scope(&mc_rec.mgid, scope);
-
-	status = osm_mcmr_rcv_find_or_create_new_mgrp(p_sa, comp_mask, &mc_rec,
-						      &p_mgrp);
-	if (p_mgrp) {
-		p_mgrp->well_known = TRUE;
-		if (!p->mgrp)
-			p->mgrp = p_mgrp;
-	}
-
 	return status;
 }

-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
