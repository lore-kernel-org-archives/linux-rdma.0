From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next v2 10/10] IB/core: Remove smac and vlan id from path record
Date: Thu, 15 Oct 2015 18:38:54 +0300
Message-ID: <1444923534-10882-11-git-send-email-matanb@mellanox.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The GID cache accompanies every GID with attributes.
The GID attributes link the GID with its netdevice, which could be
resolved to smac and vlan id easily. Since we've added the netdevice
(ifindex and net) to the path record, storing the L2 attributes is
duplicated data and hence these attributes are removed.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c             | 2 --
 drivers/infiniband/core/sa_query.c        | 2 --
 drivers/infiniband/core/uverbs_marshall.c | 2 --
 include/rdma/ib_sa.h                      | 2 --
 4 files changed, 8 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index bc11ea4..2914460 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2281,9 +2281,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		goto err2;
 	}
 
-	route->path_rec->vlan_id = rdma_vlan_dev_vlan_id(ndev);
 	memcpy(route->path_rec->dmac, addr->dev_addr.dst_dev_addr, ETH_ALEN);
-	memcpy(route->path_rec->smac, ndev->dev_addr, ndev->addr_len);
 
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
 		    &route->path_rec->sgid);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 77f5afc..dcdaa79 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1153,11 +1153,9 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 
 		ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table),
 			  mad->data, &rec);
-		rec.vlan_id = 0xffff;
 		rec.net = NULL;
 		rec.ifindex = 0;
 		memset(rec.dmac, 0, ETH_ALEN);
-		memset(rec.smac, 0, ETH_ALEN);
 		query->callback(status, &rec, query->context);
 	} else
 		query->callback(status, NULL, query->context);
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 484698c..7d2f14c 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -141,9 +141,7 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 
-	memset(dst->smac, 0, sizeof(dst->smac));
 	memset(dst->dmac, 0, sizeof(dst->dmac));
-	dst->vlan_id = 0xffff;
 	dst->net = NULL;
 	dst->ifindex = 0;
 }
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 406ecf1..3019695 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -155,9 +155,7 @@ struct ib_sa_path_rec {
 	u8           packet_life_time_selector;
 	u8           packet_life_time;
 	u8           preference;
-	u8           smac[ETH_ALEN];
 	u8           dmac[ETH_ALEN];
-	u16	     vlan_id;
 	/* ignored in IB */
 	int	     ifindex;
 	/* ignored in IB */
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
