From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_vl15intf.c: Fix commentary typo
Date: Wed, 24 Oct 2012 09:42:24 -0400
Message-ID: <5087F040.6020900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_vl15intf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
index 253578b..f85252c 100644
--- a/opensm/osm_vl15intf.c
+++ b/opensm/osm_vl15intf.c
@@ -346,7 +346,7 @@ void osm_vl15_shutdown(IN osm_vl15_t * p_vl, IN osm_mad_pool_t * p_mad_pool)
 	/* we only should get here after the VL15 interface was initialized */
 	CL_ASSERT(p_vl->state == OSM_VL15_STATE_READY);
 
-	/* grap a lock on the object */
+	/* grab a lock on the object */
 	cl_spinlock_acquire(&p_vl->lock);
 
 	/* go over all outstanding MADs and retire their transactions */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
