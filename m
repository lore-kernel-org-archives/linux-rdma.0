From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5 v2] qedr: batch of fixes for 4.10
Date: Tue, 24 Jan 2017 13:51:38 +0200
Message-ID: <1485258703-11949-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

This series contains a batch of fixes for 4.10.

Based on origin/k.o/for-4.10, over
"[PATCH 0/5 v2] qedr: QP and CQ fixes for 4.10",
on top of 5cc8fab.

Changes from v1:
 - exactly the same, except that it is built on top of
   "[PATCH 0/5 v2] qedr: QP and CQ fixes for 4.10"

Ram Amrani (5):
  qedr: mark three functions as static
  qedr: fix formatting
  qedr: fix RDMA CM loopback
  qedr: fix memory leak in PD allocation and simplify it
  qedr: dispatch port active event from qedr_add

 drivers/infiniband/hw/qedr/main.c    | 23 +++++++++++++-------
 drivers/infiniband/hw/qedr/qedr.h    |  5 +++++
 drivers/infiniband/hw/qedr/qedr_cm.c |  4 ++--
 drivers/infiniband/hw/qedr/verbs.c   | 41 +++++++++++++++++++++++-------------
 4 files changed, 48 insertions(+), 25 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
