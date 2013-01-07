From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm/osm_torus.c: Dump torus when OSM_LOG_ROUTING specified
Date: Mon, 07 Jan 2013 14:50:42 -0500
Message-ID: <50EB2712.2050206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Useful feature for torus debug

Also, in report_torus_changes, no need for NULL pointer check on nt

Reviewed-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 1d847b3..4e5688f 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7518,6 +7535,36 @@ out:
 }
 
 static
+void dump_torus(struct torus *t)
+{
+	unsigned i, j, k;
+	unsigned x_sz = t->x_sz;
+	unsigned y_sz = t->y_sz;
+	unsigned z_sz = t->z_sz;
+	char path[1024];
+	FILE *file;
+
+	snprintf(path, sizeof(path), "%s/%s", t->osm->subn.opt.dump_files_dir,
+		 "opensm-torus.dump");
+	file = fopen(path, "w");
+	if (!file) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"ERR 4E47: cannot create file \'%s\'\n", path);
+		return;
+	}
+
+	for (k = 0; k < z_sz; k++)
+		for (j = 0; j < y_sz; j++)
+			for (i = 0; i < x_sz; i++)
+				fprintf(file, "switch %u,%u,%u GUID 0x%04"
+					PRIx64 " (%s)\n",
+					i, j, k,
+					cl_ntoh64(t->sw[i][j][k]->n_id),
+					t->sw[i][j][k]->osm_switch->p_node->print_desc);
+	fclose(file);
+}
+
+static
 void report_torus_changes(struct torus *nt, struct torus *ot)
 {
 	unsigned cnt = 0;
@@ -7525,7 +7572,10 @@ void report_torus_changes(struct torus *nt, struct torus *ot)
 	unsigned y_sz = nt->y_sz;
 	unsigned z_sz = nt->z_sz;
	unsigned max_changes = nt->max_changes;

+	if (OSM_LOG_IS_ACTIVE_V2(&nt->osm->log, OSM_LOG_ROUTING))
+		dump_torus(nt);
+ 
-	if (!(nt && ot))
+	if (!ot)
 		return;
 
 	if (x_sz != ot->x_sz) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
