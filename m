From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs 5/5] Don't try to send UD messages larger than MTU
Date: Sun, 14 Oct 2012 13:03:03 -0400
Message-ID: <63dd133c0290d70c664cb3cb55392830ac71a6a7.1350234101.git.dledford@redhat.com>
References: <cover.1350234101.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The UD protocol doesn't support message sizes larger than the path
MTU.  We don't go so far as to check path MTU, but we do check port
MTU.  This prevents failed runs of the pingpong_ud program with large
MTUs.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 examples/ud_pingpong.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 71b152d..9a1ae13 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -323,6 +323,20 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 			ibv_get_device_name(ib_dev));
 		return NULL;
 	}
+	{
+		struct ibv_port_attr port_info = { 0 };
+		int mtu;
+
+		if (ibv_query_port(ctx->context, port, &port_info)) {
+			fprintf(stderr, "Unable to query port info for port %d\n", port);
+			return NULL;
+		}
+		mtu = 1 << (port_info.active_mtu + 7);
+		if (size > mtu) {
+			fprintf(stderr, "Requested size larger than port MTU (%d)\n", mtu);
+			return NULL;
+		}
+	}
 
 	if (use_event) {
 		ctx->channel = ibv_create_comp_channel(ctx->context);
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
