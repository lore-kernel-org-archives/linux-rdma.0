From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 00/16] RDMA/Intel X722 iWARP driver update
Date: Mon, 18 Apr 2016 10:32:53 -0500
Message-ID: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This (V3) series corrects the subject line of the email.

This patch series covers changes to i40iw since the initial driver submission
including base memory management extensions, virtual channel messages queue,
corrections for endian warnings and bug fixes.

This patch series is based on Doug Ledford's
https://github.com/dledford/linux.git branch: k.o/for-4.6-rc

Changes from V2 to V3:
1. Adds version in subject line of email series.

Changes from original version to V2 incorporates feedback received:
1. Move RDMA in subject line.
2. Fix for cast warning due to u64 to u32 assignment.
3. Use named initializers for structures that have meaning outside the file.

Mustafa Ismail (16):
  RDMA/i40iw: Fix overflow of region length
  RDMA/i40iw: Correct QP size calculation
  RDMA/i40iw: Fix refused connections
  RDMA/i40iw: Correct max message size in query port
  RDMA/i40iw: Do not set self-referencing pointer to NULL after free
  RDMA/i40iw: Add qp table lock around AE processing
  RDMA/i40iw: Set vendor_err only if there is an actual error
  RDMA/i40iw: Populate vendor_id and vendor_part_id fields
  RDMA/i40iw: Remove unused code and fix warning
  RDMA/i40iw: Add virtual channel message queue
  RDMA/i40iw: Correct return code check in add_pble_pool
  RDMA/i40iw: Initialize max enabled vfs variable
  RDMA/i40iw: Add base memory management extensions
  RDMA/i40iw: Fix endian issues and warnings
  RDMA/i40iw: Fix SD calculation for initial HMC creation
  RDMA/i40iw: Adding queue drain functions

 drivers/infiniband/hw/i40iw/i40iw.h          |   7 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c       | 144 +++++++-------
 drivers/infiniband/hw/i40iw/i40iw_cm.h       |  10 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 185 ++++++++++++-----
 drivers/infiniband/hw/i40iw/i40iw_d.h        |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c       |  11 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c     |  55 ++++--
 drivers/infiniband/hw/i40iw/i40iw_osdep.h    |   1 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c     |   9 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c     |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h     |  12 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c       |  80 +++-----
 drivers/infiniband/hw/i40iw/i40iw_user.h     |  36 ++--
 drivers/infiniband/hw/i40iw/i40iw_utils.c    |  47 +++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 283 ++++++++++++++++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.h    |   3 +
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c |  96 ++++-----
 17 files changed, 671 insertions(+), 312 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
