From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_sa_service_record.c: Remove useless if
Date: Tue, 19 Apr 2011 10:27:39 -0400
Message-ID: <4DAD9BDB.9010608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


in sr_rcv_process_delete_method

Also, cosmetic formatting change

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_service_record.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index 33c1f3b..72bcbdc 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -634,10 +634,9 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 			"No records matched the RID\n");
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_NO_RECORDS);
 		goto Exit;
-	} else {
-		osm_svcr_remove_from_db(sa->p_subn, sa->p_log, p_svcr);
 	}
 
+	osm_svcr_remove_from_db(sa->p_subn, sa->p_log, p_svcr);
 	cl_plock_release(sa->p_lock);
 
 	p_sr_item = malloc(sizeof(*p_sr_item));
@@ -654,8 +653,7 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	cl_qlist_insert_tail(&sr_list, &p_sr_item->list_item);
 
-	if (p_svcr)
-		osm_svcr_delete(p_svcr);
+	osm_svcr_delete(p_svcr);
 
 	sr_rcv_respond(sa, p_madw, &sr_list);
 
-- 
1.5.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
