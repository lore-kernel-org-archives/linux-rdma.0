From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/core: Introduce driver QP type
Date: Tue, 26 Dec 2017 11:16:31 +0200
Message-ID: <20171226091634.2352-4-leon@kernel.org>
References: <20171226091634.2352-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171226091634.2352-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Vendors can implement type of QPs that are not described in the
InfiniBand specification. To still be able to use the IB/core layer
services (e.g. user object management) without tainting this layer with
driver proprietary logic, a new QP type is added - IB_QPT_DRIVER. This
will be a general QP type that the core layer doesn't know about its true nature.
When a command like create_qp() is passed to a hardware driver the extra
data that is required is taken from the driver channel.
Downstream patches from this series will use that QP type in the mlx5
driver.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 64032f4c8d5a..41d4f59cac5e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1083,6 +1083,7 @@ enum ib_qp_type {
 	IB_QPT_XRC_INI = 9,
 	IB_QPT_XRC_TGT,
 	IB_QPT_MAX,
+	IB_QPT_DRIVER = 0xFF,
 	/* Reserve a range for qp types internal to the low level driver.
 	 * These qp types will not be visible at the IB core layer, so the
 	 * IB_QPT_MAX usages should not be affected in the core layer
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
