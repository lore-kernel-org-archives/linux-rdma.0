From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 0/5] RDMA/qedr: four fixes and an enhancment
Date: Thu, 27 Apr 2017 13:35:30 +0300
Message-ID: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Three bug fixes:
  RDMA/qedr: reset access control when registering a MR
  RDMA/qedr: properly check atomic capabilities
  RDMA/qedr: destroy CQ only after HW releases it

Missing functionality bug:
  RDMA/qedr: add support for send+invalidate in poll CQ

Enhancment:
  RDMA/qedr: enhance destroy flow for GSI QP

Ram Amrani (5):
  RDMA/qedr: reset access control when registering a MR
  RDMA/qedr: properly check atomic capabilities
  RDMA/qedr: enhance destroy flow for GSI QP
  RDMA/qedr: destroy CQ only after HW releases it
  RDMA/qedr: add support for send+invalidate in poll CQ

 drivers/infiniband/hw/qedr/main.c  |  88 +++++++++++-------
 drivers/infiniband/hw/qedr/qedr.h  |   5 +-
 drivers/infiniband/hw/qedr/verbs.c | 185 +++++++++++++++++++++++++++----------
 include/uapi/linux/pci_regs.h      |   1 +
 4 files changed, 198 insertions(+), 81 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
