From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 86/97] IB/usnic: Fix potential deadlock
Date: Tue,  8 Jan 2019 14:29:35 -0500
Message-ID: <20190108192949.122407-86-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Parvi Kaustubhi <pkaustub@cisco.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Parvi Kaustubhi <pkaustub@cisco.com>

[ Upstream commit 8036e90f92aae2784b855a0007ae2d8154d28b3c ]

Acquiring the rtnl lock while holding usdev_lock could result in a
deadlock.

For example:

usnic_ib_query_port()
| mutex_lock(&us_ibdev->usdev_lock)
 | ib_get_eth_speed()
  | rtnl_lock()

rtnl_lock()
| usnic_ib_netdevice_event()
 | mutex_lock(&us_ibdev->usdev_lock)

This commit moves the usdev_lock acquisition after the rtnl lock has been
released.

This is safe to do because usdev_lock is not protecting anything being
accessed in ib_get_eth_speed(). Hence, the correct order of holding locks
(rtnl -> usdev_lock) is not violated.

Signed-off-by: Parvi Kaustubhi <pkaustub@cisco.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 9973ac893635..3db232429630 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -334,13 +334,16 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 
 	usnic_dbg("\n");
 
-	mutex_lock(&us_ibdev->usdev_lock);
 	if (ib_get_eth_speed(ibdev, port, &props->active_speed,
-			     &props->active_width)) {
-		mutex_unlock(&us_ibdev->usdev_lock);
+			     &props->active_width))
 		return -EINVAL;
-	}
 
+	/*
+	 * usdev_lock is acquired after (and not before) ib_get_eth_speed call
+	 * because acquiring rtnl_lock in ib_get_eth_speed, while holding
+	 * usdev_lock could lead to a deadlock.
+	 */
+	mutex_lock(&us_ibdev->usdev_lock);
 	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->lid = 0;
-- 
2.19.1
