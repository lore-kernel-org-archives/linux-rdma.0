From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mcmember_record.c: Fix incorrect comparison
 of IPv6 MGID when searching for SNM MLID
Date: Tue, 01 Oct 2013 08:46:24 -0400
Message-ID: <524AC420.1040602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The whole MGID except of the last 3 bytes should be compared.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 82e3542..5f8e179 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -164,7 +164,7 @@ static unsigned match_ipv4_mux_mgid(ib_gid_t * mgid)
 
 static int compare_ipv6_snm_mgids(const void *m1, const void *m2)
 {
-	return memcmp(m1, m2, sizeof(ib_gid_t) - 6);
+	return memcmp(m1, m2, sizeof(ib_gid_t) - 3);
 }
 
 static ib_net16_t find_ipv6_snm_mlid(osm_subn_t *subn, ib_gid_t *mgid)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
