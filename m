From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH opensm] Handle memory allocation failure in
 osm_db_domain_init()
Date: Thu, 12 Sep 2013 01:14:13 -0700 (PDT)
Message-ID: <92a44805-9cab-4ae1-9994-39f7739aa5c7@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 513cf85..9219722 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -218,17 +219,34 @@ osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN const char *domain_na
 
 	/* allocate a new domain object */
 	p_domain = malloc(sizeof(osm_db_domain_t));
-	CL_ASSERT(p_domain != NULL);
+	if (p_domain == NULL) {
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 610C: "
+			"Failed to allocate domain memory\n");
+		goto Exit;
+	}
 
 	p_domain_imp = malloc(sizeof(osm_db_domain_imp_t));
-	CL_ASSERT(p_domain_imp != NULL);
+	if (p_domain_imp == NULL) {
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 610D: "
+			"Failed to allocate domain_imp memory\n");
+		free(p_domain);
+		p_domain = NULL;
+		goto Exit;
+	}
 
 	path_len = strlen(((osm_db_imp_t *) p_db->p_db_imp)->db_dir_name)
 	    + strlen(domain_name) + 2;
 
 	/* set the domain file name */
 	p_domain_imp->file_name = malloc(path_len);
-	CL_ASSERT(p_domain_imp->file_name != NULL);
+	if (p_domain_imp->file_name == NULL) {
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 610E: "
+			"Failed to allocate file_name memory\n");
+		free(p_domain_imp);
+		free(p_domain);
+		p_domain = NULL;
+		goto Exit;
+	}
 	snprintf(p_domain_imp->file_name, path_len, "%s/%s",
 		 ((osm_db_imp_t *) p_db->p_db_imp)->db_dir_name, domain_name);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
