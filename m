From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Avoid possible hang on device removal
Date: Tue, 25 Oct 2016 15:50:28 -0500
Message-ID: <1477428628-11504-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When we get an RDMA_CM_EVENT_DEVICE_REMOVAL the cm_thread will
exit and because flush errors are ignored the cb->sem may not get signaled.
So just signal on device removal event.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 librdmacm/examples/rping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
index ad38f6d..53c1525 100644
--- a/librdmacm/examples/rping.c
+++ b/librdmacm/examples/rping.c
@@ -224,6 +224,8 @@ static int rping_cma_event_handler(struct rdma_cm_id *cma_id,
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		fprintf(stderr, "cma detected device removal!!!!\n");
+		cb->state = ERROR;
+		sem_post(&cb->sem);
 		ret = -1;
 		break;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
