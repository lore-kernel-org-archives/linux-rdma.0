From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: [PATCH] mlx4_en: Fix out of bounds array access
Date: Mon, 25 Oct 2010 14:56:47 +0200
Message-ID: <20101025125647.GA7710@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, yevgenyp@mellanox.co.il
Cc: Roland Dreier <rdreier@cisco.com>, RDMA list <linux-rdma@vger.kernel.org>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

When searching for a free entry in either mlx4_register_vlan() or
mlx4_register_mac(), and there is no free entry, the loop terminates without
updating the local variable free thus causing out of array bounds access. Fix
this by adding a proper check outside the loop.

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
---
 drivers/net/mlx4/port.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 56371ef..4513395 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -111,6 +111,12 @@ int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *index)
 			goto out;
 		}
 	}
+
+	if (free < 0) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	mlx4_dbg(dev, "Free MAC index is %d\n", free);
 
 	if (table->total == table->max) {
@@ -224,6 +230,11 @@ int mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan, int *index)
 		}
 	}
 
+	if (free < 0) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	if (table->total == table->max) {
 		/* No free vlan entries */
 		err = -ENOSPC;
-- 
1.7.3.1

