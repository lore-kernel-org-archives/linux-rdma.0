From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next v1 0/2] Advertise atomic operations support in mlx5
Date: Mon, 14 Dec 2015 16:34:08 +0200
Message-ID: <1450103650-16857-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch set adds the functionality to advertise standard atomic operations
capabilities for mlx5 driver.  The Hardware can be configured to work in two
modes according to the device capabilities: 1. Big Endian requestor respond 2.
Host Endian requestor respond

If the firmware supports host endianness, try to configure the hardware to work
this way, and on success propagate this capability to the upper layers,
otherwise advertise that atomic operations aren't supported.

Thanks, Eran

Changes from v0:
	- Rewrite the commit message of the second patch in the series


Eran Ben Elisha (2):
  net/mlx5_core: Configure HW to support atomic request in host
    endianness
  IB/mlx5: Advertise atomic capabilities in query device

 drivers/infiniband/hw/mlx5/main.c              | 28 ++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 57 +++++++++++++++++++++++++-
 include/linux/mlx5/driver.h                    |  5 +++
 include/linux/mlx5/mlx5_ifc.h                  | 22 ++++++----
 4 files changed, 102 insertions(+), 10 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
