From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/11] mlx5 core internal firmware events handling improvements
Date: Tue, 20 Nov 2018 14:12:17 -0800
Message-ID: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi

This patchset is for mlx5-next shared branch, and will be applied there
once the review is done.

The main idea of this change is to define a flexible scalable and
simpler low level mlx5 core APIs to upper level components for better
features decoupling and maximum code locality and modularity.

Improve and simplify mlx5 core internal firmware and device async events
handling and subscription, currently all async firmware events are
handled in one place (switch case in eq.c) and every time we need to
update one of the mlx5_core handlers or add new events handling to the
system, the driver needs to be changed in many places in order to deliver
the new event to its consumer.

To improve this we will use atomic_notifier_chain to fire firmware events
at internal mlx5 core components such as eswitch/fpga/clock/FW tracer/etc..,
this is to avoid explicit calls from low level mlx5_core to upper components
and to simplify the mlx5_core API for future developments.
    
Provide register/unregister notifiers API and call the notifier chain on
firmware async events.
    
Example to subscribe to a FW event:

struct mlx5_nb port_event;
    
MLX5_NB_INIT(&port_event, port_event_handler, PORT_CHANGE);
mlx5_eq_notifier_register(mdev, &port_event);
    
Where:
  - port_event_handler is the notifier block callback.
  - PORT_EVENT is the suffix of MLX5_EVENT_TYPE_PORT_CHANGE (The event
    type to subscribe to)

The above will guarantee that port_event_handler will receive all FW
events of the type MLX5_EVENT_TYPE_PORT_CHANGE.
    
To receive all FW/HW events one can subscribe to MLX5_EVENT_TYPE_NOTIFY_ANY.
 
There can be only 128 types of firmware events each has its own 64Byte 
EQE (Event Queue Element) data, we will have one atomic_notifier_chain
per event type for maximum performance and verbosity.
Each handler is going to receive the event_type as unsigned long and
the event data as void pointer, exactly as defined in the notifier block
handlers prototype.
   
This API is implemented in the first patch of this series all following
patches are modifying the existing mlx5 components to use the new API to
subscribe to FW events.

Thanks,
Saeed.

---

Saeed Mahameed (11):
  net/mlx5: EQ, Introduce atomic notifier chain subscription API
  net/mlx5: FWTrace, Use async events chain
  net/mlx5: FPGA, Use async events chain
  net/mlx5: Clock, Use async events chain
  net/mlx5: E-Switch, Use async events chain
  net/mlx5: FWPage, Use async events chain
  net/mlx5: CmdIF, Use async events chain
  net/mlx5: Resource tables, Use async events chain
  net/mlx5: CQ ERR, Use async events chain
  net/mlx5: Device events, Use async events chain
  net/mlx5: Improve core device events handling

 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  48 ++-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  27 +-
 .../mellanox/mlx5/core/diag/fw_tracer.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 322 +++++------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  44 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   3 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  | 332 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fpga/core.c   |  38 +-
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  25 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.c   |  24 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |   3 -
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   5 +
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  34 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  41 ++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  13 +-
 .../ethernet/mellanox/mlx5/core/pagealloc.c   |  44 ++-
 .../net/ethernet/mellanox/mlx5/core/port.c    |  57 ---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  68 +++-
 drivers/net/ethernet/mellanox/mlx5/core/srq.c |  55 ++-
 include/linux/mlx5/device.h                   |  10 +-
 include/linux/mlx5/driver.h                   |  46 +--
 include/linux/mlx5/eq.h                       |  16 +-
 include/linux/mlx5/port.h                     |   3 -
 26 files changed, 811 insertions(+), 471 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/events.c

-- 
2.19.1
