From: Denis Drozdov <denisd@mellanox.com>
Subject: [PATCH net 0/2] IB/ipoib: ip link support
Date: Sun, 31 Dec 2017 13:16:21 +0200
Message-ID: <1514718983-466-1-git-send-email-denisd@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: jgg@ziepe.ca, dledford@redhat.com, leonro@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Denis Drozdov <denisd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

IP link was broken due to the changes in IPoIB for the rdma_netdev 
support after commit cd565b4b51e5
("IB/IPoIB: Support acceleration options callbacks").

This patchset restores IPoIB pkey creation and removal using rtnetlink.
The first patch introduces changes in the rtnetlink code in order to allow
IPOIB allocate and free the netdevice.

The second patch establishes appropriate rtnetlink callbacks for IPoIB
device and restores IPoIB netlink support

Thank you
---

Denis Drozdov (2):
  rtnl: device allocation/free via rtnl_link_ops
  IB/ipoib: Fix netlink support in IPoIB

  drivers/infiniband/ulp/ipoib/ipoib.h         |  2 ++
  drivers/infiniband/ulp/ipoib/ipoib_main.c    | 23 +++++++++--------
  drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 38 +++++++++++++++++++++++++---
  drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 20 ++++-----------
  include/net/rtnetlink.h                      |  4 +++
  net/core/dev.c                               |  2 ++
  net/core/rtnetlink.c                         | 23 ++++++++++++-----
  7 files changed, 77 insertions(+), 35 deletions(-)

-- 
1.8.3.1
