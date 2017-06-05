From: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 rdma for-rc 0/2] RDMA/qedr: A couple of patches
Date: Mon, 5 Jun 2017 16:32:25 +0300
Message-ID: <1496669547-22503-1-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Changes from v1:
I've rebased the patches agains 4.12-rc and request them to be added to
the rc and not for-next.
As a result I've used umem->shift instead of the now obsolete umem->page_size.

Michal Kalderon (1):
  RDMA/qedr: Initialize byte_len in WC of READ and SEND commands

Ram Amrani (1):
  RDMA/qedr: Add 64KB PAGE_SIZE support to user-space queues

 drivers/infiniband/hw/qedr/qedr.h  |  5 ++-
 drivers/infiniband/hw/qedr/verbs.c | 68 +++++++++++++++++++++++---------------
 2 files changed, 45 insertions(+), 28 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
