From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_multipath_record.c: Make sure either none or
 both ServiceID parameters are supplied
Date: Wed, 20 Feb 2013 14:02:46 -0500
Message-ID: <51251DD6.4000009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index e89c93a..7083b04 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1587,6 +1622,14 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 		}
 	}
 
+	/* Make sure either none or both ServiceID parameters are supplied */
+	if ((p_sa_mad->comp_mask & IB_MPR_COMPMASK_SERVICEID) != 0 &&
+	    (p_sa_mad->comp_mask & IB_MPR_COMPMASK_SERVICEID) !=
+	     IB_MPR_COMPMASK_SERVICEID) {
+		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_INSUF_COMPS);
+		goto Exit;
+	}
+
 	cl_qlist_init(&pr_list);
 
 	/*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
