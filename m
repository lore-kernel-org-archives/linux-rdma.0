From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Fixed ftree/updn configuration failure
 when root_guid_file points to non-existing file
Date: Wed, 30 May 2012 19:28:53 -0400
Message-ID: <4FC6AD35.9080505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 7dcde87..04c7b18 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1315,6 +1315,17 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 	}
 #endif
 
+	if (p_opts->root_guid_file != NULL) {
+		FILE *root_file = fopen(p_opts->root_guid_file, "r");
+		if (!root_file) {
+			log_report("Root guid file provided: %s doesn't exist.\n"
+				    "Using default roots discovery algorithm\n",
+				    p_opts->root_guid_file);
+			p_opts->root_guid_file = NULL;
+		} else
+			fclose(root_file);
+	}
+
 	return 0;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
