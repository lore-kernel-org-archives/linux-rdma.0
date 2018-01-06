From: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] infiniband: fix ulp/opa_vnic/opa_vnic_vema.c kernel-doc notation
Date: Fri, 05 Jan 2018 16:22:04 -0800
Message-ID: <5a5016b1.c149620a.ecab3.486f@mx.google.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use correct parameter name and description in kernel-doc notation to
eliminate a kernel-doc warning.

../drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c:730: warning: Excess function parameter 'cport' description in 'opa_vnic_vema_send_trap'

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20171222.orig/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ linux-next-20171222/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -710,7 +710,7 @@ vema_get_port(struct opa_vnic_ctrl_port
 
 /**
  * opa_vnic_vema_send_trap -- This function sends a trap to the EM
- * @cport: pointer to vnic control port
+ * @adapter: pointer to vnic adapter
  * @data: pointer to trap data filled by calling function
  * @lid:  issuers lid (encap_slid from vesw_port_info)
  *


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
