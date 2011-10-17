From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_sa_mcmember_record.c: Commentary changes
 relating to SA assigned MGIDs
Date: Mon, 17 Oct 2011 13:46:04 -0400
Message-ID: <4E9C69DC.9070002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update one comment to be more accurate
and remove comment which appears to no longer apply

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index ad48d00..43323ca 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -615,7 +615,7 @@ static ib_api_status_t validate_requested_mgid(IN osm_sa_t * sa,
 
 	/*
 	 * For SA assigned MGIDs (signature 0xA01B):
-	 * There is no real way to make sure the Unique MGID Prefix is really unique.
+	 * There is no real way to make sure the GID Prefix is really unique.
 	 * If we could enforce using the Subnet Prefix for that purpose it would
 	 * have been nice. But the spec does not require it.
 	 */
@@ -776,7 +776,6 @@ static unsigned build_new_mgid(osm_sa_t * sa, ib_net64_t comp_mask,
 	mgid->raw[2] = 0xa0;
 	mgid->raw[3] = 0x1b;
 
-	/* HACK: use the SA port gid to make it globally unique */
 	memcpy(&mgid->raw[4], &sa->p_subn->opt.subnet_prefix, sizeof(uint64_t));
 
 	for (i = 0; i < 1000; i++) {
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
