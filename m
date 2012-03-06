From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH][TRIVIAL] include/opensm/osm_subnet.h: fix comment typos
Date: Mon, 05 Mar 2012 17:39:18 -0800
Message-ID: <1330997958.4779.1586.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index e444ee5..219dfb3 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -572,19 +572,19 @@ typedef struct osm_subn {
 /*
 * FIELDS
 *	sw_guid_tbl
-*		Container of pointers to all Switch objects in the subent.
+*		Container of pointers to all Switch objects in the subnet.
 *		Indexed by node GUID.
 *
 *	node_guid_tbl
-*		Container of pointers to all Node objects in the subent.
+*		Container of pointers to all Node objects in the subnet.
 *		Indexed by node GUID.
 *
 *	port_guid_tbl
-*		Container of pointers to all Port objects in the subent.
+*		Container of pointers to all Port objects in the subnet.
 *		Indexed by port GUID - network order!
 *
 *	rtr_guid_tbl
-*		Container of pointers to all Router objects in the subent.
+*		Container of pointers to all Router objects in the subnet.
 *		Indexed by node GUID.
 *
 *	prtn_pkey_tbl
@@ -596,7 +596,7 @@ typedef struct osm_subn {
 *		on the subnet.
 *
 *	port_lid_tbl
-*		Container of pointers to all Port objects in the subent.
+*		Container of pointers to all Port objects in the subnet.
 *		Indexed by port LID.
 *
 *	master_sm_base_lid
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
