From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] move port mapper code to iwcm
Date: Fri, 26 Feb 2016 09:17:59 -0600
Message-ID: <1456499885-8044-1-git-send-email-faisal.latif@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This series is for port mapper functionality moved from iwarp drivers to common code
mainly in core/iwcm.c.

Also added a patch for review, for a bug found as part of testing, not related to
moving code to iwcm.c as it is on top of port mapper changes.


These patches are applied to //github.com/dledford/linux.git 's i40iw branch
for testing.

Thanks
Faisal

Faisal Latif (4):
  iwcm: common code for port mapper
  i40iw: use shared code for port mapper
  iw_nes: remove port mapper related code
  iwpm: crash fix for large connections test

Steve Wise (2):
  iw_cxgb4: remove port mapper related code
  iw_cxgb3: support for iWARP port mapping

 drivers/infiniband/core/iwcm.c            | 190 +++++++++++--
 drivers/infiniband/core/iwpm_msg.c        |  12 +-
 drivers/infiniband/core/iwpm_util.c       |  14 +-
 drivers/infiniband/core/iwpm_util.h       |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c     |  16 +-
 drivers/infiniband/hw/cxgb4/cm.c          | 220 ++++-----------
 drivers/infiniband/hw/cxgb4/device.c      |  67 ++---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |  42 ---
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 427 +++++-------------------------
 drivers/infiniband/hw/i40iw/i40iw_hw.c    |  20 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  20 --
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |   3 +
 drivers/infiniband/hw/nes/nes.c           |  25 --
 drivers/infiniband/hw/nes/nes_cm.c        | 351 ++++++------------------
 drivers/infiniband/hw/nes/nes_cm.h        |  11 +-
 drivers/infiniband/hw/nes/nes_verbs.c     |   2 +
 include/rdma/iw_cm.h                      |   6 +-
 include/uapi/rdma/rdma_netlink.h          |   5 +-
 18 files changed, 414 insertions(+), 1019 deletions(-)

-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
