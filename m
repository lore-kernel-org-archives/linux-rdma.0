From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 0/8] Statistics counter support
Date: Wed, 10 Apr 2019 14:21:13 +0300
Message-ID: <20190410112121.6790-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Mark Zhang <markz@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

---------------------------------
Kernel patch is not accepted yet.
---------------------------------

Hi,

This is supplementary part of kernel series [1], that kernel series
provided an option to get various counters: global and per-objects.

Currently, all counters are printed in format similar to other
device/link properties, but maybe we should print them as table.

[leonro@server ~]$ rdma stat show
link mlx5_0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests
0 out_of_buffer 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err
0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error
0 resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0
req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0

Thanks

[1] https://www.spinics.net/lists/linux-rdma/msg77735.html

Thanks

Mark Zhang (8):
  rdma: Update uapi headers to add statistic counter support
  rdma: Add "stat qp show" support
  rdma: Add get per-port counter mode support
  rdma: Add rdma statistic counter per-port auto mode support
  rdma: Make get_port_from_argv() returns valid port in strict port mode
  rdma: Add stat manual mode support
  rdma: Add default counter show support
  rdma: Document counter statistic

 man/man8/rdma-dev.8                   |   1 +
 man/man8/rdma-link.8                  |   1 +
 man/man8/rdma-resource.8              |   1 +
 man/man8/rdma-statistic.8             | 170 ++++++
 man/man8/rdma.8                       |   5 +
 rdma/Makefile                         |   2 +-
 rdma/include/uapi/rdma/rdma_netlink.h |  82 ++-
 rdma/rdma.c                           |   3 +-
 rdma/rdma.h                           |   1 +
 rdma/stat.c                           | 802 ++++++++++++++++++++++++++
 rdma/utils.c                          |  17 +-
 11 files changed, 1069 insertions(+), 16 deletions(-)
 create mode 100644 man/man8/rdma-statistic.8
 create mode 100644 rdma/stat.c
