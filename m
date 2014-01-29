From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/2] RDMA/ocrdma: ABI versioning between ocrdma and
 be2net
Date: Wed, 29 Jan 2014 11:46:28 +0000
Message-ID: <ad0a019f-b763-49f1-b58d-d8091680975c@CMEXHTCAS2.ad.emulex.com>
References: <e1f4bf5a-2dda-4537-804e-8e2280d4cc71@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e1f4bf5a-2dda-4537-804e-8e2280d4cc71-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please discard this patch. 
Due to IP based GID changes, this won't apply clean, We are planning to send you a new series of patches on for-next tree please use that instead.

-Regards
 Devesh
-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Sent: Saturday, December 14, 2013 11:44 AM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Devesh Sharma
Subject: [PATCH 1/2] RDMA/ocrdma: ABI versioning between ocrdma and be2net

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

While loading RoCE driver be2net driver should check for ABI version to catch functional incompatibilities.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h  |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
index fbac8eb..2a14d4a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
@@ -29,6 +29,7 @@
 #define __OCRDMA_ABI_H__
 
 #define OCRDMA_ABI_VERSION 1
+#define OCRDMA_BE_ROCE_ABI_VERSION 1
 /* user kernel communication data structures. */
 
 struct ocrdma_alloc_ucontext_resp {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 91443bc..bdecfcc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -540,6 +540,7 @@ static struct ocrdma_driver ocrdma_drv = {
 	.add			= ocrdma_add,
 	.remove			= ocrdma_remove,
 	.state_change_handler	= ocrdma_event_handler,
+	.be_abi_version		= OCRDMA_BE_ROCE_ABI_VERSION,
 };
 
 static void ocrdma_unregister_inet6addr_notifier(void)
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
