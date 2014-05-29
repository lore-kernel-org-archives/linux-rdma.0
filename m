From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/6] mlx4: Implement QP0 (SMI) support for privileged VFs
Date: Thu, 29 May 2014 16:30:58 +0300
Message-ID: <1401370264-4818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Roland,

This patch set enables selected VFs to issue QP0 (SMI) requests
and receive responses. This feature enables running tools such as
infiniband-diags and ibutils on these selected (privileged) VFs.

Unsolicited SMI MADs will still be sent exclusively to the
PF QP0 proxy, so OpenSM can run only on the PF.

To activate the capability for the selected VF/port, a sysfs interface 
is added on the Hypervisor (under the existing mlx4 iov directory).

As pre-condition patches, the set also includes three bug fixes:
1. a memory leak fix. (patch set requires modifying (i.e., adding to)
   code included in the fix.
2. An incorrect FLAGS1 bitmap test (which could cause ETH ports to fail
   to come up on VFs).
3. A fix enabling mlx4_ib_modify_port to track PF changes to port capability flags
   (so that the aggregate port capabilities for for all devices will include
   the capabilities specified by the PF as well).

Jack and Or.

Dotan Barak (1):
  mlx4_core: Fix memory leaks under SRIOV in case of error flow

Jack Morgenstein (5):
  mlx4_core: Fix incorrect FLAGS1 bitmap test in mlx4_QUERY_FUNC_CAP
  IB/mlx4: SET_PORT called by mlx4_ib_modify_port should be wrapped
  IB/mlx4: Preparation for VFs to issue/receive SMI (QP0) requests/responses
  mlx4: Add infrastructure for selecting VFs to enable QP0 via MLX proxy QPs
  IB/mlx4: Add interface for selecting VFs to enable QP0 via MLX proxy QPs

 drivers/infiniband/hw/mlx4/mad.c                   |   40 +++++---
 drivers/infiniband/hw/mlx4/main.c                  |   26 +++--
 drivers/infiniband/hw/mlx4/qp.c                    |   68 +++++++++----
 drivers/infiniband/hw/mlx4/sysfs.c                 |  105 +++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   92 +++++++++++++++---
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   46 ++++++---
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   30 +++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    8 ++
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   26 ++++-
 include/linux/mlx4/device.h                        |    5 +
 11 files changed, 364 insertions(+), 83 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
