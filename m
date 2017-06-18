From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/2] RDMA/qedr: Add feature indications to user-space
Date: Sun, 18 Jun 2017 16:01:09 +0300
Message-ID: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The first patch passes user space indication whether EDPM is supported
or not. EDPM stands for Enhanced Direct Packet Mode for low latency.

The second patch passes the indication of whether WIDs are supported
and how many, per user application. WIDs are per CPU areas in the BAR
that are used for parallel simultaneous doorbells.

Ram Amrani (2):
  RDMA/qedr: notify user application if EDPM is supported
  RDMA/qedr: notify user application number of supported WIDs

 drivers/infiniband/hw/qedr/main.c  | 1 +
 drivers/infiniband/hw/qedr/qedr.h  | 2 ++
 drivers/infiniband/hw/qedr/verbs.c | 9 +++++++++
 include/uapi/rdma/qedr-abi.h       | 3 +++
 4 files changed, 15 insertions(+)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
