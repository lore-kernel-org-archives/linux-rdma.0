From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH  v3 1/2] IB/mlx4: Enable debug print of SMPs
Date: Tue,  9 Oct 2018 15:27:39 +0200
Message-ID: <20181009132740.2210085-2-Haakon.Bugge@oracle.com>
References: <20181009132740.2210085-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009132740.2210085-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: leon@kernel.org
List-Id: linux-rdma@vger.kernel.org

IB Subnet Management Packets (SMPs) were excluded from debug prints.

Fixed by enabling print even on QP0 MADs.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>

---

v1 -> v3:
   * No changes
---
 drivers/infiniband/hw/mlx4/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index e5466d786bb1..1718715cc094 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -807,7 +807,7 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	int err;
 	struct ib_port_attr pattr;
 
-	if (in_wc && in_wc->qp->qp_num) {
+	if (in_wc && in_wc->qp) {
 		pr_debug("received MAD: slid:%d sqpn:%d "
 			"dlid_bits:%d dqpn:%d wc_flags:0x%x, cls %x, mtd %x, atr %x\n",
 			in_wc->slid, in_wc->src_qp,
-- 
2.14.3
