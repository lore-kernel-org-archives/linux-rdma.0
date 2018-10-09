From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH  v3 2/2] IB/mlx4: Add port and TID to MAD debug print
Date: Tue,  9 Oct 2018 15:27:40 +0200
Message-ID: <20181009132740.2210085-3-Haakon.Bugge@oracle.com>
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

Add said information and make the debug print format consistent.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Acked-by: Leon Romanovsky <leonro@mellanox.com>

---

v1 -> v2:
    * Fixed incorrect format for printing the TID
v2 -> v3:
    * Added Leon's a-b
---
 drivers/infiniband/hw/mlx4/mad.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1718715cc094..8942f5f7f04d 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -808,14 +808,16 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	struct ib_port_attr pattr;
 
 	if (in_wc && in_wc->qp) {
-		pr_debug("received MAD: slid:%d sqpn:%d "
-			"dlid_bits:%d dqpn:%d wc_flags:0x%x, cls %x, mtd %x, atr %x\n",
-			in_wc->slid, in_wc->src_qp,
-			in_wc->dlid_path_bits,
-			in_wc->qp->qp_num,
-			in_wc->wc_flags,
-			in_mad->mad_hdr.mgmt_class, in_mad->mad_hdr.method,
-			be16_to_cpu(in_mad->mad_hdr.attr_id));
+		pr_debug("received MAD: port:%d slid:%d sqpn:%d "
+			 "dlid_bits:%d dqpn:%d wc_flags:0x%x tid:%016llx cls:%x mtd:%x atr:%x\n",
+			 port_num,
+			 in_wc->slid, in_wc->src_qp,
+			 in_wc->dlid_path_bits,
+			 in_wc->qp->qp_num,
+			 in_wc->wc_flags,
+			 be64_to_cpu(in_mad->mad_hdr.tid),
+			 in_mad->mad_hdr.mgmt_class, in_mad->mad_hdr.method,
+			 be16_to_cpu(in_mad->mad_hdr.attr_id));
 		if (in_wc->wc_flags & IB_WC_GRH) {
 			pr_debug("sgid_hi:0x%016llx sgid_lo:0x%016llx\n",
 				 be64_to_cpu(in_grh->sgid.global.subnet_prefix),
-- 
2.14.3
