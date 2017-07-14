From: Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [PATCH v2 2/2] RDMA/core: Initialize port_num in qp_attr
Date: Fri, 14 Jul 2017 09:41:31 -0500
Message-ID: <1500043291-19768-3-git-send-email-mustafa.ismail@intel.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, dledford@redhat.com
Cc: swise@opengridcomputing.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, e1000-rdma@lists.sourceforge.net, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

Initialize the port_num for iWARP in rdma_init_qp_attr.

Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
Cc: <stable@vger.kernel.org> # v2.6.14+
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
---
 drivers/infiniband/core/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 31bb82d..d65a093 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1044,6 +1044,8 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 		} else
 			ret = iw_cm_init_qp_attr(id_priv->cm_id.iw, qp_attr,
 						 qp_attr_mask);
+		qp_attr->port_num = id_priv->id.port_num;
+		*qp_attr_mask |= IB_QP_PORT;
 	} else
 		ret = -ENOSYS;
 
-- 
2.7.4
