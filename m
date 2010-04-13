From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: adding wrapper for
	pr_rcv_get_path_parms()
Date: Tue, 13 Apr 2010 15:49:51 +0300
Message-ID: <4BC4686F.9080702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding non-static wrapper function for pr_rcv_get_path_parms()
fuction to enable calling path record calculation function from
outside this file.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index c4c3f86..b168428 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -743,6 +743,18 @@ Exit:
 	return status;
 }

+ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
+				    IN const osm_port_t * p_src_port,
+				    IN const osm_port_t * p_dest_port,
+				    IN const uint16_t dlid_ho,
+				    OUT osm_path_parms_t * p_parms)
+{
+	ib_path_rec_t pr;
+	memset(&pr, 0, sizeof(ib_path_rec_t));
+	return pr_rcv_get_path_parms(sa, &pr,
+		p_src_port, p_dest_port, dlid_ho, 0, p_parms);
+}
+
 static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 			    IN const osm_port_t * p_dest_port,
 			    IN const ib_gid_t * p_dgid,
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
