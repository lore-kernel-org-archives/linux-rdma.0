From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] RDMA/Intel X722 iWarp driver fixes
Date: Tue, 14 Jun 2016 16:54:15 -0500
Message-ID: <1465941259-4492-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series includes fixes for the Intel X722 iWARP driver i40iw.

It is based on Doug Ledford's https://github.com/dledford/linux.git
branch: k.o/for-4.7-rc. 

Faisal Latif (2):
  i40iw: Correct status check on i40iw_get_pble
  i40iw: Return correct max_fast_reg_page_list_len

Shiraz Saleem (2):
  i40iw: Correct CQ arming
  i40iw: Enable level-1 PBL for fast memory registration

 drivers/infiniband/hw/i40iw/i40iw.h       |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
