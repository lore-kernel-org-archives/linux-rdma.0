From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 0/9] RDMA resource tracking
Date: Thu,  4 Jan 2018 09:01:41 +0200
Message-ID: <20180104070150.15625-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v0 -> v1:
   * Fixed subject title in patch #1: rdam -> rdma.
   * Added newline between variable declaration and the code.
   * Add check to failure in strdup() call in rd_check_is_string_filtered().
   * Rewrote res_qp_parse_cb() to avoid long lines and extra indentation.

------------------------------------------------------------------------
Hi,

This is supplementary (user-space) part of RDMA resource tracking posted
to the RDMA mailing list for the review [1].

The main goal of this new functionality in RDMAtool is to provide debug visibility
of running applications in RDMA stack.

The current series adds new command object (resource) which provides
short summary if it is called without arguments or more detailed
information while it is called with request to present QPs.

1) Summary information:
$ rdma res
1: mlx5_0: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
2: mlx5_1: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
3: mlx5_2: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
4: mlx5_3: curr/max: pd 2/16777216 cq 3/16777216 qp 2/262144
5: mlx5_4: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144

2) Summary information of specific device:
$ rdma res show mlx5_4
5: mlx5_4: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144

3) Detailed information of specific device:
$ rdma res show qp link mlx5_4
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]

$ rdma res show qp link mlx5_4/
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]

4) Wrong port (it can be 1 or 2):
$ rdma res show qp link mlx5_4/0
Wrong device name

5) Detailed information of specific device and port:
$ rdma res show qp link mlx5_4/1
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]

6) Detailed information of QPs not-connected to port yet:
$ rdma res show qp link mlx5_4/-
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]

7) Very detailed view:
$ rdma res show qp link mlx5_4/- -d
DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM            SQ-PSN     RQ-PSN     PATH-MIG
mlx5_4/-  8          ---        UD    RESET  0          [ipoib-verbs]   0          ---        ---

8) Limit display to specific columns:
$ rdma res show qp link mlx5_4/1 display pid,lqpn,comm
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]

9) Filter specific LQPNs:
$ rdma res show qp link mlx5_4/1 display pid,lqpn,comm lqpn 0,4-7
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  0          0          [rdma-mad]

Thanks

Leon Romanovsky (9):
  rdma: Add option to provide "-" sign for the port number
  rdma: Make visible the number of arguments
  rdma: Add filtering infrastructure
  rdma: Set pointer to device name position
  rdma: Allow external usage of compare string routine
  rdma: Update kernel header file
  rdma: Add resource tracking summary
  rdma: Add QP resource tracking information
  rdma: Document resource tracking

 include/uapi/rdma/rdma_netlink.h |  58 ++++-
 man/man8/rdma-resource.8         |  91 +++++++
 rdma/Makefile                    |   2 +-
 rdma/link.c                      |   2 +-
 rdma/rdma.c                      |   4 +-
 rdma/rdma.h                      |  23 +-
 rdma/res.c                       | 535 +++++++++++++++++++++++++++++++++++++++
 rdma/utils.c                     | 309 +++++++++++++++++++++-
 8 files changed, 1007 insertions(+), 17 deletions(-)
 create mode 100644 man/man8/rdma-resource.8
 create mode 100644 rdma/res.c
