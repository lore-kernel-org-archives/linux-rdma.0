From: Denis Drozdov <denisd@mellanox.com>
Subject: [PATCH v2 net 0/2] IB/ipoib: ip link support
Date: Tue,  9 Jan 2018 23:42:45 +0200
Message-ID: <1515534167-13062-1-git-send-email-denisd@mellanox.com>
References: <20180101224347.xdxguvvr4g7jrxq4@inn>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180101224347.xdxguvvr4g7jrxq4@inn>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: jgg@mellanox.com, dledford@redhat.com, leonro@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, gerlitz.or@gmail.com, Denis Drozdov <denisd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

IP link was broken due to the changes in IPoIB for the rdma_netdev
support after commit cd565b4b51e5
("IB/IPoIB: Support acceleration options callbacks").

This patchset restores IPoIB pkey creation and removal using rtnetlink.
The first patch introduces changes in the rtnetlink code in order to allow
IPOIB allocate and free the netdevice.

The second patch establishes appropriate rtnetlink callbacks for IPoIB
device and restores IPoIB netlink support

Changes since v1:
- Fixed double free_netdev calls in ops->free_link in netdev_run_todo 
- Removed priv_size from ipoib_link_ops as not required anymore.


Denis Drozdov (2):
  rtnl: device allocation/free via rtnl_link_ops
  IB/ipoib: Fix netlink support in IPoIB

 drivers/infiniband/ulp/ipoib/ipoib.h         |  2 ++
 drivers/infiniband/ulp/ipoib/ipoib_main.c    | 23 ++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 39 +++++++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 20 ++++----------
 include/net/rtnetlink.h                      |  4 +++
 net/core/dev.c                               |  2 ++
 net/core/rtnetlink.c                         | 29 ++++++++++++++++-----
 7 files changed, 82 insertions(+), 37 deletions(-)

-- 
1.8.3.1
