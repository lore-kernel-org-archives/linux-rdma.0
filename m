From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 09/16] RDMA/i40iw: Remove unused code and fix warning
Date: Mon, 18 Apr 2016 10:33:02 -0500
Message-ID: <1460993589-9428-10-git-send-email-mustafa.ismail@intel.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove unused code and fix warning.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h      |  2 --
 drivers/infiniband/hw/i40iw/i40iw_cm.c   |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.h   | 10 +---------
 drivers/infiniband/hw/i40iw/i40iw_main.c |  5 +----
 4 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index bf3627f..f299001 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -50,8 +50,6 @@
 #include <rdma/ib_pack.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/iw_cm.h>
-#include <rdma/iw_portmap.h>
-#include <rdma/rdma_netlink.h>
 #include <crypto/hash.h>
 
 #include "i40iw_status.h"
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index bdd4104..ab6eb0b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2107,7 +2107,7 @@ static bool i40iw_ipv6_is_loopback(u32 *loc_addr, u32 *rem_addr)
 	struct in6_addr raddr6;
 
 	i40iw_copy_ip_htonl(raddr6.in6_u.u6_addr32, rem_addr);
-	return (!memcmp(loc_addr, rem_addr, 16) || ipv6_addr_loopback(&raddr6));
+	return !memcmp(loc_addr, rem_addr, 16) || ipv6_addr_loopback(&raddr6);
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
index 5f8ceb4..e9046d9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
@@ -1,6 +1,6 @@
 /*******************************************************************************
 *
-* Copyright (c) 2015 Intel Corporation.  All rights reserved.
+* Copyright (c) 2015-2016 Intel Corporation.  All rights reserved.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
@@ -291,8 +291,6 @@ struct i40iw_cm_listener {
 	u8 loc_mac[ETH_ALEN];
 	u32 loc_addr[4];
 	u16 loc_port;
-	u32 map_loc_addr[4];
-	u16 map_loc_port;
 	struct iw_cm_id *cm_id;
 	atomic_t ref_count;
 	struct i40iw_device *iwdev;
@@ -317,8 +315,6 @@ struct i40iw_kmem_info {
 struct i40iw_cm_node {
 	u32 loc_addr[4], rem_addr[4];
 	u16 loc_port, rem_port;
-	u32 map_loc_addr[4], map_rem_addr[4];
-	u16 map_loc_port, map_rem_port;
 	u16 vlan_id;
 	enum i40iw_cm_node_state state;
 	u8 loc_mac[ETH_ALEN];
@@ -370,10 +366,6 @@ struct i40iw_cm_info {
 	u16 rem_port;
 	u32 loc_addr[4];
 	u32 rem_addr[4];
-	u16 map_loc_port;
-	u16 map_rem_port;
-	u32 map_loc_addr[4];
-	u32 map_rem_addr[4];
 	u16 vlan_id;
 	int backlog;
 	u16 user_pri;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 90e5af2..f49aea1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1147,10 +1147,7 @@ static enum i40iw_status_code i40iw_alloc_set_mac_ipaddr(struct i40iw_device *iw
 	if (!status) {
 		status = i40iw_add_mac_ipaddr_entry(iwdev, macaddr,
 						    (u8)iwdev->mac_ip_table_idx);
-		if (!status)
-			status = i40iw_add_mac_ipaddr_entry(iwdev, macaddr,
-							    (u8)iwdev->mac_ip_table_idx);
-		else
+		if (status)
 			i40iw_del_macip_entry(iwdev, (u8)iwdev->mac_ip_table_idx);
 	}
 	return status;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
