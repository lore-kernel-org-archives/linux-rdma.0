From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibmad: fix strinct-aliasing breakage warnings
Date: Sat, 24 Oct 2009 01:45:05 +0200
Message-ID: <20091023234505.GL5764@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Itai Baz <itaib-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix compilation warnings (>= gcc-4.4.0 wirg -Wall -O2):

warning: dereferencing type-punned pointer will break strict-aliasing rules

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 libibmad/src/bm.c      |   20 +++++++++++---------
 libibmad/src/resolve.c |    5 +++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/libibmad/src/bm.c b/libibmad/src/bm.c
index 2983855..7d53cf1 100644
--- a/libibmad/src/bm.c
+++ b/libibmad/src/bm.c
@@ -53,7 +53,11 @@ uint8_t *bm_call_via(void *data, ib_portid_t * portid, ib_bm_call_t * call,
 {
 	ib_rpc_t rpc = { 0 };
 	int resp_expected;
-	char data_with_bkey[IB_BM_BKEY_AND_DATA_SZ] = { 0 };
+	struct {
+		uint64_t bkey;
+		uint8_t reserved[32];
+		uint8_t data[IB_BM_DATA_SZ];
+	} bm_data;
 
 	DEBUG("route %s data %p", portid2str(portid), data);
 	if (portid->lid <= 0) {
@@ -74,9 +78,9 @@ uint8_t *bm_call_via(void *data, ib_portid_t * portid, ib_bm_call_t * call,
 	rpc.dataoffs = IB_BM_BKEY_OFFS;
 
 	// copy data to a buffer which also includes the bkey
-	*((uint64_t *) data_with_bkey) = htonll(call->bkey);
-	memcpy(data_with_bkey + IB_BM_DATA_OFFS - IB_BM_BKEY_OFFS, data,
-	       IB_BM_DATA_SZ);
+	bm_data.bkey = htonll(call->bkey);
+	memset(bm_data.reserved, 0, sizeof(bm_data.reserved));
+	memcpy(bm_data.data, data, IB_BM_DATA_SZ);
 
 	DEBUG
 	    ("method 0x%x attr 0x%x mod 0x%x datasz %d off %d res_ex %d bkey 0x%08x%08x",
@@ -89,17 +93,15 @@ uint8_t *bm_call_via(void *data, ib_portid_t * portid, ib_bm_call_t * call,
 
 	if (resp_expected) {
 		/* FIXME: no RMPP for now */
-		if (mad_rpc
-		    (srcport, &rpc, portid, data_with_bkey, data_with_bkey))
+		if (mad_rpc(srcport, &rpc, portid, &bm_data, &bm_data))
 			goto return_ok;
 		return NULL;
 	}
 
-	if (mad_send_via(&rpc, portid, 0, data_with_bkey, srcport) < 0)
+	if (mad_send_via(&rpc, portid, 0, &bm_data, srcport) < 0)
 		return NULL;
 
 return_ok:
-	memcpy(data, data_with_bkey + IB_BM_DATA_OFFS - IB_BM_BKEY_OFFS,
-	       IB_BM_DATA_SZ);
+	memcpy(data, bm_data.data, IB_BM_DATA_SZ);
 	return data;
 }
diff --git a/libibmad/src/resolve.c b/libibmad/src/resolve.c
index 3e07e8a..b89360c 100644
--- a/libibmad/src/resolve.c
+++ b/libibmad/src/resolve.c
@@ -98,7 +98,7 @@ int ib_resolve_guid_via(ib_portid_t * portid, uint64_t * guid,
 	ib_portid_t sm_portid;
 	uint8_t buf[IB_SA_DATA_SIZE] = { 0 };
 	ib_portid_t self = { 0 };
-	uint64_t selfguid;
+	uint64_t selfguid, prefix;
 	ibmad_gid_t selfgid;
 	uint8_t nodeinfo[64];
 
@@ -114,7 +114,8 @@ int ib_resolve_guid_via(ib_portid_t * portid, uint64_t * guid,
 	mad_set_field64(selfgid, 0, IB_GID_PREFIX_F, IB_DEFAULT_SUBN_PREFIX);
 	mad_set_field64(selfgid, 0, IB_GID_GUID_F, selfguid);
 
-	if (*(uint64_t *) & portid->gid == 0)
+	memcpy(&prefix, portid->gid, sizeof(prefix));
+	if (!prefix)
 		mad_set_field64(portid->gid, 0, IB_GID_PREFIX_F,
 				IB_DEFAULT_SUBN_PREFIX);
 	if (guid)
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
