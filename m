From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH] qed: qed_rdma_modify_srq() can be static
Date: Fri, 1 Jun 2018 11:41:22 +0800
Message-ID: <20180601034122.GA72995@lkp-sb05>
References: <20180530131137.4653-1-yuval.bason@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530131137.4653-1-yuval.bason@cavium.com>
Sender: netdev-owner@vger.kernel.org
Cc: kbuild-all@01.org, yuval.bason@cavium.com, davem@davemloft.net, netdev@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, Michal Kalderon <michal.kalderon@cavium.com>, Ariel Elior <ariel.elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org


Fixes: 27c50d39911b ("qed: Add srq core support for RoCE and iWARP")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 qed_rdma.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index bd23659..f118328 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1652,8 +1652,8 @@ static void *qed_rdma_get_rdma_ctx(struct qed_dev *cdev)
 	return QED_LEADING_HWFN(cdev);
 }
 
-int qed_rdma_modify_srq(void *rdma_cxt,
-			struct qed_rdma_modify_srq_in_params *in_params)
+static int qed_rdma_modify_srq(void *rdma_cxt,
+			       struct qed_rdma_modify_srq_in_params *in_params)
 {
 	struct rdma_srq_modify_ramrod_data *p_ramrod;
 	struct qed_hwfn *p_hwfn = rdma_cxt;
@@ -1688,8 +1688,8 @@ int qed_rdma_modify_srq(void *rdma_cxt,
 	return rc;
 }
 
-int qed_rdma_destroy_srq(void *rdma_cxt,
-			 struct qed_rdma_destroy_srq_in_params *in_params)
+static int qed_rdma_destroy_srq(void *rdma_cxt,
+				struct qed_rdma_destroy_srq_in_params *in_params)
 {
 	struct rdma_srq_destroy_ramrod_data *p_ramrod;
 	struct qed_hwfn *p_hwfn = rdma_cxt;
@@ -1731,9 +1731,9 @@ int qed_rdma_destroy_srq(void *rdma_cxt,
 	return rc;
 }
 
-int qed_rdma_create_srq(void *rdma_cxt,
-			struct qed_rdma_create_srq_in_params *in_params,
-			struct qed_rdma_create_srq_out_params *out_params)
+static int qed_rdma_create_srq(void *rdma_cxt,
+			       struct qed_rdma_create_srq_in_params *in_params,
+			       struct qed_rdma_create_srq_out_params *out_params)
 {
 	struct rdma_srq_create_ramrod_data *p_ramrod;
 	struct qed_hwfn *p_hwfn = rdma_cxt;
