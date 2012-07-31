From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 13/27] Fix pre-creation of MC group with MGID containing P_Key
Date: Tue, 31 Jul 2012 19:04:41 +0300
Message-ID: <1343750695-28063-13-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPoIB MGID can contain only full P_Key.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn_config.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 750cbe0..8714eba 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -129,8 +129,10 @@ static inline boolean_t ip_mgroup_pkey_ok(struct part_conf *conf,
 	char gid_str[INET6_ADDRSTRLEN];
 
 	if (mgid_is_broadcast(&group->mgid)
-	    || mpkey == 0x0000 /* user requested "wild card" of pkey */
-	    || mpkey == conf->p_prtn->pkey) /* user was smart enough to match */
+	    /* user requested "wild card" of pkey */
+	    || mpkey == 0x0000
+	    /* user was smart enough to match */
+	    || mpkey == (conf->p_prtn->pkey | cl_hton16(0x8000)))
 		return (TRUE);
 
 	OSM_LOG(conf->p_log, OSM_LOG_ERROR,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
