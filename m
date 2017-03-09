From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] saquery.c: Remove use of to be deprecated
 ib_gid_t
Date: Thu, 9 Mar 2017 10:38:50 -0500
Message-ID: <b50e7300-4043-abed-9757-7d2cc1fa60f4@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


which will be going away in a future version of libibmad

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index ea946a1..6b7eb5d 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -69,7 +69,7 @@
 
 struct query_params {
 	uint64_t service_id;
-	ib_gid_t sgid, dgid, gid, mgid;
+	ibmad_gid_t sgid, dgid, gid, mgid;
 	uint16_t slid, dlid, mlid;
 	uint32_t flow_label;
 	int hop_limit;
@@ -118,9 +118,9 @@ int requested_lid_flag = 0;
 uint64_t requested_guid = 0;
 int requested_guid_flag = 0;
 
-static unsigned valid_gid(ib_gid_t * gid)
+static unsigned valid_gid(ibmad_gid_t * gid)
 {
-	ib_gid_t zero_gid;
+	ibmad_gid_t zero_gid;
 	memset(&zero_gid, 0, sizeof zero_gid);
 	return memcmp(&zero_gid, gid, sizeof(*gid));
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
