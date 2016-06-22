From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 0/1] Fix for nvme-rdma host crash in nvmf-all.3
Date: Wed, 22 Jun 2016 13:14:59 -0700
Message-ID: <cover.1466626499.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes a touch-after-free bug I discovered.  It is against
nvmf-all.3 branch of git://git.infradead.org/nvme-fabrics.git.  The patch
is kind of ugly, so any ideas on a cleaner solution are welcome.

Steve Wise (1):
  nvme-rdma: correctly unwind on bad subsystemnqn error

 drivers/nvme/host/rdma.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
