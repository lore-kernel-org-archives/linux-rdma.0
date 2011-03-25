From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Proper mfttop initialization when starting/restarting
Date: Sat, 26 Mar 2011 00:04:17 +0200
Message-ID: <4D8D1161.7020900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Rather than setting mfttop to 0xbfff first time, initialize (indicated
by first_time_master_sweep) based on whether or not SA DB is being loaded.
If it's being loaded, get mfttop from there (based on max MLID in the
SA DB). Otherwise, it's set to 0 which makes multicast behave as it did
prior to there being an mfttop (meaning any MC routes are "honored".

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/include/opensm/osm_sm.h b/opensm/include/opensm/osm_sm.h
index 50e0dd9..dae68da 100644
--- a/opensm/include/opensm/osm_sm.h
+++ b/opensm/include/opensm/osm_sm.h
@@ -126,6 +126,7 @@ typedef struct osm_sm {
      cl_dispatcher_t *p_disp;
      cl_plock_t *p_lock;
      atomic32_t sm_trans_id;
+    uint16_t mlids_init_max;
      unsigned mlids_req_max;
      uint8_t *mlids_req;
      osm_sm_mad_ctrl_t mad_ctrl;
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index bdfef40..a023ae2 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1,6 +1,6 @@
  /*
   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
   * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
@@ -1022,7 +1022,7 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * sm, 
IN osm_switch_t * p_sw)
      osm_madw_context_t context;
      ib_api_status_t status;
      ib_switch_info_t si;
-    uint16_t mcast_top;
+    ib_net16_t mcast_top;

      OSM_LOG_ENTER(sm->p_log);

@@ -1041,11 +1041,15 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * 
sm, IN osm_switch_t * p_sw)
             Set the top of the multicast forwarding table.
           */
          si = p_sw->switch_info;
-        if (p_tbl->max_block_in_use == -1)
-            mcast_top = cl_hton16(IB_LID_MCAST_START_HO - 1);
-        else
-            mcast_top = cl_hton16(IB_LID_MCAST_START_HO +
-                          (p_tbl->max_block_in_use + 1) * 
IB_MCAST_BLOCK_SIZE - 1);
+        if (sm->p_subn->first_time_master_sweep == TRUE)
+            mcast_top = cl_hton16(sm->mlids_init_max);
+        else {
+            if (p_tbl->max_block_in_use == -1)
+                mcast_top = cl_hton16(IB_LID_MCAST_START_HO - 1);
+            else
+                mcast_top = cl_hton16(IB_LID_MCAST_START_HO +
+                              (p_tbl->max_block_in_use + 1) * 
IB_MCAST_BLOCK_SIZE - 1);
+        }
          if (mcast_top == si.mcast_top)
              return;

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 92ac3d7..fe40b77 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -1109,6 +1109,8 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
                            well_known);
              if (!p_mgrp)
                  rereg_clients = 1;
+            if (cl_ntoh16(mlid) > p_osm->sm.mlids_init_max)
+                p_osm->sm.mlids_init_max = cl_ntoh16(mlid);
          } else if (p_mgrp && !strncmp(p, "mcm_port", 8)) {
              ib_member_rec_t mcmr;
              ib_net64_t guid;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
