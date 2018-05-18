From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][for-next 00/15] Mellanox, mlx5 core and netdev updates 2018-05-17
Date: Thu, 17 May 2018 18:22:43 -0700
Message-ID: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Dave and Doug,

Below you can find two pull requests,

1. mlx5 core updates to be shared for both netdev and RDMA, (patches 1..9)
 which is based on the last mlx5-next pull request
 
The following changes since commit a8408f4e6db775e245f20edf12b13fd58cc03a1c:

  net/mlx5: fix spelling mistake: "modfiy" -> "modify" (2018-05-04 12:11:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-updates-2018-05-17

for you to fetch changes up to 10ff5359f883412728ba816046ee3a696625ca02:

  net/mlx5e: Explicitly set source e-switch in offloaded TC rules (2018-05-17 14:17:35 -0700)

2. mlx5e netdev updates only for net-next branch (patches 10..15) based on net-next
and the above pull request.

The following changes since commit 538e2de104cfb4ef1acb35af42427bff42adbe4d:

  Merge branch 'net-Allow-more-drivers-with-COMPILE_TEST' (2018-05-17 17:11:07 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5e-updates-2018-05-17

for you to fetch changes up to a228060a7c9ab88597eeac131e4578595d5d46ae:

  net/mlx5e: Add HW vport counters to representor ethtool stats (2018-05-17 17:48:54 -0700)


Dave, for your convenience you can either pull 1. and then 2. or pull 2.
directly.

For more information please see tags logs below.
Please pull and let me know if there's any problem.

Thanks,
Saeed.

----------------------------------------------------------------
mlx5-updates-2018-05-17

mlx5 core driver updates for both net-next and rdma-next branches.

>From Christophe JAILLET, first three patches to use kvfree where needed.

From: Or Gerlitz <ogerlitz@mellanox.com>

Next six patches from Roi and Co adds support for merged
sriov e-switch which comes to serve cases where both PFs, VFs set
on them and both uplinks are to be used in single v-switch SW model.
When merged e-switch is supported, the per-port e-switch is logically
merged into one e-switch that spans both physical ports and all the VFs.

This model allows to offload TC eswitch rules between VFs belonging
to different PFs (and hence have different eswitch affinity), it also
sets the some of the foundations needed for uplink LAG support.


mlx5e-updates-2018-05-17

From: Or Gerlitz <ogerlitz@mellanox.com>

This series addresses a regression introduced by the
shared block TC changes [1]. Currently, for VF->VF and uplink->VF rules, the
TC core (cls_api) attempts to offload the same flow multiple times into
the driver, as a side effect of the mlx5 registration to the egdev callback.

We use the flow cookie to ignore attempts to add such flows, we can't
reject them (return error), b/c this will fail the offload attempt, so we
ignore that.

The last patch of the series deals with exposing HW stats counters through
ethtool for the vport reps.

Dave - the regression that we are addressing was introduced in 4.15 [1] and applies
to nfp and mlx5. Jiri suggested to push driver side fixes to net-next, this is
already done for nfp [2][3]. Once this is upstream, we will submit a small/point
single patch fix for the TC core code which can serve for net and stable, but not
carried into net-next, b/c it might limit some future use-cases.

[1] 208c0f4b5237 "net: sched: use tc_setup_cb_call to call per-block callbacks"
[2] c50647d "nfp: flower: ignore duplicate cb requests for same rule"
[3] 54a4a03 "nfp: flower: support offloading multiple rules with same cookie"

----------------------------------------------------------------
Christophe JAILLET (3):
      net/mlx5: Vport, Use 'kvfree()' for memory allocated by 'kvzalloc()'
      net/mlx5: Eswitch, Use 'kvfree()' for memory allocated by 'kvzalloc()'
      IB/mlx5: Use 'kvfree()' for memory allocated by 'kvzalloc()'

Or Gerlitz (5):
      net/mlx5e: Add ingress/egress indication for offloaded TC flows
      net/mlx5e: Prepare for shared table to keep TC eswitch flows
      net/mlx5e: Use shared table for offloaded TC eswitch flows
      net/mlx5e: Ignore attempts to offload multiple times a TC flow
      net/mlx5e: Add HW vport counters to representor ethtool stats

Rabie Loulou (2):
      net/mlx5e: Explicitly set destination e-switch in FDB rules
      net/mlx5e: Offload TC eswitch rules for VFs belonging to different PFs

Roi Dayan (1):
      net/mlx5: Add merged e-switch cap

Saeed Mahameed (1):
      Merge tag 'mlx5-updates-2018-05-17' of git://git.kernel.org/.../mellanox/linux

Shahar Klein (4):
      net/mlx5: Properly handle a vport destination when setting FTE
      net/mlx5: Add destination e-switch owner
      net/mlx5: Add source e-switch owner
      net/mlx5e: Explicitly set source e-switch in offloaded TC rules

 drivers/infiniband/hw/mlx5/cq.c                    |   2 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  86 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 145 ++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  24 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  21 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   9 ++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   6 +-
 include/linux/mlx5/fs.h                            |   6 +-
 include/linux/mlx5/mlx5_ifc.h                      |  14 +-
 16 files changed, 258 insertions(+), 97 deletions(-)
