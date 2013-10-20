From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm]  osm_pkey.c: Fix find common pkey bug fix
Date: Sun, 20 Oct 2013 08:30:08 -0400
Message-ID: <5263CCD0.2010605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When OpenSM supports keeping both full and limited membership pkeys
for same port, search common pkey algorithm might miss a pkey shared
by two ports.

OpenSM iterates over pkey table of both ports, trying to find a
matching pkey, where the pkeys are sorted by network order value of
the pkeys (including membership bit).

When OpenSM searches for the shared pkey, it advances the iterator with
the lower key value. when comparing the keys without ignoring the
membership bit, OpenSM might miss a shared pkey.

For example:
Port 1 pkeys : 0x0081 0x0082
Port 2 pkeys : 0x0002 0x0003

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 4f5aa73..7a24156 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -430,8 +430,8 @@ ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
 			return *pkey1;
 
 		/* advance the lower value if they are not equal */
-		pkey1_base = cl_map_key(map_iter1);
-		pkey2_base = cl_map_key(map_iter2);
+		pkey1_base = ib_pkey_get_base(cl_map_key(map_iter1));
+		pkey2_base = ib_pkey_get_base(cl_map_key(map_iter2));
 		if (pkey2_base == pkey1_base) {
 			map_iter1 = cl_map_next(map_iter1);
 			map_iter2 = cl_map_next(map_iter2);
@@ -463,8 +463,8 @@ ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
 			return *pkey1;
 
 		/* advance the lower value if they are not equal */
-		pkey1_base = cl_map_key(map_iter1);
-		pkey2_base = cl_map_key(map_iter2);
+		pkey1_base = ib_pkey_get_base(cl_map_key(map_iter1));
+		pkey2_base = ib_pkey_get_base(cl_map_key(map_iter2));
 		if (pkey2_base == pkey1_base) {
 			map_iter1 = cl_map_next(map_iter1);
 			map_iter2 = cl_map_next(map_iter2);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
