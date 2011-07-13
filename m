From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Use forward extensible and safer way to compare mkey_lmc
 field in PortInfo attribute
Date: Wed, 13 Jul 2011 19:37:01 -0400
Message-ID: <4E1E2C1D.2070505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Rather than memcmp'ing the entire field, compare the two fields ignoring the
reserved field (which may some day be used). This makes SMs coded this
way better handle such a future spec expansion.

This change also gets this code closer to supporting M_KeyProtectBits.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index b713f33..7beb916 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -4543,7 +4543,7 @@ typedef struct _ib_port_info {
 	uint8_t link_width_active;
 	uint8_t state_info1;	/* LinkSpeedSupported and PortState */
 	uint8_t state_info2;	/* PortPhysState and LinkDownDefaultState */
-	uint8_t mkey_lmc;
+	uint8_t mkey_lmc;	/* M_KeyProtectBits and LMC */
 	uint8_t link_speed;	/* LinkSpeedEnabled and LinkSpeedActive */
 	uint8_t mtu_smsl;
 	uint8_t vl_cap;		/* VLCap and InitType */
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 5d0247a..4d59761 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -907,10 +907,12 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 			   sizeof(p_pi->link_width_enabled)))
 			send_set = TRUE;
 
-		/* M_KeyProtectBits are always zero */
+		/* M_KeyProtectBits are currently always zero */
 		p_pi->mkey_lmc = p_mgr->p_subn->opt.lmc;
-		if (memcmp(&p_pi->mkey_lmc, &p_old_pi->mkey_lmc,
-			   sizeof(p_pi->mkey_lmc)))
+		if (ib_port_info_get_lmc(p_pi) !=
+		    ib_port_info_get_lmc(p_old_pi) ||
+		    ib_port_info_get_mpb(p_pi) !=
+		    ib_port_info_get_mpb(p_old_pi))
 			send_set = TRUE;
 
 		/* calc new op_vls and mtu */
@@ -989,10 +991,12 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 
 		/* Determine if enhanced switch port 0 and if so set LMC */
 		if (osm_switch_sp0_is_lmc_capable(p_node->sw, p_mgr->p_subn)) {
-			/* M_KeyProtectBits are always zero */
+			/* M_KeyProtectBits are currently always zero */
 			p_pi->mkey_lmc = p_mgr->p_subn->opt.lmc;
-			if (memcmp(&p_pi->mkey_lmc, &p_old_pi->mkey_lmc,
-				   sizeof(p_pi->mkey_lmc)))
+			if (ib_port_info_get_lmc(p_pi) !=
+			    ib_port_info_get_lmc(p_old_pi) ||
+			    ib_port_info_get_mpb(p_pi) !=
+			    ib_port_info_get_mpb(p_old_pi))
 				send_set = TRUE;
 		}
 	}
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index e446e16..dd37eee 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -235,16 +235,14 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 				   sizeof(p_pi->m_key_lease_period)))
 				send_set = TRUE;
 
-			if (esp0 == FALSE)
-				p_pi->mkey_lmc = sm->p_subn->opt.lmc;
-			else {
-				if (sm->p_subn->opt.lmc_esp0)
-					p_pi->mkey_lmc = sm->p_subn->opt.lmc;
-				else
-					p_pi->mkey_lmc = 0;
-			}
-			if (memcmp(&p_pi->mkey_lmc, &p_old_pi->mkey_lmc,
-				   sizeof(p_pi->mkey_lmc)))
+			/* M_KeyProtectBits are currently always zero */
+			p_pi->mkey_lmc = 0;
+			if (esp0 == FALSE || sm->p_subn->opt.lmc_esp0)
+				ib_port_info_set_lmc(p_pi, sm->p_subn->opt.lmc);
+			if (ib_port_info_get_lmc(p_old_pi) !=
+			    ib_port_info_get_lmc(p_pi) ||
+			    ib_port_info_get_mpb(p_old_pi) !=
+			    ib_port_info_get_mpb(p_pi))
 				send_set = TRUE;
 
 			ib_port_info_set_timeout(p_pi,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
