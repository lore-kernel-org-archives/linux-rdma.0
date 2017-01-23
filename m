From: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] qedr: QP and CQ fixes for 4.10
Date: Mon, 23 Jan 2017 17:26:22 +0200
Message-ID: <1485185187-18689-1-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

This series contains QP and CQ related fixes for 4.10.

Built against origin/k.o/for-4.10, 5cc8fab.

Ram Amrani (5):
  qedr: return success when changing from QP state X to X
  qedr: return maximum inline data capability on QP query
  qedr: remove CQ spinlock from RDMA CM completion handlers
  qedr: avoid printing error messages for flushed CQEs if QP in error
    state
  qedr: fail QP state transition from error to reset if SQ/RQ are not
    empty

 drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++--------
 drivers/infiniband/hw/qedr/verbs.c   | 19 ++++++++++++++-----
 2 files changed, 16 insertions(+), 13 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
