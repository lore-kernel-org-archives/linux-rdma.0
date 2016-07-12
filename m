From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/8] i40iw fixes
Date: Tue, 12 Jul 2016 11:48:38 -0500
Message-ID: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series includes minor fixes for the Intel X722 
iWARP driver i40iw.

It is based on Doug Ledford's https://github.com/dledford/linux.git
branch: k.o/for-4.8.

Mustafa Ismail (7):
  i40iw: Correct and use size parameter to i40iw_reg_phys_mr
  i40iw: Do not access pointer after free
  i40iw: Remove unnecessary parameter to i40iw_cq_poll_completion
  i40iw: Simplify code to set fragments in SQ WQE
  i40iw: Remove unnecessary check for moving CQ head
  i40iw: Change dup_ack_thresh to u8
  i40iw: Add NULL check for puda buffer

Shiraz Saleem (1):
  i40iw: Fix return codes

 drivers/infiniband/hw/i40iw/i40iw_cm.c    |  4 +--
 drivers/infiniband/hw/i40iw/i40iw_d.h     |  3 ++
 drivers/infiniband/hw/i40iw/i40iw_puda.c  |  4 +++
 drivers/infiniband/hw/i40iw/i40iw_type.h  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 29 +++++++----------
 drivers/infiniband/hw/i40iw/i40iw_user.h  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 52 ++++++++++++++++++++-----------
 7 files changed, 56 insertions(+), 40 deletions(-)

-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
