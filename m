From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 10/23] verbs: Use inttypes.h format string macros
Date: Wed, 21 Sep 2016 16:08:36 -0600
Message-ID: <1474495729-17604-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Otherwise a 32bit compile of ibv_devinfo will print garbage for
these values.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/devinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index 1d0c2dbde9b0..e814bacdf7aa 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -474,13 +474,13 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 
 		print_odp_caps(&device_attr.odp_caps);
 		if (device_attr.completion_timestamp_mask)
-			printf("\tcompletion timestamp_mask:\t\t\t0x%016lx\n",
+			printf("\tcompletion timestamp_mask:\t\t\t0x%016" PRIx64 "\n",
 			       device_attr.completion_timestamp_mask);
 		else
 			printf("\tcompletion_timestamp_mask not supported\n");
 
 		if (device_attr.hca_core_clock)
-			printf("\thca_core_clock:\t\t\t%lukHZ\n", device_attr.hca_core_clock);
+			printf("\thca_core_clock:\t\t\t%" PRIu64 "kHZ\n", device_attr.hca_core_clock);
 		else
 			printf("\tcore clock not supported\n");
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
