From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH IB/core 1/2] IB/core: A full pkey is required to match a limited one
Date: Wed,  9 May 2018 11:30:19 +0200
Message-ID: <20180509093020.24503-2-Haakon.Bugge@oracle.com>
References: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
List-Id: linux-rdma@vger.kernel.org

In ib_find_cached_pkey(), the preference is to return the pkey-index
of the full pkey, if both a limited and the full exists in the cache.

However, if both pkeys are limited, the function return success.

To detect if two pkeys are eligible for communication,
ib_find_matched_cached_pkey() is introduced, which requires at least
one of the pkeys to be a full member, in order to return success.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/core/cache.c | 32 +++++++++++++++++++++++++++-----
 include/rdma/ib_cache.h         | 18 ++++++++++++++++++
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index fb2d347f760f..cb7e9818a226 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -983,10 +983,11 @@ int ib_get_cached_subnet_prefix(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_subnet_prefix);
 
-int ib_find_cached_pkey(struct ib_device *device,
-			u8                port_num,
-			u16               pkey,
-			u16              *index)
+static int __ib_find_cached_pkey(struct ib_device *device,
+				 u8                port_num,
+				 u16               pkey,
+				 u16              *index,
+				 bool allow_lim_to_lim_match)
 {
 	struct ib_pkey_cache *cache;
 	unsigned long flags;
@@ -1013,7 +1014,11 @@ int ib_find_cached_pkey(struct ib_device *device,
 				partial_ix = i;
 		}
 
-	if (ret && partial_ix >= 0) {
+	/*
+	 * If table content is limited, pkey must be full to match,
+	 * unless allow_lim_to_lim_match is set
+	 */
+	if (ret && partial_ix >= 0 && (pkey & 0x8000 || allow_lim_to_lim_match)) {
 		*index = partial_ix;
 		ret = 0;
 	}
@@ -1022,6 +1027,23 @@ int ib_find_cached_pkey(struct ib_device *device,
 
 	return ret;
 }
+
+int ib_find_matched_cached_pkey(struct ib_device *device,
+				u8                port_num,
+				u16               pkey,
+				u16              *index)
+{
+	return __ib_find_cached_pkey(device, port_num, pkey, index, false);
+}
+EXPORT_SYMBOL(ib_find_matched_cached_pkey);
+
+int ib_find_cached_pkey(struct ib_device *device,
+			u8                port_num,
+			u16               pkey,
+			u16              *index)
+{
+	return __ib_find_cached_pkey(device, port_num, pkey, index, true);
+}
 EXPORT_SYMBOL(ib_find_cached_pkey);
 
 int ib_find_exact_cached_pkey(struct ib_device *device,
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index eb49cc8d1f95..748bd27559b6 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -92,6 +92,24 @@ int ib_get_cached_pkey(struct ib_device    *device_handle,
 		       u16                 *pkey);
 
 /**
+ * ib_find_matched_cached_pkey - Returns the PKey table index where a
+ * specified PKey value occurs. Success requires at least one of the
+ * PKeys to be a full-member.
+ * @device: The device to query.
+ * @port_num: The port number of the device to search for the PKey.
+ * @pkey: The PKey value to search for.
+ * @index: The index into the cached PKey table where the PKey was found.
+ *
+ * ib_find_matched_cached_pkey() searches the specified PKey table in
+ * the local software cache and return success unless both PKeys are
+ * limited.
+ */
+int ib_find_matched_cached_pkey(struct ib_device    *device,
+				u8		     port_num,
+				u16		     pkey,
+				u16		    *index);
+
+/**
  * ib_find_cached_pkey - Returns the PKey table index where a specified
  *   PKey value occurs.
  * @device: The device to query.
-- 
2.13.6
