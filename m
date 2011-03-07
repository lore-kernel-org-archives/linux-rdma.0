From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed potential null variable dereferencing in
 libvendor
Date: Mon, 7 Mar 2011 14:05:04 +0200
Message-ID: <20110307120504.GP5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

lru might be uninitialized in case when m->version = ~0.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index be2dda2..5cd6f46 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -174,7 +174,7 @@ put_madw(osm_vendor_t * p_vend, osm_madw_t * p_madw, ib_net64_t tid)
 			pthread_mutex_unlock(&p_vend->match_tbl_mutex);
 			return;
 		}
-		if (oldest > m->version) {
+		if (oldest >= m->version) {
 			oldest = m->version;
 			lru = m;
 		}
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
