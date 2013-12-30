From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_db_files.c: Some minor fixes/improvements to osm_db_store
Date: Mon, 30 Dec 2013 10:59:54 -0500
Message-ID: <52C1987A.6000802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


1. Check p_domain_imp->dirty flag under lock
2. Handle malloc failure for temporary file name
3. Move malloc outside of lock

Items 1 and 2 above were:
Pointed-out-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
in http://marc.info/?l=linux-rdma&m=138763427730411&w=2

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 38ee9a9..b43b5e6 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -475,16 +475,21 @@ int osm_db_store(IN osm_db_domain_t * p_domain,
 
 	p_domain_imp = (osm_db_domain_imp_t *) p_domain->p_domain_imp;
 
-	if (p_domain_imp->dirty == FALSE)
-		goto Exit;
-
 	p_tmp_file_name = malloc(sizeof(char) *
 				 (strlen(p_domain_imp->file_name) + 8));
+	if (!p_tmp_file_name) {
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6113: "
+			"Failed to allocate memory for temporary file name\n");
+		goto Exit;
+	}
 	strcpy(p_tmp_file_name, p_domain_imp->file_name);
 	strcat(p_tmp_file_name, ".tmp");
 
 	cl_spinlock_acquire(&p_domain_imp->lock);
 
+	if (p_domain_imp->dirty == FALSE)
+		goto Exit;
+
 	/* open up the output file */
 	p_file = fopen(p_tmp_file_name, "w");
 	if (!p_file) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
