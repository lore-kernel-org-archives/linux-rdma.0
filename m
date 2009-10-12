From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix gcc-4.4.1 warnings
Date: Mon, 12 Oct 2009 18:06:17 +0200
Message-ID: <20091012160617.GF31778@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix "dereferencing type-punned pointer will break strict-aliasing rules"
warning catched by gcc-4.4.1.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/iba/ib_types.h |    3 +--
 opensm/opensm/osm_helper.c    |    7 +++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index 25ed35f..aa566f7 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -2745,8 +2745,7 @@ ib_path_rec_init_local(IN ib_path_rec_t * const p_rec,
 	p_rec->tclass = 0;
 	p_rec->service_id = 0;
 
-	*((uint32_t *) p_rec->resv2) = 0;
-	*((uint16_t *) p_rec->resv2 + 2) = 0;
+	memset(p_rec->resv2, 0, sizeof(p_rec->resv2));
 }
 
 /*
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 2b3dced..2668f0c 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -1102,8 +1102,7 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
 			"\t\t\t\trate....................0x%X\n"
 			"\t\t\t\tpkt_life................0x%X\n"
 			"\t\t\t\tpreference..............0x%X\n"
-			"\t\t\t\tresv2...................0x%X\n"
-			"\t\t\t\tresv3...................0x%X\n",
+			"\t\t\t\tresv2...................0x%02X%02X%02X%02X%02X%02X\n",
 			cl_ntoh64(p_pr->service_id),
 			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
 				  sizeof gid_str),
@@ -1121,8 +1120,8 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
 			p_pr->rate,
 			p_pr->pkt_life,
 			p_pr->preference,
-			*(uint32_t *) & p_pr->resv2,
-			*((uint16_t *) & p_pr->resv2 + 2));
+			p_pr->resv2[0], p_pr->resv2[1], p_pr->resv2[2],
+			p_pr->resv2[3], p_pr->resv2[4], p_pr->resv2[5]);
 	}
 }
 
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
