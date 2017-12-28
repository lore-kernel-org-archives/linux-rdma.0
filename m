From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [pull request][for-next V3 00/11] Mellanox, mlx5 E-Switch updates 2017-12-19
Date: Fri, 29 Dec 2017 01:23:03 +0200
Message-ID: <20171228232314.13678-1-saeedm@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Dave and Doug,

==============
This series includes updates for mlx5 E-Switch infrastructures,
to be merged into net-next and rdma-next trees.

Mark's patches provide E-Switch refactoring that generalize the mlx5
E-Switch vf representors interfaces and data structures. The serious is
mainly focused on moving ethernet (netdev) specific representors logic out
of E-Switch (eswitch.c) into mlx5e representor module (en_rep.c), which
provides better separation and allows future support for other types of vf
representors (e.g. RDMA).

Gal's patches at the end of this serious, provide a simple syntax fix and
two other patches that handles vport ingress/egress ACL steering name
spaces to be aligned with the Firmware/Hardware specs.
===============

V1->V2:
 - Addressed coding style comments in patches #1 and #7
 - The series is still based on rc4, as now I see net-next is also @rc4.

V2->V3:
 - Fixed compilation warning, reported by Dave.

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---

The following changes since commit 1291a0d5049dbc06baaaf66a9ff3f53db493b19b:

  Linux 4.15-rc4 (2017-12-17 18:59:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-shared-4.16-1

for you to fetch changes up to 9b93ab981e3bf62ff95a8cbb6faf652cd400decd:

  net/mlx5: Separate ingress/egress namespaces for each vport (2017-12-29 00:43:52 +0200)

----------------------------------------------------------------
mlx5-shared-4.16-1

mlx5 shared code for both rdma-next and net-next trees.

----------------------------------------------------------------
Gal Pressman (3):
      net/mlx5e: E-Switch, Use the name of static array instead of its address
      net/mlx5: Fix ingress/egress naming mistake
      net/mlx5: Separate ingress/egress namespaces for each vport

Mark Bloch (8):
      net/mlx5: E-Switch, Refactor vport representors initialization
      net/mlx5: E-Switch, Refactor load/unload of representors
      net/mlx5: E-Switch, Simplify representor load/unload callback API
      net/mlx5: E-Switch, Move mlx5e only logic outside E-Switch
      net/mlx5: E-Switch, Create a dedicated send to vport rule deletion function
      net/mlx5e: Move ethernet representors data into separate struct
      net/mlx5: E-Switch, Create generic header struct to be used by representors
      net/mlx5e: E-Switch, Move send-to-vport rule struct to en_rep

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 147 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  14 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  48 +++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  45 +++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 216 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 145 +++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   4 +-
 include/linux/mlx5/fs.h                            |   4 +
 9 files changed, 424 insertions(+), 214 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
