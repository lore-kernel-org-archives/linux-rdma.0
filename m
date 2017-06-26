From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 0/3] RDMA/qedr: User-to-kernel space patches
Date: Mon, 26 Jun 2017 19:05:03 +0300
Message-ID: <1498493106-28604-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The first patch is a fix that prevents memory overrun.
Thanks Jason.

The other two add new parameters that are passed to rdma-core.

Ram Amrani (3):
  RDMA/qedr: Prevent memory overrun in verbs' user responses
  RDMA/qedr: notify user application if DPM is supported
  RDMA/qedr: notify user application of supported WIDs

 drivers/infiniband/hw/qedr/main.c  |  1 +
 drivers/infiniband/hw/qedr/qedr.h  |  2 ++
 drivers/infiniband/hw/qedr/verbs.c | 19 +++++++++++++++----
 include/uapi/rdma/qedr-abi.h       |  3 +++
 4 files changed, 21 insertions(+), 4 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
