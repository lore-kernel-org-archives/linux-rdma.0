From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Add raw ethernet local loopback
Date: Tue, 30 May 2017 09:42:52 +0300
Message-ID: <20170530064255.3745-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

The following patch set from Huy adds ability to disable/enable
raw ethernet loopbacks based on actual number of user contexts.

The one or less user space context simply says that no actual consumer
of this packets and they don't need to be forwarded to the vport.

After this patch set, the raw ethernet unicast and multicast
local loopbacks are disabled by default and packets are forwarded
to the next routing level (eswitch, or multihost switch, or out to the
wire depending on the configuration).

Available in the "topic/local_lb" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/local_lb

Possible merge conflicts resolution is available in:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=testing/queue-next

Huy Nguyen (3):
  net/mlx5: Add raw ethernet local loopback firmware command
  IB/mlx5: Add raw ethernet local loopback support
  net/mlx5e: Enable local loopback in loopback selftest

 drivers/infiniband/hw/mlx5/main.c                  | 51 ++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  | 13 +++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 19 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    | 62 ++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                      | 11 ++--
 include/linux/mlx5/vport.h                         |  3 +-
 7 files changed, 155 insertions(+), 8 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
