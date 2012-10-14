From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs 4/5] Don't print link phys state on iWARP
Date: Sun, 14 Oct 2012 13:03:02 -0400
Message-ID: <48368501962d0c62796e8d526bd5f680abc99049.1350234101.git.dledford@redhat.com>
References: <cover.1350234101.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The physical link state on iWARP transports has no meaning, so
don't print it out at all.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 examples/devinfo.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index d6e9218..ff078e4 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -327,8 +327,9 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 			       width_str(port_attr.active_width), port_attr.active_width);
 			printf("\t\t\tactive_speed:\t\t%s (%d)\n",
 			       speed_str(port_attr.active_speed), port_attr.active_speed);
-			printf("\t\t\tphys_state:\t\t%s (%d)\n",
-			       port_phy_state_str(port_attr.phys_state), port_attr.phys_state);
+			if (ib_dev->transport_type == IBV_TRANSPORT_IB)
+				printf("\t\t\tphys_state:\t\t%s (%d)\n",
+				       port_phy_state_str(port_attr.phys_state), port_attr.phys_state);
 
 			if (print_all_port_gids(ctx, port, port_attr.gid_tbl_len))
 				goto cleanup;
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
