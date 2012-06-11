From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 04/29] IB/core: change pkey table lookups to support full and partial membership for the same pkey
Date: Mon, 11 Jun 2012 13:45:45 +0300
Message-ID: <1339411570-4689-5-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enhance the cached and non-cached pkey table lookups to enable limited and full
members of the same pkey to co-exist in the pkey table.

This is necessary for SRIOV to allow for a scheme where some guests would have the full
membership pkey in their virtual pkey table, where other guests on the same hypervisor
would have the limited one. In that sense, its an extension of the IBTA model for
non virtualized nodes.

To accomplish this, we need both the limited and full membership pkeys to be present
in the master's (hypervisor physical port) pkey table.

The algorithm for supporting pkey tables which contain both the limited and the full
membership versions of the same pkey works as follows:

When scanning the pkey table for a 15 bit pkey:

A. If there is a full member version of that pkey anywhere
    in the table, return its index (even if a limited-member
    version of the pkey exists earlier in the table).

B. If the full member version is not in the table,
    but the limited-member version is in the table,
    return the index of the limited pkey.

Signed-off-by: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c  |   14 +++++++++++---
 drivers/infiniband/core/device.c |   17 +++++++++++++----
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 9353992..0f2f2b7 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -167,6 +167,7 @@ int ib_find_cached_pkey(struct ib_device *device,
 	unsigned long flags;
 	int i;
 	int ret = -ENOENT;
+	int partial_ix = -1;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
@@ -179,10 +180,17 @@ int ib_find_cached_pkey(struct ib_device *device,
 
 	for (i = 0; i < cache->table_len; ++i)
 		if ((cache->table[i] & 0x7fff) == (pkey & 0x7fff)) {
-			*index = i;
-			ret = 0;
-			break;
+			if (cache->table[i] & 0x8000) {
+				*index = i;
+				ret = 0;
+				break;
+			} else
+				partial_ix = i;
 		}
+	if (ret && partial_ix >= 0) {
+		*index = partial_ix;
+		ret = 0;
+	}
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index e711de4..a645c68 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -707,18 +707,27 @@ int ib_find_pkey(struct ib_device *device,
 {
 	int ret, i;
 	u16 tmp_pkey;
+	int partial_ix = -1;
 
 	for (i = 0; i < device->pkey_tbl_len[port_num - start_port(device)]; ++i) {
 		ret = ib_query_pkey(device, port_num, i, &tmp_pkey);
 		if (ret)
 			return ret;
-
 		if ((pkey & 0x7fff) == (tmp_pkey & 0x7fff)) {
-			*index = i;
-			return 0;
+			/* if there is full-member pkey take it.*/
+			if (tmp_pkey & 0x8000) {
+				*index = i;
+				return 0;
+			}
+			if (partial_ix < 0)
+				partial_ix = i;
 		}
 	}
-
+	/*no full-member, if exists take the limited*/
+	if (partial_ix >= 0) {
+		*index = partial_ix;
+		return 0;
+	}
 	return -ENOENT;
 }
 EXPORT_SYMBOL(ib_find_pkey);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
