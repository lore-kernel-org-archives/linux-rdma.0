From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/core: add the function ib_mtu_int_to_enum
Date: Mon, 26 Dec 2016 08:40:57 +0200
Message-ID: <1482734458-32131-2-git-send-email-Ram.Amrani@cavium.com>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482734458-32131-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As the functionality to convert the MTU from a number to enum_ib_mtu
is ubiquitous, define a dedicated function and remove the duplicated
code.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 11 +----------
 drivers/infiniband/hw/cxgb4/provider.c      | 11 +----------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   | 11 +----------
 drivers/infiniband/hw/nes/nes_verbs.c       | 12 +-----------
 include/rdma/ib_verbs.h                     | 14 ++++++++++++++
 5 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index cba57bb..ebb74a2 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1134,16 +1134,7 @@ static int iwch_query_port(struct ib_device *ibdev,
 
 	memset(props, 0, sizeof(struct ib_port_attr));
 	props->max_mtu = IB_MTU_4096;
-	if (netdev->mtu >= 4096)
-		props->active_mtu = IB_MTU_4096;
-	else if (netdev->mtu >= 2048)
-		props->active_mtu = IB_MTU_2048;
-	else if (netdev->mtu >= 1024)
-		props->active_mtu = IB_MTU_1024;
-	else if (netdev->mtu >= 512)
-		props->active_mtu = IB_MTU_512;
-	else
-		props->active_mtu = IB_MTU_256;
+	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
 
 	if (!netif_carrier_ok(netdev))
 		props->state = IB_PORT_DOWN;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 645e606..8456fe3 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -359,16 +359,7 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 
 	memset(props, 0, sizeof(struct ib_port_attr));
 	props->max_mtu = IB_MTU_4096;
-	if (netdev->mtu >= 4096)
-		props->active_mtu = IB_MTU_4096;
-	else if (netdev->mtu >= 2048)
-		props->active_mtu = IB_MTU_2048;
-	else if (netdev->mtu >= 1024)
-		props->active_mtu = IB_MTU_1024;
-	else if (netdev->mtu >= 512)
-		props->active_mtu = IB_MTU_512;
-	else
-		props->active_mtu = IB_MTU_256;
+	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
 
 	if (!netif_carrier_ok(netdev))
 		props->state = IB_PORT_DOWN;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..0f7c5bf 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -99,16 +99,7 @@ static int i40iw_query_port(struct ib_device *ibdev,
 	memset(props, 0, sizeof(*props));
 
 	props->max_mtu = IB_MTU_4096;
-	if (netdev->mtu >= 4096)
-		props->active_mtu = IB_MTU_4096;
-	else if (netdev->mtu >= 2048)
-		props->active_mtu = IB_MTU_2048;
-	else if (netdev->mtu >= 1024)
-		props->active_mtu = IB_MTU_1024;
-	else if (netdev->mtu >= 512)
-		props->active_mtu = IB_MTU_512;
-	else
-		props->active_mtu = IB_MTU_256;
+	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
 
 	props->lid = 1;
 	if (netif_carrier_ok(iwdev->netdev))
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index bd69125..0e23660 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -478,17 +478,7 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	memset(props, 0, sizeof(*props));
 
 	props->max_mtu = IB_MTU_4096;
-
-	if (netdev->mtu  >= 4096)
-		props->active_mtu = IB_MTU_4096;
-	else if (netdev->mtu  >= 2048)
-		props->active_mtu = IB_MTU_2048;
-	else if (netdev->mtu  >= 1024)
-		props->active_mtu = IB_MTU_1024;
-	else if (netdev->mtu  >= 512)
-		props->active_mtu = IB_MTU_512;
-	else
-		props->active_mtu = IB_MTU_256;
+	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
 
 	props->lid = 1;
 	props->lmc = 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..e0551a1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -352,6 +352,20 @@ static inline int ib_mtu_enum_to_int(enum ib_mtu mtu)
 	}
 }
 
+static inline enum ib_mtu ib_mtu_int_to_enum(int mtu)
+{
+	if (mtu >= 4096)
+		return IB_MTU_4096;
+	else if (mtu >= 2048)
+		return IB_MTU_2048;
+	else if (mtu >= 1024)
+		return IB_MTU_1024;
+	else if (mtu >= 512)
+		return IB_MTU_512;
+	else
+		return IB_MTU_256;
+}
+
 enum ib_port_state {
 	IB_PORT_NOP		= 0,
 	IB_PORT_DOWN		= 1,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
