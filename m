From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] libvendor/osm_vendor_ibumad.c: fix unused-but-set warning
Date: Mon, 11 Jul 2011 20:46:26 +0300
Message-ID: <20110711174626.GD2084@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

is_rmpp might be set but unused when VENDOR_RMPP_SUPPORT is TRUE.
Mark this variable as __attribute__((unused)) to remove this warning.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index 5cd6f46..e2ebd8e 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -1002,7 +1002,7 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 	ib_mad_t *const p_mad = osm_madw_get_mad_ptr(p_madw);
 	ib_sa_mad_t *const p_sa = (ib_sa_mad_t *) p_mad;
 	int ret = -1;
-	int is_rmpp = 0;
+	int __attribute__((__unused__)) is_rmpp = 0;
 	uint32_t sent_mad_size;
 	uint64_t tid;
 #ifndef VENDOR_RMPP_SUPPORT
-- 
1.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
