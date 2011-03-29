From: Eli Dorfman <elido-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Allow comma in plugin names parsing
Date: Tue, 29 Mar 2011 10:46:49 +0200
Message-ID: <4D919C79.9030406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Subject: [PATCH] Allow comma in plugin names parsing

Signed-off-by: Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_opensm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index cb40f71..11b7158 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -324,7 +324,7 @@ static void load_plugins(osm_opensm_t *osm, const char *plugin_names)
 	char *p_names, *name, *p;
 
 	p_names = strdup(plugin_names);
-	name = strtok_r(p_names, " \t\n", &p);
+	name = strtok_r(p_names, ", \t\n", &p);
 	while (name && *name) {
 		epi = osm_epi_construct(osm, name);
 		if (!epi)
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
