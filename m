From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v2 00/10] RDMA resource tracking
Date: Wed, 17 Jan 2018 12:02:22 +0200
Message-ID: <20180117100232.3155-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v1 -> v2;
   * Added checks for all occurrences of strdup failures and added patch
     with fix of already merged code.
   * Sync with latest kernel code.
   * Rewrote table representation to be similar to "ip route" output.
   * Implemented string filters.
   * Removed curr/max representation from the summary output.
 v0 -> v1:
   * Fixed subject title in patch #1: rdam -> rdma.
   * Added newline between variable declaration and the code.
   * Add check to failure in strdup() call in rd_check_is_string_filtered().
   * Rewrote res_qp_parse_cb() to avoid long lines and extra indentation.

------------------------------------------------------------------------

David, Stephen,

The kernel code is not accepted yet, but the interface and functionality
of iproute2 stable enough and ready for review.

iproute2 part:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/iproute2.git/log/?h=topic/resource-tracking-3

kernel part:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=rn/restrack-v5

Thanks

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
1: mlx5_0: pd 3 cq 5 qp 4
2: mlx5_1: pd 3 cq 5 qp 4
3: mlx5_2: pd 3 cq 5 qp 4
4: mlx5_3: pd 2 cq 3 qp 2
5: mlx5_4: pd 3 cq 5 qp 4

2) Summary information of specific device:
$ rdma res show mlx5_4
5: mlx5_4: pd 3 cq 5 qp 44

3) Get all QPs for the specific device:
$ rdma res show qp link mlx5_4
link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [mlx5-gsi]
link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [rdma-mad]
link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [rdma-mad]

$ rdma res show qp link mlx5_4/
link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [mlx5-gsi]
link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [rdma-mad]
link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [rdma-mad]

4) Provide illegal port number (0 is illegal):
$ rdma res show qp link mlx5_4/0
Wrong device name

5) Get QPs of specific port:
$ rdma res show qp link mlx5_4/1
link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [mlx5-gsi]
link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [rdma-mad]
link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [rdma-mad]

6) Get QPs which have not assigned port yet:
$ rdma res show qp link mlx5_3/-
link mlx5_3/- lqpn 8 type UD state RTS sq-psn 0 pid 0 comm [ipoib-verbs]

7) Limit to specific Local QPNs:
$ rdma res show qp link mlx5_4/1 lqpn 1-3,7
link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [mlx5-gsi]
link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [rdma-mad]

8) Filter types (strings):
$ rdma res show qp link mlx5_4/1 type UD,gSi
link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [mlx5-gsi]
link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [rdma-mad]

Thanks

Cc: RDMA mailing list <linux-rdma@vger.kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>

[1] https://www.spinics.net/lists/linux-rdma/msg59535.html

Leon Romanovsky (10):
  rdma: Add option to provide "-" sign for the port number
  rdma: Make visible the number of arguments
  rdma: Add filtering infrastructure
  rdma: Set pointer to device name position
  rdma: Allow external usage of compare string routine
  rdma: Update kernel header file
  rdma: Add resource tracking summary
  rdma: Add QP resource tracking information
  rdma: Document resource tracking
  rdma: Check return value of strdup call

 include/uapi/rdma/rdma_netlink.h |  61 ++++-
 man/man8/rdma-resource.8         |  86 +++++++
 rdma/Makefile                    |   2 +-
 rdma/link.c                      |   2 +-
 rdma/rdma.c                      |   4 +-
 rdma/rdma.h                      |  28 ++-
 rdma/res.c                       | 483 +++++++++++++++++++++++++++++++++++++++
 rdma/utils.c                     | 321 +++++++++++++++++++++++++-
 8 files changed, 969 insertions(+), 18 deletions(-)
 create mode 100644 man/man8/rdma-resource.8
 create mode 100644 rdma/res.c
