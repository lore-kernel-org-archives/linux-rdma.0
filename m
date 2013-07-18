From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.11 0/7] Add Fast-Reg support to the iser initiator driver
Date: Thu, 18 Jul 2013 16:25:24 +0300
Message-ID: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here's the FRWR (Fast Reg WR) patch series for iser from Sagi Grimberg. 

This is kind of critical so we can avoid using bounce buffers when running
over Connect-IB (the newly introduced mlx5 driver) and ConnectX VF which both
don't support FMRs.

Patches 1-3 are the other iser updates for 3.11, which reposted here for ease 
of merging, I have submitted them earlier for 3.11 but you missed picking them.

Patches 4-6 are simple pre-steps for allowing more registration models such as
FastReg WRs except for FMR, and the last patch adds the actual support for fastreg.

Or.

Or Gerlitz (1):
  IB/iser: Use proper debug level value for info prints

Sagi Grimberg (4):
  IB/iser: Generalize rdma memory registration
  IB/iser: Handle unaligned SG in separate function
  IB/iser: Place the fmr pool into a union in iser's IB conn struct
  IB/iser: Introduce fast memory registration model (FRWR)

Shlomo Pongratz (2):
  IB/iser: Restructure allocation/deallocation of connection resources
  IB/iser: Accept session->cmds_max from user space

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   19 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   73 ++++++--
 drivers/infiniband/ulp/iser/iser_initiator.c |  137 ++++++++++---
 drivers/infiniband/ulp/iser/iser_memory.c    |  231 +++++++++++++++++----
 drivers/infiniband/ulp/iser/iser_verbs.c     |  288 ++++++++++++++++++-------
 5 files changed, 583 insertions(+), 165 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
