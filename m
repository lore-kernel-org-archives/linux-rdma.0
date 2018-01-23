From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH net 2/2] qed: Free reserved MR tid
Date: Tue, 23 Jan 2018 11:33:47 +0200
Message-ID: <1516700027-3361-3-git-send-email-Michal.Kalderon@cavium.com>
References: <1516700027-3361-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1516700027-3361-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@cavium.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@mellanox.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

A tid was allocated for reserved MR during initialization but
not freed. This lead to an annoying output message during
rdma unload flow.

Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 9d6e2d4..b7abb82 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -358,10 +358,27 @@ static void qed_rdma_resc_free(struct qed_hwfn *p_hwfn)
 	kfree(p_rdma_info);
 }
 
+static void qed_rdma_free_tid(void *rdma_cxt, u32 itid)
+{
+        struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
+
+        DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "itid = %08x\n", itid);
+
+        spin_lock_bh(&p_hwfn->p_rdma_info->lock);
+        qed_bmap_release_id(p_hwfn, &p_hwfn->p_rdma_info->tid_map, itid);
+        spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
+}
+
+static void qed_rdma_free_reserved_lkey(struct qed_hwfn *p_hwfn)
+{
+	qed_rdma_free_tid(p_hwfn, p_hwfn->p_rdma_info->dev->reserved_lkey);
+}
+
 static void qed_rdma_free(struct qed_hwfn *p_hwfn)
 {
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "Freeing RDMA\n");
 
+	qed_rdma_free_reserved_lkey(p_hwfn);
 	qed_rdma_resc_free(p_hwfn);
 }
 
@@ -794,17 +811,6 @@ static struct qed_rdma_device *qed_rdma_query_device(void *rdma_cxt)
 	return p_hwfn->p_rdma_info->dev;
 }
 
-static void qed_rdma_free_tid(void *rdma_cxt, u32 itid)
-{
-	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
-
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "itid = %08x\n", itid);
-
-	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
-	qed_bmap_release_id(p_hwfn, &p_hwfn->p_rdma_info->tid_map, itid);
-	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
-}
-
 static void qed_rdma_cnq_prod_update(void *rdma_cxt, u8 qz_offset, u16 prod)
 {
 	struct qed_hwfn *p_hwfn;
-- 
1.8.3.1
