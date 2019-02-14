From: Raju Rangoju <rajur@chelsio.com>
Subject: [rdma-rc PATCH 1/2] cxgb4: export sge_host_page_size to ulds
Date: Thu, 14 Feb 2019 17:40:53 +0530
Message-ID: <20190214121054.11693-2-rajur@chelsio.com>
References: <20190214121054.11693-1-rajur@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190214121054.11693-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: jgg@mellanox.com, davem@davemloft.net, linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org, swise@opengridcomputing.com, rajur@chelsio.com
List-Id: linux-rdma@vger.kernel.org

Export the sge_host_page_size field to ULDs via
cxgb4_lld_info, so that iw_cxgb4 can make use of
this in calculating the correct qp/cq mask.

Fixes: 2391b0030e ("cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page
size")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index c041f44324db..b3654598a2d5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -660,6 +660,7 @@ static void uld_init(struct adapter *adap, struct cxgb4_lld_info *lld)
 	lld->cclk_ps = 1000000000 / adap->params.vpd.cclk;
 	lld->udb_density = 1 << adap->params.sge.eq_qpp;
 	lld->ucq_density = 1 << adap->params.sge.iq_qpp;
+	lld->sge_host_page_size = 1 << (adap->params.sge.hps + 10);
 	lld->filt_mode = adap->params.tp.vlan_pri_map;
 	/* MODQ_REQ_MAP sets queues 0-3 to chan 0-3 */
 	for (i = 0; i < NCHAN; i++)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 5fa9a2d5fc4b..21da34a4ca24 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -336,6 +336,7 @@ struct cxgb4_lld_info {
 	unsigned int cclk_ps;                /* Core clock period in psec */
 	unsigned short udb_density;          /* # of user DB/page */
 	unsigned short ucq_density;          /* # of user CQs/page */
+	unsigned int sge_host_page_size;     /* SGE host page size */
 	unsigned short filt_mode;            /* filter optional components */
 	unsigned short tx_modq[NCHAN];       /* maps each tx channel to a */
 					     /* scheduler queue */
-- 
2.13.0
