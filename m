From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 0/2] Print netdevice names and indexes for relevant RDMA devices
Date: Mon, 26 Mar 2018 11:28:27 +0300
Message-ID: <20180326082829.21214-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is user space part of the kernel patch [1], which exposed net
device name and index through RDMA netlink interface.

First patch is actually updates rdma_netlink.h to the latest kernel
variant, while second patch implements the print.

[1] https://patchwork.kernel.org/patch/10307339/

Leon Romanovsky (2):
  rdma: Update RDMA header file
  rdma: Print net device name and index for RDMA device

 rdma/include/uapi/rdma/rdma_netlink.h | 42 +++++++++++++++++++++++++++++++++++
 rdma/link.c                           | 21 ++++++++++++++++++
 rdma/utils.c                          |  2 ++
 3 files changed, 65 insertions(+)
