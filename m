From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 08/11] IB/SA: Program extended LID in SM Address handle
Date: Tue, 22 Nov 2016 14:38:49 -0500
Message-ID: <1479843532-47496-9-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reuse port_attr.grh_required field to let IB SA know that extended LID
information needs to be set in the SM Address handle for OPA devices

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 8 +++++++-
 include/rdma/opa_addr.h            | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 81b742c..d59ee67 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -50,6 +50,7 @@
 #include <uapi/rdma/ib_user_sa.h>
 #include <rdma/ib_marshall.h>
 #include <rdma/ib_addr.h>
+#include <rdma/opa_addr.h>
 #include "sa.h"
 #include "core_priv.h"
 
@@ -964,7 +965,12 @@ static void update_sm_ah(struct work_struct *work)
 	if (port_attr.grh_required) {
 		ah_attr.ah_flags = IB_AH_GRH;
 		ah_attr.grh.dgid.global.subnet_prefix = cpu_to_be64(port_attr.subnet_prefix);
-		ah_attr.grh.dgid.global.interface_id = cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
+		if (rdma_cap_opa_ah(port->agent->device, port->port_num))
+			ah_attr.grh.dgid.global.interface_id =
+				OPA_MAKE_ID(ah_attr.dlid);
+		else
+			ah_attr.grh.dgid.global.interface_id =
+				cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
 	}
 
 	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
index 3e22937..5c713bc 100644
--- a/include/rdma/opa_addr.h
+++ b/include/rdma/opa_addr.h
@@ -38,6 +38,7 @@
 #define OPA_TO_IB_UCAST_LID(x)	(((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
 				 ? 0 : x)
 #define	OPA_SPECIAL_OUI		(0x00066AULL)
+#define OPA_MAKE_ID(x)          (cpu_to_be64(OPA_SPECIAL_OUI << 40 | (x)))
 
 /**
  * ib_is_opa_gid: Returns true if the top 24 bits of the gid
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
