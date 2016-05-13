From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow
 steering
Date: Fri, 13 May 2016 10:52:26 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605131020320.13832-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry slight mistake in the original patch. V2 follows



Subject: [PATCH] IB/core: Do not require CAP_NET_ADMIN for sniffing V2

Having to enable CAP_NET_ADMIN for every app that uses sniffer mode is kind
of risky. We do not want people to have the ability to mess around with the
network configuration and routing. We just want the app to direct streams and
deal with inbound data streams in various ways.

So lets drop the requirement for CAP_NET_ADMIN and keep just CAP_NET_RAW.

V1->V2
- Check for CAP_NET_ADMIN was conditional on IB_FLOW_ATTR_SNIFFER. We need
	to remove this in the correct way.
- Update description


Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/core/uverbs_cmd.c
===================================================================
--- linux.orig/drivers/infiniband/core/uverbs_cmd.c	2016-03-24 09:16:27.782778586 -0500
+++ linux/drivers/infiniband/core/uverbs_cmd.c	2016-05-13 10:49:28.953000945 -0500
@@ -3088,8 +3088,7 @@ int ib_uverbs_ex_create_flow(struct ib_u
 	if (cmd.comp_mask)
 		return -EINVAL;

-	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
-	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
+	if (!capable(CAP_NET_RAW))
 		return -EPERM;

 	if (cmd.flow_attr.flags >= IB_FLOW_ATTR_FLAGS_RESERVED)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
