From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] RDMA/qedr: Explicitly cast pkt->tx_dest to qed_ll2_tx_dest
Date: Wed, 26 Sep 2018 18:18:20 -0700
Message-ID: <20180927011820.13608-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
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

Avoid this warning by explicitly casting pkt->tx_dest to
qed_112_tx_dest, which has the expected values from the
type qed_roce_ll2_tx_dest.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/infiniband/hw/qedr/qedr_roce_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_roce_cm.c b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
index 85578887421b..147e0d69003d 100644
--- a/drivers/infiniband/hw/qedr/qedr_roce_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
@@ -195,7 +195,7 @@ static int qedr_ll2_post_tx(struct qedr_dev *dev,
 
 	ll2_tx_pkt.num_of_bds = 1 /* hdr */  + pkt->n_seg;
 	ll2_tx_pkt.vlan = 0;
-	ll2_tx_pkt.tx_dest = pkt->tx_dest;
+	ll2_tx_pkt.tx_dest = (enum qed_ll2_tx_dest)pkt->tx_dest;
 	ll2_tx_pkt.qed_roce_flavor = roce_flavor;
 	ll2_tx_pkt.first_frag = pkt->header.baddr;
 	ll2_tx_pkt.first_frag_len = pkt->header.len;
-- 
2.19.0
