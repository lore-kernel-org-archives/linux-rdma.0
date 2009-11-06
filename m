From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm: Only clear SMP beyond end of PortInfo attribute
Date: Fri, 6 Nov 2009 09:14:02 -0500
Message-ID: <20091106141402.GA19699@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than the whole SMP

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 145be1c..5529033 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -865,8 +865,9 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	   Third, send the SMP to this physical port.
 	 */
 
-	memset(payload, 0, IB_SMP_DATA_SIZE);
 	memcpy(payload, p_old_pi, sizeof(ib_port_info_t));
+	memset(payload + sizeof(ib_port_info_t), 0,
+	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	/*
 	   Should never write back a value that is bigger then 3 in
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index 2477f2c..bcfc269 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -152,8 +152,9 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			esp0 = TRUE;
 	}
 
-	memset(payload, 0, IB_SMP_DATA_SIZE);
 	memcpy(payload, p_old_pi, sizeof(ib_port_info_t));
+	memset(payload + sizeof(ib_port_info_t), 0,
+	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	/*
 	   Should never write back a value that is bigger then 3 in
diff --git a/opensm/opensm/osm_pkey_mgr.c b/opensm/opensm/osm_pkey_mgr.c
index 6666be2..de79e3d 100644
--- a/opensm/opensm/osm_pkey_mgr.c
+++ b/opensm/opensm/osm_pkey_mgr.c
@@ -200,8 +200,9 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 		return IB_SUCCESS;
 	}
 
-	memset(payload, 0, IB_SMP_DATA_SIZE);
 	memcpy(payload, p_pi, sizeof(ib_port_info_t));
+	memset(payload + sizeof(ib_port_info_t), 0,
+	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	p_pi = (ib_port_info_t *) payload;
 	if (enforce == TRUE)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
