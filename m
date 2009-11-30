From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_mlx: fix compilation error
Date: Mon, 30 Nov 2009 16:45:23 +0200
Message-ID: <4B13DA83.4070400@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix compilation error of that was introduced with patch
that added configurable transaction retries - osm_vendor_mlx
didn't have a definition of OSM_DEFAULT_RETRY_COUNT.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/vendor/osm_vendor_mlx.h      |    3 +++
 opensm/include/vendor/osm_vendor_mlx_defs.h |    2 --
 opensm/libvendor/osm_vendor_mlx_txn.c       |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/opensm/include/vendor/osm_vendor_mlx.h b/opensm/include/vendor/osm_vendor_mlx.h
index e67d280..867baf1 100644
--- a/opensm/include/vendor/osm_vendor_mlx.h
+++ b/opensm/include/vendor/osm_vendor_mlx.h
@@ -92,5 +92,8 @@ typedef struct _osm_vend_wrap {
 #define OSM_BIND_INVALID_HANDLE NULL
 #endif

+/* The maximum number of retransmissions of the same MAD */
+#define OSM_DEFAULT_RETRY_COUNT  3
+
 END_C_DECLS
 #endif
diff --git a/opensm/include/vendor/osm_vendor_mlx_defs.h b/opensm/include/vendor/osm_vendor_mlx_defs.h
index d4c2c30..54cf286 100644
--- a/opensm/include/vendor/osm_vendor_mlx_defs.h
+++ b/opensm/include/vendor/osm_vendor_mlx_defs.h
@@ -52,8 +52,6 @@
 BEGIN_C_DECLS
 /* The maximum number of outstanding MADs an RMPP sender can transmit */
 #define OSMV_RMPP_RECV_WIN       16
-/* The maximum number of retransmissions of the same MAD */
-#define OSMV_MAX_RETRANSMIT      3
 /* Transaction Timeout = OSMV_TXN_TIMEOUT_FACTOR * Response Timeout */
 #define OSMV_TXN_TIMEOUT_FACTOR  128
 /************/
diff --git a/opensm/libvendor/osm_vendor_mlx_txn.c b/opensm/libvendor/osm_vendor_mlx_txn.c
index 93d17c8..60dc293 100644
--- a/opensm/libvendor/osm_vendor_mlx_txn.c
+++ b/opensm/libvendor/osm_vendor_mlx_txn.c
@@ -558,7 +558,7 @@ __osmv_txn_timeout_cb(IN uint64_t key,
 	switch (osmv_txn_get_rmpp_state(p_txn)) {

 	case OSMV_TXN_RMPP_NONE:
-		if (num_regs <= OSMV_MAX_RETRANSMIT) {
+		if (num_regs <= OSM_DEFAULT_RETRY_COUNT) {
 			/* We still did not exceed the limit of retransmissions.
 			 * Set the next timeout's value.
 			 */
@@ -622,7 +622,7 @@ __osmv_txn_timeout_cb(IN uint64_t key,
 			osmv_txn_get_tid(p_txn));

 		p_send_ctx = osmv_txn_get_rmpp_send_ctx(p_txn);
-		if (num_regs <= OSMV_MAX_RETRANSMIT) {
+		if (num_regs <= OSM_DEFAULT_RETRY_COUNT) {
 			/* We still did not exceed the limit of retransmissions.
 			 * Set the next timeout's value.
 			 */
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
