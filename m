From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH ] opensm/osm_prtn_config.c: Fix IPoIB broadcast group
 creation on non-default Pkey
Date: Tue, 29 Nov 2011 17:50:11 +0200
Message-ID: <20111129155011.GA5179@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>From 1b42127324b3bc6e97da20118525c23e32c6d087 Mon Sep 17 00:00:00 2001
From: root <root-fIVdcA820AXJXU1vycJJuwC/G2K4zDHf@public.gmane.org>
Date: Tue, 29 Nov 2011 17:46:32 +0200
Subject: [PATCH 1/1] Fix IPoIB broadcast group creation on non-default Pkey

In case you configure a partition in the folowing way
(without specifing the mgid), no bradcast IPoIB group
is created using NewPartition.

NewPartition=0x1 , ipoib : 0x123456=full 0x654321=full

Signed-off-by: root <Alex Netes alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn_config.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 4b8d86c..56691b0 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -203,7 +203,7 @@ static void __create_mgrp(struct part_conf *conf, struct precreate_mgroup *group
 static int partition_create(unsigned lineno, struct part_conf *conf,
 			    char *name, char *id, char *flag, char *flag_val)
 {
-	uint16_t pkey;
+	ib_net16_t pkey;
 
 	if (!id && name && isdigit(*name)) {
 		id = name;
@@ -213,14 +213,14 @@ static int partition_create(unsigned lineno, struct part_conf *conf,
 	if (id) {
 		char *end;
 
-		pkey = (uint16_t) strtoul(id, &end, 0);
+		pkey = cl_hton16(uint16_t) strtoul(id, &end, 0));
 		if (end == id || *end)
 			return -1;
 	} else
 		pkey = 0;
 
 	conf->p_prtn = osm_prtn_make_new(conf->p_log, conf->p_subn,
-					 name, cl_hton16(pkey));
+					 name, pkey);
 	if (!conf->p_prtn)
 		return -1;
 
@@ -237,6 +237,8 @@ static int partition_create(unsigned lineno, struct part_conf *conf,
 		struct precreate_mgroup broadcast_mgroup;
 		memset(&broadcast_mgroup, 0, sizeof(broadcast_mgroup));
 		broadcast_mgroup.mgid = osm_ipoib_broadcast_mgid;
+		pkey |= cl_hton16(0x8000);
+		memcpy(&broadcast_mgroup.mgid.raw[4], &pkey , sizeof(pkey));
 		broadcast_mgroup.flags.mtu = conf->flags.mtu;
 		broadcast_mgroup.flags.rate = conf->flags.rate;
 		broadcast_mgroup.flags.sl = conf->flags.sl;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
