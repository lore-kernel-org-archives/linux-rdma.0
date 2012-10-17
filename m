From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.7 0/4] mlx4 SRIOV fixes, 64B CQE/EQE patches re-spin
Date: Wed, 17 Oct 2012 18:42:57 +0200
Message-ID: <1350492181-13471-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, everyone

This series includes fixes for two bugs in the SRIOV code which were discovered in
production environment, lets get them upstream too...

Also, a respin of the 64B CQE/EQE patches (kernel and user-space), over the V1 posting
you were asking for max flexibility - e.g expose/force update of guests only if needed
and similarily for libmlx4, I think I have this now, would love feedback though.

I tested this with both modified/non-modified mlx4 guest drivers, and with
both modified/non-modified libmlx4. The only pain point I was hitting, 
if non modified libmlx4 on systems with CX3 and modified kernel, on
the V1 discussion Roland -- you made a comment we might need a module param 
here to provide admins a way to let systems with old libmlx4 to work
with fresh kernels?!

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


Eli Cohen (1):
  IB/mlx4: Synchronize cleanup of MCGs in mcg paravirtualization

Jack Morgenstein (1):
  IB/mlx4: Fix QP1 pkey processing in the Primary Physical Function
    (PPF)

Or Gerlitz (1):
  {NET,IB}/mlx4: 64 byte CQE/EQE support

 drivers/infiniband/hw/mlx4/cq.c                |   34 +++++++--
 drivers/infiniband/hw/mlx4/mad.c               |   89 +++++++++++-------------
 drivers/infiniband/hw/mlx4/main.c              |   27 ++++++--
 drivers/infiniband/hw/mlx4/mcg.c               |   18 +++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |    1 +
 drivers/infiniband/hw/mlx4/user.h              |   12 +++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c       |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c     |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c        |   26 +++++---
 drivers/net/ethernet/mellanox/mlx4/fw.c        |   30 ++++++++-
 drivers/net/ethernet/mellanox/mlx4/fw.h        |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c      |   24 ++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1 +
 include/linux/mlx4/device.h                    |   21 ++++++
 17 files changed, 213 insertions(+), 86 deletions(-)

changes from the previous version to the libmlx4 patch
 - added storing per device ABI

 - added handling ABI version 4 and also older ABI versions w.r.t to 
   struct mlx4_alloc_ucontext_resp_v3

Or Gerlitz (1):
  Add support for 64B CQE

 src/cq.c       |   39 ++++++++++++++++++---------------------
 src/mlx4-abi.h |   17 ++++++++++++++++-
 src/mlx4.c     |   39 +++++++++++++++++++++++++++++----------
 src/mlx4.h     |   25 ++++++++++++++++++++-----
 src/verbs.c    |    6 ++++--
 5 files changed, 87 insertions(+), 39 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
