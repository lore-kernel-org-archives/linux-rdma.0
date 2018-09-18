From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: [PATCH 0/4] IB: decrease large contigous allocation
Date: Tue, 18 Sep 2018 16:03:42 +0300
Message-ID: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Jan Dakinevich <jan.dakinevich@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

The size of mlx4_ib_device became too large to be allocated as whole contigous 
block of memory. Currently it takes about 55K. On architecture with 4K page it 
means 3rd order.

This patch series makes an attempt to split mlx4_ib_device into several parts 
and allocate them with less expensive kvzalloc

Jan Dakinevich (4):
  IB/core: introduce ->release() callback
  IB/mlx4: move iboe field aside from mlx4_ib_dev
  IB/mlx4: move pkeys field aside from mlx4_ib_dev
  IB/mlx4: move sriov field aside from mlx4_ib_dev

 drivers/infiniband/core/device.c        |   2 +
 drivers/infiniband/hw/mlx4/alias_GUID.c | 192 ++++++++++++++++----------------
 drivers/infiniband/hw/mlx4/cm.c         |  32 +++---
 drivers/infiniband/hw/mlx4/mad.c        |  98 ++++++++--------
 drivers/infiniband/hw/mlx4/main.c       |  93 ++++++++++------
 drivers/infiniband/hw/mlx4/mcg.c        |   4 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |   8 +-
 drivers/infiniband/hw/mlx4/qp.c         |   8 +-
 drivers/infiniband/hw/mlx4/sysfs.c      |  40 +++----
 include/rdma/ib_verbs.h                 |   2 +
 10 files changed, 256 insertions(+), 223 deletions(-)

-- 
2.1.4
