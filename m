From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] mlx4 SRIOV fixes, 64B CQE/EQE V3
Date: Sun, 21 Oct 2012 16:59:21 +0200
Message-ID: <1350831564-25251-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series includes two fixes to the SRIOV code and V3
of the 64B CQE/EQE patch, where the latter you said is 3.8
material since it changes the kernel ABI to libmlx4 and host
ABI towards guests.

changes from previous versions to the kernel 64B CQE/EQE patch:

V0 pointer
	mlx4 http://marc.info/?l=linux-rdma&m=131805712306677&w=2
	libmlx4 http://marc.info/?l=linux-rdma&m=131805712306678&w=2

V1 pointer 
	mlx4 http://marc.info/?l=linux-rdma&m=133787002203027&w=2
	libmlx4 -- didn't have V1

V1 changes from V0:

 - unified the 64B CQE and EQE patches to one patch which takes an approach of 
   apply both or none, under the thinking that 99% FW will support both or none.
 - bump the ABI version towards user-space/libmlx4 only when needed and not always
 - added support for SRIOV, using the PF_CONTEXT_BEHAVIOUR_MASK mechanism

V2 changes:  
 - rebased to kernel 3.6+ (e.g pre 3.7-rc1) that includes the SRIOV/IB patches
 - revised/fixed the SRIOV flow 
 - revises/fixed the flow towards user-space

v3 changes:
 - rebased to the for-next branch and the two patches you've accepted
 - added the new 64B functionality to be off by default and a knob to
   set it on, as was requested during the V2 review.

Or


Dotan Barak (1):
  net/mlx4: Perform correct resource cleanup if mlx4_QUERY_ADAPTER() fails

Or Gerlitz (2):
  net/mlx4_core: Remove more annoying debug messages from the SRIOV flow
  {NET,IB}/mlx4: 64 byte CQE/EQE support

 drivers/infiniband/hw/mlx4/cq.c                    |   34 ++++++++++++----
 drivers/infiniband/hw/mlx4/main.c                  |   27 ++++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    1 +
 drivers/infiniband/hw/mlx4/user.h                  |   12 +++++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |   32 ++++++++-------
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   30 +++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   43 +++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    1 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    6 ---
 include/linux/mlx4/device.h                        |   21 ++++++++++
 16 files changed, 179 insertions(+), 44 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
