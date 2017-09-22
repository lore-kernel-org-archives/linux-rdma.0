From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] use setup_timer() helper function.
Date: Fri, 22 Sep 2017 15:57:08 +0530
Message-ID: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series uses setup_timer() helper function. The series
addresses the files under drivers/infiniband/hw/*.


Allen Pais (8):
  infiniband: qib: use setup_timer() helper.
  infiniband: nes: use setup_timer() helper.
  infiniband: qib: use setup_timer() helper.
  infiniband: mthca: use setup_timer() helper.
  infiniband: nes: use setup_timer() helper.
  infiniband: qib: use setup_timer() helper.
  infiniband: nes: use setup_timer() helper.
  infiniband: qib: use setup_timer() helper.

 drivers/infiniband/hw/mthca/mthca_catas.c | 4 +---
 drivers/infiniband/hw/nes/nes_cm.c        | 3 +--
 drivers/infiniband/hw/nes/nes_hw.c        | 9 +++------
 drivers/infiniband/hw/nes/nes_nic.c       | 3 +--
 drivers/infiniband/hw/qib/qib_driver.c    | 5 ++---
 drivers/infiniband/hw/qib/qib_iba7220.c   | 5 ++---
 drivers/infiniband/hw/qib/qib_mad.c       | 7 +++----
 drivers/infiniband/hw/qib/qib_sd7220.c    | 5 ++---
 8 files changed, 15 insertions(+), 26 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
