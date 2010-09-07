From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: fixing small bug in error path
Date: Tue, 7 Sep 2010 18:04:38 +0300
Message-ID: <4C865486.4040909@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Closing file on failure

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index d5c5ab2..149ab85 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -1163,8 +1163,10 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 	cl_log_event("OpenSM", CL_LOG_INFO, line, NULL, 0);

 	p_opts->config_file = file_name;
-	if (!p_opts->file_opts && !(p_opts->file_opts = malloc(sizeof(*p_opts))))
+	if (!p_opts->file_opts && !(p_opts->file_opts = malloc(sizeof(*p_opts)))) {
+		fclose(opts_file);
 		return -1;
+	}
 	memcpy(p_opts->file_opts, p_opts, sizeof(*p_opts));

 	while (fgets(line, 1023, opts_file) != NULL) {
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
