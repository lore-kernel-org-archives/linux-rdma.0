From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/11] opensm/osm_sa_mcmember_record.c: Changed status in a
 couple of SA responses
Date: Fri, 01 Apr 2011 14:37:52 -0400
Message-ID: <4D961B80.2030404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


For SubnAdmSet and SubnAdmDelete, return insufficient components rather
than invalid request when component mask doesn't have at least the
required components for a join

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c
b/opensm/osm_sa_mcmember_record.c
index b2318ec..c8c6b5d 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -1462,7 +1462,7 @@ void osm_mcmr_rcv_process(IN void *context, IN
void *data)
 					  p_recvd_mcmember_rec->port_gid.raw,
 					  gid_str2, sizeof gid_str2));
 			osm_sa_send_error(sa, p_madw,
-					  IB_SA_MAD_STATUS_REQ_INVALID);
+					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}

@@ -1479,7 +1479,7 @@ void osm_mcmr_rcv_process(IN void *context, IN
void *data)
 				cl_ntoh64(p_sa_mad->comp_mask),
 				CL_NTOH64(JOIN_MC_COMP_MASK));
 			osm_sa_send_error(sa, p_madw,
-					  IB_SA_MAD_STATUS_REQ_INVALID);
+					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
