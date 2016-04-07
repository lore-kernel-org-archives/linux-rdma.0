From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 00/16] Intel X722 iWARP driver update
Date: Thu,  7 Apr 2016 11:30:48 -0500
Message-ID: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series covers changes to i40iw since the initial driver
submission including base memory management extensions, virtual
channel messages queue, corrections for endian warnings and bug fixes.

This patch series is based on Doug Ledford's
https://github.com/dledford/linux.git branch: k.o/for-4.6-rc

Mustafa Ismail (16):
  i40iw: Fix overflow of region length
  i40iw: Correct QP size calculation
  i40iw: Fix refused connections
  i40iw: Correct max message size in query port
  i40iw: Do not set self-referencing pointer to NULL after free
  i40iw: Add qp table lock around AE processing
  i40iw: Set vendor_err only if there is an actual error
  i40iw: Populate vendor_id and vendor_part_id fields
  i40iw: Remove unused code and fix warning
  i40iw: Add virtual channel message queue
  i40iw: Correct return code check in add_pble_pool
  i40iw: Initialize max enabled vfs variable
  i40iw: Add base memory management extensions
  i40iw: Fix endian issues and warnings
  i40iw: Fix SD calculation for initial HMC creation
  i40iw: Adding queue drain functions

 drivers/infiniband/hw/i40iw/i40iw.h          |   7 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c       | 144 +++++++-------
 drivers/infiniband/hw/i40iw/i40iw_cm.h       |  10 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 163 ++++++++++++----
 drivers/infiniband/hw/i40iw/i40iw_d.h        |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c       |  11 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c     |  55 ++++--
 drivers/infiniband/hw/i40iw/i40iw_osdep.h    |   1 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c     |   9 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c     |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h     |  12 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c       |  80 +++-----
 drivers/infiniband/hw/i40iw/i40iw_user.h     |  34 ++--
 drivers/infiniband/hw/i40iw/i40iw_utils.c    |  47 +++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 277 ++++++++++++++++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.h    |   3 +
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c |  96 +++++-----
 17 files changed, 654 insertions(+), 299 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
