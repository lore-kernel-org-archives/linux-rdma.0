From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] qedr: cumulative fixes for user verbs
Date: Thu, 22 Dec 2016 14:40:32 +0200
Message-ID: <1482410440-2297-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series introduces eight fixes for the various verbs.

Ram Amrani (8):
  qedr: configure the number of CQEs on CQ creation
  qedr: return error if destroy CQ failed
  qedr: return correct value on modify qp
  qedr: modify QP state to error when destroying it
  qedr: ignore inline flag in read verbs
  qedr: post_send/recv according to QP state
  qedr: clear the vendor error field in the work completion
  qedr: Always notify the verb consumer of flushed CQEs

 drivers/infiniband/hw/qedr/verbs.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
