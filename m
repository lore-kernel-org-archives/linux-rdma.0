From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc 0/2] RDMA/qedr: two important fixes for RDMA CM with VLAN
Date: Tue, 3 Oct 2017 14:47:25 +0300
Message-ID: <1507031247-7972-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series contains two important fixes for RDMA CM with VLAN.

Ram Amrani (2):
  RDMA/qedr: Parse VLAN ID correctly and ignore the value of zero
  RDMA/qedr: Parse vlan priority as sl

 drivers/infiniband/hw/qedr/qedr.h    |  2 +-
 drivers/infiniband/hw/qedr/qedr_cm.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
