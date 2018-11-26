From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/13] Mellanox, mlx5 core driver events API
Date: Mon, 26 Nov 2018 14:38:55 -0800
Message-ID: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patchset is for mlx5-next shared branch, and will be applied there
once the review is done.

The main idea of this change is to define a flexible scalable and
simpler high level mlx5 core APIs to forward device and driver events 
to upper level interface drivers e.g mlx5_ib and mlx5e netdevice driver.

Patch #1, Driver events notifier API:
    
Use atomic notifier chain to fire events to mlx5 core driver
consumers (mlx5e/mlx5_ib) and provide dynamic mlx5 register/unregister
notifier API to replace the internal mlx5_interface->event and totally
remove it.

Patch #2, Forward port events via the new notifier chain.
Patch #3, Use the mlx5 events API in mlx5e netdevice.
Patch #4, Forward all device events sent via mlx5_core_event (old API)
to the new notifier chain, this will allow seamless transition to the
new AP.
Patch #5, Use the new events API in mlx5_IB
Patch #6, remove old interface callback, mlx5_interface->event
Patch #7,8,9, mlx5_ib to handle raw FW events as is rather than the
software version of them, this will remove any need for unnecessary
processing of FW events in the low level mlx5_core driver.
Patch #10, Remove unnecessary processing of FW events in the low level
mlx5_core driver, all events are handled on demand by mlx5_ib and/or
mlx5e netdevice.

patch #11,12, forward QP and SRQ events via the new notifier chain,
will be needed by mlx5_ib driver.

Patch #13, Debug patch for mlx5 events.

Thanks,
Saeed.

---

Saeed Mahameed (13):
  net/mlx5: Driver events notifier API
  net/mlx5: Allow port change event to be forwarded to driver notifiers
    chain
  net/mlx5e: Use the new mlx5 core notifier API
  net/mlx5: Forward all mlx5 events to mlx5 notifiers chain
  IB/mlx5: Use the new mlx5 core notifier API
  net/mlx5: Remove unused events callback and logic
  IB/mlx5: Handle raw port change event rather than the software version
  net/mlx5: Allow forwarding event type general event as is
  IB/mlx5: Handle raw delay drop general event
  net/mlx5: Remove all deprecated software versions of FW events
  net/mlx5: Forward QP/WorkQueues resource events
  net/mlx5: Forward SRQ resource events
  net/mlx5: Debug print for forwarded async events

 drivers/infiniband/hw/mlx5/main.c             | 179 +++++++++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 106 +----------
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  27 +--
 .../net/ethernet/mellanox/mlx5/core/events.c  | 150 ++++++---------
 .../net/ethernet/mellanox/mlx5/core/health.c  |   3 +-
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  10 -
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/srq.c |  38 +---
 include/linux/mlx5/driver.h                   |  30 +--
 13 files changed, 235 insertions(+), 326 deletions(-)

-- 
2.19.1
