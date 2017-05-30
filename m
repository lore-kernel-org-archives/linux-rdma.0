From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/5] Dropples RQ
Date: Tue, 30 May 2017 10:29:09 +0300
Message-ID: <20170530072914.9709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

>From Maor:
---
This series adding support to avoid RAW ethernet packet drops.

When packets received and there are no receive WQEs, then
the packets are dropped. In certain scenarios it may be preferred
to configure the device to avoid such packet drops, assuming
the posting of WQEs will resume shortly.

Under such configuration, when a packet is received for a
WQ with no receive WQEs, the packet processing is delayed
until receive WQEs are posted.

If receive WQEs are still not posted after a device configured
time, the packet is dropped.

To enable this delay drop feature on a WQ, the user should
set the IB_WQ_FLAGS_DELAY_DROP flag on creation.

---
Available in the "topic/dropless-rq" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/dropless-rq

Possible merge conflicts resolution is available in:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=testing/queue-next

Thanks

Maor Gottlieb (5):
  IB/core: Introduce delay drop for a WQ
  net/mlx5: Introduce set delay drop command
  net/mlx5: Introduce general notification event
  IB/mlx5: Add support to dropless RQ
  IB/mlx5: Add delay drop configuration and statistics

 drivers/infiniband/hw/mlx5/main.c            | 163 ++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  29 +++++
 drivers/infiniband/hw/mlx5/qp.c              |  50 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  23 ++++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c |  14 +++
 include/linux/mlx5/device.h                  |   5 +
 include/linux/mlx5/driver.h                  |   1 +
 include/linux/mlx5/mlx5_ifc.h                |  30 ++++-
 include/linux/mlx5/qp.h                      |   3 +
 include/rdma/ib_verbs.h                      |   5 +
 10 files changed, 313 insertions(+), 10 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
