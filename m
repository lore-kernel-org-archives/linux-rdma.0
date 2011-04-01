From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 6/11] opensm/osm_sa_mcmember_record.c: Fix handling of invalid
 PKey
Date: Fri, 01 Apr 2011 14:37:59 -0400
Message-ID: <4D961B87.7060902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In mcmr_rcv_join_mgrp, when pkey is supplied, this needs to be checked
as to whether it is invalid or not as subsequent PKey checks are too
lenient

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c
b/opensm/osm_sa_mcmember_record.c
index b2318ec..0f79e69 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1019,6 +1019,15 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa,
IN osm_madw_t * p_madw)
 		goto Exit;
 	}

+	if (p_sa_mad->comp_mask & IB_MCR_COMPMASK_PKEY &&
+	    ib_pkey_is_invalid(p_recvd_mcmember_rec->pkey)) {
+		CL_PLOCK_RELEASE(sa->p_lock);
+		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
+			"Invalid PKey supplied in request\n");
+		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
+		goto Exit;
+	}
+
 	ib_member_get_scope_state(p_recvd_mcmember_rec->scope_state, NULL,
 				  &join_state);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
