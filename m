From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 0/4] rdma: IB device rename
Date: Wed, 31 Oct 2018 09:17:54 +0200
Message-ID: <20181031071758.6178-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v0->v1:
 * Added Steve's ROB on first three patches.
 * Updated manual
RFC->v0
 * Dropped RFC tag after kernel part was accepted
 * Updated commit message of first patch to include correct SHA1
-----------------------------------------------------------------------

Hi,

This is comprehensive part of kernel series posted earlier. The kernel
part is not accepted yet, so first patch will have different commit
message with different commit SHA1. This is why it is marked as RFC.

An example:

[leonro@server /]$ lspci |grep -i Ether
00:08.0 Ethernet controller: Red Hat, Inc. Virtio network device
00:09.0 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX-4]
[leonro@server /]$ sudo rdma dev
1: mlx5_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455
[leonro@server /]$ sudo rdma dev set mlx5_0 name hfi1_0
[leonro@server /]$ sudo rdma dev
1: hfi1_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455

Thanks

Leon Romanovsky (4):
  rdma: Update kernel include file to support IB device renaming
  rdma: Introduce command execution helper with required device name
  rdma: Add an option to rename IB device interface
  rdma: Document IB device renaming option

 man/man8/rdma-dev.8                   | 13 +++++++++++++
 rdma/dev.c                            | 35 +++++++++++++++++++++++++++++++++++
 rdma/include/uapi/rdma/rdma_netlink.h |  3 ++-
 rdma/rdma.h                           |  1 +
 rdma/utils.c                          | 10 ++++++++++
 5 files changed, 61 insertions(+), 1 deletion(-)
