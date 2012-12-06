From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [FIXES for-next 0/4] mlx4_core SRIOV and Flow-Steering adjustments and fixes
Date: Thu,  6 Dec 2012 19:11:56 +0200
Message-ID: <1354813920-27358-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

The patch set fixes few issues we've identified and fixed in the 
mlx4_core driver around SRIOV and device managed flow steering. 

This includes adding QPN enforcement in the resource tracker for 
flow-steering rules set by VFs, and a fix to wrong error flow in
the very same area in patches #1/#2. Patch #3 addresses a wrong 
flow-steering capability detection by VFs and adds a check that
the requested number of VFs can actually be served under flow-steering 
mode. Finally, with flow steering being global device operational mode,
which is needed only in certain environments, patch #4 comes and allows 
to actually choose whether or not to use it.

As we're on rc8 now which is pretty late in the 3.7 release cycle, it makes 
more sense to push these patches into 3.8 and later pick the relevant pieces 
into -stable.  Specifically patch #3 can't go into -stable as is since it has 
context dependancies with the "mlx4: 64-byte CQE/EQE support" patch targted 
for 3.8 queued at your tree.

Or.

Hadar Hen Zion (2):
  mlx4_core: Add QPN enforcement for flow steering rules set by VFs
  mlx4_core: Fix wrong error flow in the flow steering wrapper

Jack Morgenstein (2):
  mlx4_core: Adjustments to Flow Steering activation logic for SRIOV
  mlx4_core: Allow choosing flow steering mode

 drivers/net/ethernet/mellanox/mlx4/fw.c            |   15 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |  115 +++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |    7 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    6 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   28 ++++--
 include/linux/mlx4/device.h                        |    1 +
 7 files changed, 129 insertions(+), 44 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
