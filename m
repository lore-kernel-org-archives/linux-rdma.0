From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND V2 for-next 3/5] IB/core: Call ib_unregister_mad_agent() only for valid agents
Date: Thu,  5 Feb 2015 13:35:42 +0200
Message-ID: <1423136144-12784-4-git-send-email-ogerlitz@mellanox.com>
References: <1423136144-12784-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423136144-12784-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In some error flows, ib_mad_unregister_agent is being invoked also in cases where
the ib_mad_register_agent call failed (resulting in an illegal pointer in the
agent field).  This causes a kernel crash in the error flow.

Fix this by calling ib_unregister_mad_agent only for cases where
ib_register_mad_agent succeeded.

issue: 312895
Change-Id: Iaff4289ff3668e7ec91484f3d82a7d15f88678c8
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |    2 +-
 drivers/infiniband/hw/qib/qib_mad.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 82a7dd8..6be0d2c 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -907,7 +907,7 @@ int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
 err:
 	for (p = 0; p < dev->num_ports; ++p)
 		for (q = 0; q <= 1; ++q)
-			if (dev->send_agent[p][q])
+			if (!IS_ERR(dev->send_agent[p][q]))
 				ib_unregister_mad_agent(dev->send_agent[p][q]);
 
 	return ret;
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 8881fa3..5f1a7ce 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -317,7 +317,7 @@ int mthca_create_agents(struct mthca_dev *dev)
 err:
 	for (p = 0; p < dev->limits.num_ports; ++p)
 		for (q = 0; q <= 1; ++q)
-			if (dev->send_agent[p][q])
+			if (!IS_ERR(dev->send_agent[p][q]))
 				ib_unregister_mad_agent(dev->send_agent[p][q]);
 
 	return ret;
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 636be11..6c7cc80 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2499,7 +2499,7 @@ int qib_create_agents(struct qib_ibdev *dev)
 err:
 	for (p = 0; p < dd->num_pports; p++) {
 		ibp = &dd->pport[p].ibport_data;
-		if (ibp->send_agent) {
+		if (!IS_ERR(ibp->send_agent)) {
 			agent = ibp->send_agent;
 			ibp->send_agent = NULL;
 			ib_unregister_mad_agent(agent);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
