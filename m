From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core 0/4] libqedr: cumulative updates and fixes
Date: Thu, 27 Apr 2017 09:11:04 +0300
Message-ID: <1493273468-23774-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series includes a couple of updates and a couple of fixes.

Ram Amrani (4):
  libqedr: remove obsolete device IDs
  libqedr: fail post_send on WR overflow
  libqedr: fix comments and alignment in verbs file
  libqedr: prevent EDPM loopback

 providers/qedr/qelr.h       |  1 +
 providers/qedr/qelr_main.c  | 10 ++-----
 providers/qedr/qelr_verbs.c | 71 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 61 insertions(+), 21 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
