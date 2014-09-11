From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/5] mlx4: Fix mlx4 reg/unreg mac to work properly with 0-mac addresses
Date: Thu, 11 Sep 2014 14:11:16 +0300
Message-ID: <1410433880-12439-2-git-send-email-ogerlitz@mellanox.com>
References: <1410433880-12439-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410433880-12439-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

There is a chance that the VF mlx4 RoCE driver (mlx4_ib) may see a 0-mac
as the current default MAC address when a RoCE interface first comes up.

In this case, the RoCE driver registers the 0-mac to get its MAC index --
used in the INIT2RTR transition when it creates its proxy Q1 qp's.

If we do not allow QP1 to be created, the RoCE driver will not come up.
If we do not register the 0-mac, but simply use a random mac-index,
QP1 will attempt to send packets with an someone's else source MAC which
will get the system into more troubled.

Since a 0-mac was previously used to indicate a free slot, this leads to
errors, both when the 0-mac is registered and when it is unregistered.

The required fix is to check in addition that the slot containing the
0-mac has a reference count of zero.

Additionally, when comparing MAC addresses, need to mask out the 2 MSBs
of the u64 mac on both sides of the comparison.

Note that when the EN driver (mlx4_en) comes up, it set itself a proper
mac --> the RoCE driver gets to be notified on that and further handing
is done with the update qp command, as was added by commit 9433c18
"IB/mlx4: Invoke UPDATE_QP for proxy QP1 on MAC changes".

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/port.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 7ab9717..ddf5f21 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -103,7 +103,8 @@ static int find_index(struct mlx4_dev *dev,
 	int i;
 
 	for (i = 0; i < MLX4_MAX_MAC_NUM; i++) {
-		if ((mac & MLX4_MAC_MASK) ==
+		if (table->refs[i] &&
+		    (MLX4_MAC_MASK & mac) ==
 		    (MLX4_MAC_MASK & be64_to_cpu(table->entries[i])))
 			return i;
 	}
@@ -165,12 +166,14 @@ int __mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac)
 
 	mutex_lock(&table->mutex);
 	for (i = 0; i < MLX4_MAX_MAC_NUM; i++) {
-		if (free < 0 && !table->entries[i]) {
-			free = i;
+		if (!table->refs[i]) {
+			if (free < 0)
+				free = i;
 			continue;
 		}
 
-		if (mac == (MLX4_MAC_MASK & be64_to_cpu(table->entries[i]))) {
+		if ((MLX4_MAC_MASK & mac) ==
+		     (MLX4_MAC_MASK & be64_to_cpu(table->entries[i]))) {
 			/* MAC already registered, increment ref count */
 			err = i;
 			++table->refs[i];
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
