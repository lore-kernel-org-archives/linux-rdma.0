From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] RDMA/qedr: Remove enumerated type qed_roce_ll2_tx_dest
Date: Thu, 27 Sep 2018 13:55:58 -0700
Message-ID: <20180927205557.32026-1-natechancellor@gmail.com>
References: <20180927011820.13608-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927011820.13608-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Clang warns when one enumerated type is explicitly converted to another.

drivers/infiniband/hw/qedr/qedr_roce_cm.c:198:28: warning: implicit
conversion from enumeration type 'enum qed_roce_ll2_tx_dest' to
different enumeration type 'enum qed_ll2_tx_dest' [-Wenum-conversion]
        ll2_tx_pkt.tx_dest = pkt->tx_dest;
                           ~ ~~~~~^~~~~~~
1 warning generated.

Turns out that QED_ROCE_LL2_TX_DEST_NW and QED_ROCE_LL2_TX_DEST_LB are
only used once in the whole tree and QED_ROCE_LL2_TX_DEST_MAX is used
nowhere. Remove them and use the equivalent values from qed_ll2_tx_dest
in their place.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Rather than using an explicit cast, just convert the uses to the
  appropriate values and delete the duplicated enum.

 drivers/infiniband/hw/qedr/qedr_roce_cm.c |  4 ++--
 include/linux/qed/qed_rdma_if.h           | 11 +----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_roce_cm.c b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
index 85578887421b..e1ac2fd60bb1 100644
--- a/drivers/infiniband/hw/qedr/qedr_roce_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
@@ -519,9 +519,9 @@ static inline int qedr_gsi_build_packet(struct qedr_dev *dev,
 	}
 
 	if (ether_addr_equal(udh.eth.smac_h, udh.eth.dmac_h))
-		packet->tx_dest = QED_ROCE_LL2_TX_DEST_LB;
+		packet->tx_dest = QED_LL2_TX_DEST_LB;
 	else
-		packet->tx_dest = QED_ROCE_LL2_TX_DEST_NW;
+		packet->tx_dest = QED_LL2_TX_DEST_NW;
 
 	packet->roce_mode = roce_mode;
 	memcpy(packet->header.vaddr, ud_header_buffer, header_size);
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index df4d13f7e191..d15f8e4815e3 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -39,15 +39,6 @@
 #include <linux/qed/qed_ll2_if.h>
 #include <linux/qed/rdma_common.h>
 
-enum qed_roce_ll2_tx_dest {
-	/* Light L2 TX Destination to the Network */
-	QED_ROCE_LL2_TX_DEST_NW,
-
-	/* Light L2 TX Destination to the Loopback */
-	QED_ROCE_LL2_TX_DEST_LB,
-	QED_ROCE_LL2_TX_DEST_MAX
-};
-
 #define QED_RDMA_MAX_CNQ_SIZE               (0xFFFF)
 
 /* rdma interface */
@@ -581,7 +572,7 @@ struct qed_roce_ll2_packet {
 	int n_seg;
 	struct qed_roce_ll2_buffer payload[RDMA_MAX_SGE_PER_SQ_WQE];
 	int roce_mode;
-	enum qed_roce_ll2_tx_dest tx_dest;
+	enum qed_ll2_tx_dest tx_dest;
 };
 
 enum qed_rdma_type {
-- 
2.19.0
