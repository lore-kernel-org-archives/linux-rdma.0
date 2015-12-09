From: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/usnic: Remove unused prototype
Date: Wed,  9 Dec 2015 10:39:49 -0800
Message-ID: <1449686389-26896-1-git-send-email-neescoba@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

query_protocol() was added in commit 6b90a6d66b17 ("IB/Verbs:
Implement new callback query_protocol()") and then removed in
commit f9b22e355d38 ("IB/core: Convert core to use bitfield
for caps").

This left behind an unused prototype.

Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 414eaa5..0d9d2e6a 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -43,8 +43,6 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 			  struct ib_udata *uhw);
 int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 				struct ib_port_attr *props);
-enum rdma_protocol_type
-usnic_ib_query_protocol(struct ib_device *device, u8 port_num);
 int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 				int qp_attr_mask,
 				struct ib_qp_init_attr *qp_init_attr);
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
