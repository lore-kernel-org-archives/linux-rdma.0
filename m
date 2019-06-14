From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 11/39] IB/rdmavt: Fix alloc_qpn() WARN_ON()
Date: Fri, 14 Jun 2019 16:29:16 -0400
Message-ID: <20190614202946.27385-11-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 2abae62a26a265129b364d8c1ef3be55e2c01309 ]

The qpn allocation logic has a WARN_ON() that intends to detect the use of
an index that will introduce bits in the lower order bits of the QOS bits
in the QPN.

Unfortunately, it has the following bugs:
- it misfires when wrapping QPN allocation for non-QOS
- it doesn't correctly detect low order QOS bits (despite the comment)

The WARN_ON() should not be applied to non-QOS (qos_shift == 1).

Additionally, it SHOULD test the qpn bits per the table below:

2 data VLs:   [qp7, qp6, qp5, qp4, qp3, qp2, qp1] ^
              [  0,   0,   0,   0,   0,   0, sc0],  qp bit 1 always 0*
3-4 data VLs: [qp7, qp6, qp5, qp4, qp3, qp2, qp1] ^
              [  0,   0,   0,   0,   0, sc1, sc0], qp bits [21] always 0
5-8 data VLs: [qp7, qp6, qp5, qp4, qp3, qp2, qp1] ^
              [  0,   0,   0,   0, sc2, sc1, sc0] qp bits [321] always 0

Fix by qualifying the warning for qos_shift > 1 and producing the correct
mask to insure the above bits are zero without generating a superfluous
warning.

Fixes: 501edc42446e ("IB/rdmavt: Correct warning during QPN allocation")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 5ce403c6cddb..7d03680afd91 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -412,7 +412,8 @@ static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 			offset = qpt->incr | ((offset & 1) ^ 1);
 		}
 		/* there can be no set bits in low-order QoS bits */
-		WARN_ON(offset & (BIT(rdi->dparms.qos_shift) - 1));
+		WARN_ON(rdi->dparms.qos_shift > 1 &&
+			offset & ((BIT(rdi->dparms.qos_shift - 1) - 1) << 1));
 		qpn = mk_qpn(qpt, map, offset);
 	}
 
-- 
2.20.1
