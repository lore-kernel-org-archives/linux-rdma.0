From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v5 8/8] nvmet_rdma: log the connection reject message
Date: Wed, 26 Oct 2016 12:36:48 -0700
Message-ID: <2e41003ee6e18be607c7db7536da3e0c4ebd45da.1477510827.git.swise@opengridcomputing.com>
References: <cover.1477510827.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477510827.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 1cbe6e0..8315224 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1358,6 +1358,9 @@ static int nvmet_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		ret = nvmet_rdma_device_removal(cm_id, queue);
 		break;
 	case RDMA_CM_EVENT_REJECTED:
+		pr_debug("Connection rejected: %s\n",
+			 rdma_reject_msg(cm_id, event->status));
+		/* FALLTHROUGH */
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 		nvmet_rdma_queue_connect_fail(cm_id, queue);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
