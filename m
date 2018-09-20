From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/5] IB device rename support
Date: Thu, 20 Sep 2018 14:21:57 +0300
Message-ID: <20180920112202.9181-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series introduce long-waiting feature - "IB device rename".
Such feature gives and option to rename user visible IB device name from
vendor specific name (e.g. mlx5_0) to anything else.

The user space component through rdmatool will follow this series.

[leonro@server /]$ lspci |grep -i Ether
00:08.0 Ethernet controller: Red Hat, Inc. Virtio network device
00:09.0 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX-4]
[leonro@server /]$ sudo rdma dev
1: mlx5_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455
[leonro@server /]$ sudo rdma dev set mlx5_0 name hfi1_0
[leonro@server /]$ sudo rdma dev
1: hfi1_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455

First patch introduces getter/setter to access names, i didn't convert
all drivers to stop using name directly, because they don't base their
decision on "name", and use this print only and can print truncated name
if renaming is done at the same time as logging.

Second patch updates SMC to use IB device index instead of name.

Third patch globally converts all drivers to new allocation name
routine.

Forth and fifth patches are actually implement and exports through RDMA
netlink the rename routines.

It uses exported by device_rename() function, despite the comment from
2010, which warns about downsides of this function, the netdev is still
uses, so we will use too.

There is one patch/series which was dropped from this submission -
conversion of SElinux from being IB device name to be IB device index
based. It simply needs more special care and more testing.

This series was tested with mlx5 devices with/without traffic and with
non-modified rdma-core.

Dennis,
I didn't touch hfi1, but I'm not sure if it is needed.

Thanks

Leon Romanovsky (5):
  RDMA/core: Provide getter and setter to access IB device name
  net/smc: Use IB device index instead of name
  RDMA: Convert IB drivers to name allocation routine
  RDMA/core: Implement IB device rename function
  RDMA/nldev: Allow IB device rename through RDMA netlink

 drivers/infiniband/core/core_priv.h            |  1 +
 drivers/infiniband/core/device.c               | 52 +++++++++++++++++++++++---
 drivers/infiniband/core/nldev.c                | 33 ++++++++++++++++
 drivers/infiniband/hw/bnxt_re/main.c           |  6 ++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |  5 ++-
 drivers/infiniband/hw/cxgb4/provider.c         |  5 ++-
 drivers/infiniband/hw/hns/hns_roce_main.c      |  4 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      |  7 +++-
 drivers/infiniband/hw/mlx4/main.c              |  7 +++-
 drivers/infiniband/hw/mlx5/main.c              |  4 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |  5 ++-
 drivers/infiniband/hw/nes/nes_verbs.c          |  6 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     |  7 +++-
 drivers/infiniband/hw/qedr/main.c              |  4 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c    |  5 ++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c |  9 +++--
 drivers/infiniband/sw/rxe/rxe_verbs.c          |  5 ++-
 include/rdma/ib_verbs.h                        |  8 +++-
 include/uapi/rdma/rdma_netlink.h               |  3 +-
 net/smc/smc_diag.c                             |  6 +--
 net/smc/smc_pnet.c                             | 27 +++++++------
 21 files changed, 171 insertions(+), 38 deletions(-)
