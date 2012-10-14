From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs 1/5] Add an error when the user specifies an invalid port
Date: Sun, 14 Oct 2012 13:02:59 -0400
Message-ID: <8f855d0237d6e25a8b161aa083a741dbd1a70c28.1350234101.git.dledford@redhat.com>
References: <cover.1350234101.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 examples/devinfo.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 7dc0463..b1a3b2e 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -218,10 +218,16 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		goto cleanup;
 	}
 	if (ibv_query_device(ctx, &device_attr)) {
-		fprintf(stderr, "Failed to query device props");
+		fprintf(stderr, "Failed to query device props\n");
 		rc = 2;
 		goto cleanup;
 	}
+	if (ib_port && ib_port > device_attr.phys_port_cnt) {
+		fprintf(stderr, "Invalid port requested for device\n");
+		/* rc = 3 is taken by failure to clean up */
+		rc = 4;
+		goto cleanup;
+	}
 
 	printf("hca_id:\t%s\n", ibv_get_device_name(ib_dev));
 	printf("\ttransport:\t\t\t%s (%d)\n",
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
