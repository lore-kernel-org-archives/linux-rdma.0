From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/7] Signature feature update
Date: Wed, 13 Aug 2014 19:54:28 +0300
Message-ID: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Lately MKP posted some block data integrity updates over Linux-scsi (see https://lwn.net/Articles/606820/).
These changes follow DIX draft 1.1 (see see https://oss.oracle.com/~mkp/docs/dix-1.1.pdf).
The draft updates the execution parameters passed from SCSI midlayer
to the LLDs with respect to data integrity feature.

This set updates signature feature accordingly.

Once Martin's patches will land mainline I'll also modify iSER
to take relevant parameters from the scsi command structure.

This set consists of:
- Patches #1, #2, #3 are minor fixes
- Patch #4 is a preparation patch
- Patches #5, #6 are code centralization
- Patch #7 is an API update (modifies ib_core, mlx5, iser, isert)

Roland, there are some patches in iser-target code, but I'm pretty
sure that they can go from your tree. Right Nic?

Sagi Grimberg (7):
  IB/mlx5: Use enumerations for PI copy mask
  IB/iser: Remove redundant assignment
  IB/iser: Set IP_CSUM as default guard type
  IB/mlx5: Use extended internal signature layout
  IB/iser: Centralize ib_sig_domain settings
  Target/iser: Centralize ib_sig_domain setting
  IB/mlx5, iser, isert: Add Signature API additions

 drivers/infiniband/hw/mlx5/qp.c           |  134 ++++++++++++-----------------
 drivers/infiniband/ulp/iser/iscsi_iser.c  |    4 +-
 drivers/infiniband/ulp/iser/iser_memory.c |   79 ++++++++---------
 drivers/infiniband/ulp/isert/ib_isert.c   |   65 ++++++---------
 include/linux/mlx5/qp.h                   |   35 ++++++--
 include/rdma/ib_verbs.h                   |   32 +++----
 6 files changed, 164 insertions(+), 185 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
