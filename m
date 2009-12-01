From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: No need for heavy sweep when trap
	144 indicates just NodeDescription change
Date: Tue, 1 Dec 2009 08:12:15 -0500
Message-ID: <20091201131215.GA12753@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


For trap 144s which indicate NodeDescription changed, there is no need for
a heavy sweep if that is the only change indicated by the trap. Determine that
by checking that there are no other change flags set and that the 
capability mask is unchanged. Still sweep if this is not the case (there
is some other change).

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 52f8832..9024a1f 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -509,6 +509,9 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 			CL_PLOCK_ACQUIRE(sm->p_lock);
 			osm_req_get_node_desc(sm, p_physp);
 			CL_PLOCK_RELEASE(sm->p_lock);
+			if (!(p_ntci->data_details.ntc_144.change_flgs & ~TRAP_144_MASK_NODE_DESCRIPTION_CHANGE) &&
+			    p_ntci->data_details.ntc_144.new_cap_mask == p_physp->port_info.capability_mask)
+				goto check_report;
 		} else
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 				"ERR 3812: No physical port found for "
@@ -547,6 +550,7 @@ check_sweep:
 	if (physp_change_trap == TRUE)
 		goto Exit;
 
+check_report:
 	/* Add a call to osm_report_notice */
 	/* We are going to report the notice - so need to fix the IssuerGID
 	   accordingly. See IBA 1.2 p.739 or IBA 1.1 p.653 for details. */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
