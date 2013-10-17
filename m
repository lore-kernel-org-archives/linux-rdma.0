From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH opensm 1/2] reduce log level for missing partition
 configuration file.
Date: Thu, 17 Oct 2013 13:10:46 +0200
Message-ID: <20131017111046.177713.86458.stgit@fsdevel2>
References: <20131017111041.177713.61634.stgit@fsdevel2>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131017111041.177713.61634.stgit@fsdevel2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A missing non-mandatory file is not an error.

Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
---
 opensm/osm_prtn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index 24a1fe3..e76e2e1 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -383,7 +383,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 	file_name = p_subn->opt.partition_config_file ?
 	    p_subn->opt.partition_config_file : OSM_DEFAULT_PARTITION_CONFIG_FILE;
 	if (stat(file_name, &statbuf)) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "Partition configuration "
+		OSM_LOG(p_log, OSM_LOG_VERBOSE, "Partition configuration "
 			"%s is not accessible (%s)\n", file_name,
 			strerror(errno));
 		is_config = FALSE;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
