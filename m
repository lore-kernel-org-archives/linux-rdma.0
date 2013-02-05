From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/6] opensm: Use IB_PATH_SELECTOR_EXACTLY rather than harded coded constant
Date: Tue,  5 Feb 2013 19:00:25 +0200
Message-ID: <1360083625-15981-3-git-send-email-alexne@mellanox.com>
References: <1360083625-15981-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360083625-15981-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn.c               |  4 ++--
 opensm/osm_sa_mcmember_record.c | 12 ++++++------
 opensm/osm_sa_path_record.c     |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index b4ee965..ca7703d 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -253,10 +253,10 @@ ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 	mc_rec.mgid = *mgid;
 
 	mc_rec.qkey = CL_HTON32(Q_Key);
-	mc_rec.mtu = mtu | (2 << 6);
+	mc_rec.mtu = mtu | (IB_PATH_SELECTOR_EXACTLY << 6);
 	mc_rec.tclass = tclass;
 	mc_rec.pkey = pkey;
-	mc_rec.rate = rate | (2 << 6);
+	mc_rec.rate = rate | (IB_PATH_SELECTOR_EXACTLY << 6);
 	mc_rec.pkt_life = p_subn->opt.subnet_timeout;
 	mc_rec.sl_flow_hop = ib_member_set_sl_flow_hop(sl, FlowLabel, hop_limit);
 	/* Scope in MCMemberRecord (if present) needs to be consistent with MGID */
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 6df1945..4a9ad71 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -207,11 +207,11 @@ static void mcmr_rcv_respond(IN osm_sa_t * sa, IN osm_madw_t * p_madw,
 
 	/* Fill in the mtu, rate, and packet lifetime selectors */
 	item->resp.mc_rec.mtu &= 0x3f;
-	item->resp.mc_rec.mtu |= 2 << 6;	/* exactly */
+	item->resp.mc_rec.mtu |= IB_PATH_SELECTOR_EXACTLY << 6;
 	item->resp.mc_rec.rate &= 0x3f;
-	item->resp.mc_rec.rate |= 2 << 6;	/* exactly */
+	item->resp.mc_rec.rate |= IB_PATH_SELECTOR_EXACTLY << 6;
 	item->resp.mc_rec.pkt_life &= 0x3f;
-	item->resp.mc_rec.pkt_life |= 2 << 6;	/* exactly */
+	item->resp.mc_rec.pkt_life |= IB_PATH_SELECTOR_EXACTLY << 6;
 
 	cl_qlist_init(&rec_list);
 	cl_qlist_insert_tail(&rec_list, &item->list_item);
@@ -862,11 +862,11 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 
 	/* the mcmember_record should have mtu_sel, rate_sel, and pkt_lifetime_sel = 2 */
 	(*pp_mgrp)->mcmember_rec.mtu &= 0x3f;
-	(*pp_mgrp)->mcmember_rec.mtu |= 2 << 6;	/* exactly */
+	(*pp_mgrp)->mcmember_rec.mtu |= IB_PATH_SELECTOR_EXACTLY << 6;
 	(*pp_mgrp)->mcmember_rec.rate &= 0x3f;
-	(*pp_mgrp)->mcmember_rec.rate |= 2 << 6;	/* exactly */
+	(*pp_mgrp)->mcmember_rec.rate |= IB_PATH_SELECTOR_EXACTLY << 6;
 	(*pp_mgrp)->mcmember_rec.pkt_life &= 0x3f;
-	(*pp_mgrp)->mcmember_rec.pkt_life |= 2 << 6;	/* exactly */
+	(*pp_mgrp)->mcmember_rec.pkt_life |= IB_PATH_SELECTOR_EXACTLY << 6;
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 08beb58..359cdf4 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1666,9 +1666,9 @@ static void pr_process_multicast(osm_sa_t * sa, const ib_sa_mad_t *sa_mad,
 	pr_item->resp.path_rec.pkey = mgrp->mcmember_rec.pkey;
 
 	/* MTU, rate, and packet lifetime should be exactly */
-	pr_item->resp.path_rec.mtu = (2 << 6) | mgrp->mcmember_rec.mtu;
-	pr_item->resp.path_rec.rate = (2 << 6) | mgrp->mcmember_rec.rate;
-	pr_item->resp.path_rec.pkt_life = (2 << 6) | mgrp->mcmember_rec.pkt_life;
+	pr_item->resp.path_rec.mtu = (IB_PATH_SELECTOR_EXACTLY << 6) | mgrp->mcmember_rec.mtu;
+	pr_item->resp.path_rec.rate = (IB_PATH_SELECTOR_EXACTLY << 6) | mgrp->mcmember_rec.rate;
+	pr_item->resp.path_rec.pkt_life = (IB_PATH_SELECTOR_EXACTLY << 6) | mgrp->mcmember_rec.pkt_life;
 
 	/* SL, Hop Limit, and Flow Label */
 	ib_member_get_sl_flow_hop(mgrp->mcmember_rec.sl_flow_hop,
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
