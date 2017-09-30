From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] more i40iw fixes
Date: Fri, 29 Sep 2017 20:29:37 -0500
Message-ID: <20170930012942.9128-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series includes a few more minor i40iw fixes.

If you deem the submission is too late for 4.14-rc, it is fine
to push it to for-next.

Mustafa Ismail (3):
  i40iw: Do not generate CQE for RTR on QP flush
  i40iw: Add missing memory barriers
  i40iw: Fix port number for query QP

Shiraz Saleem (1):
  i40iw: Do not allow posting WR after QP is flushed

Tatyana Nikolova (1):
  i40iw: Do not retransmit MPA request after it is ACKed

 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 13 ++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_cm.h    |  1 +
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h     |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_puda.c  | 11 ++++-------
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 13 +++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_user.h  |  1 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 15 +++++++++++++++
 8 files changed, 47 insertions(+), 11 deletions(-)

-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
