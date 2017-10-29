From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] RDMA/bnxt_re: Remove unused vlan_tag variable
Date: Sun, 29 Oct 2017 17:05:22 +0200
Message-ID: <20171029150522.23641-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The Broadcom driver produces the following compilation warning

drivers/infiniband/hw/bnxt_re/ib_verbs.c:
	In function ‘bnxt_re_create_ah’:
drivers/infiniband/hw/bnxt_re/ib_verbs.c:668:6:
	warning: variable ‘vlan_tag’ set but not used [-Wunused-but-set-variable]
	u16 vlan_tag;

Let's remove it till vlan_tag will be implemented properly.

Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ebcdfb4f5f75..39e49d0e8467 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -665,7 +665,6 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd *ib_pd,
 	struct bnxt_re_ah *ah;
 	const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
 	int rc;
-	u16 vlan_tag;
 	u8 nw_type;

 	struct ib_gid_attr sgid_attr;
@@ -711,11 +710,8 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd *ib_pd,
 				grh->sgid_index);
 			goto fail;
 		}
-		if (sgid_attr.ndev) {
-			if (is_vlan_dev(sgid_attr.ndev))
-				vlan_tag = vlan_dev_vlan_id(sgid_attr.ndev);
+		if (sgid_attr.ndev)
 			dev_put(sgid_attr.ndev);
-		}
 		/* Get network header type for this GID */
 		nw_type = ib_gid_to_network_type(sgid_attr.gid_type, &sgid);
 		switch (nw_type) {
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
