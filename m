From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 0/3] Enable LSO and Checksum for IPoIB over mlx5
Date: Sun, 21 Feb 2016 16:27:15 +0200
Message-ID: <1456064838-31710-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch set exposes the UD QP's HW abilities to receive CSUM and LSO.
When these offloads are enabled, IPoIB over mlx5 (when uses UD QP) can benefit
from the above without additional changes in the IPoIB code.

The first patch in the series "IB/mlx5: Define mlx5 interface bits for IPoIB
offloads" is on top of the next patch "[PATCH net V2 1/3] net/mlx5: Use offset
based reserved field names in the IFC header file" that was sent to "net"
branch.
(see http://www.spinics.net/lists/netdev/msg362410.html
 see http://www.spinics.net/lists/netdev/msg363553.html)

Changes from v0:
	Fixed variable type from u16 to u64
	Returned back empty line.
	sync capability bit from new FW
	Change "likely" to "unlikely".

Changes from v1:
	Reviewed by was added
	Removed two wrongly exposed capability bits
	Rework QP UD LSO create flag checks
	Performance optimization of set_eth_seg

Thanks,
Eran and Erez.

Erez Shitrit (3):
  IB/mlx5: Define interface bits for IPoIB offloads
  IB/mlx5: Implement UD QP offloads for IPoIB in the TX flow
  IB/mlx5: Add support for CSUM in RX flow

 drivers/infiniband/hw/mlx5/cq.c      |   5 +-
 drivers/infiniband/hw/mlx5/main.c    |   5 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  11 ++--
 drivers/infiniband/hw/mlx5/qp.c      | 113 ++++++++++++++++++++++++++++++++---
 include/linux/mlx5/mlx5_ifc.h        |   6 +-
 5 files changed, 125 insertions(+), 15 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
