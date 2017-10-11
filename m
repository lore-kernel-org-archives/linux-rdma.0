From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 41/45] RDMA/rdmavt: Suppress gcc 7 fall-through complaints
Date: Wed, 11 Oct 2017 10:49:23 -0700
Message-ID: <20171011174927.25113-42-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 22df09ae809e..efcff7056496 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -807,6 +807,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		if (init_attr->port_num == 0 ||
 		    init_attr->port_num > ibpd->device->phys_port_cnt)
 			return ERR_PTR(-EINVAL);
+		/* fall through */
 	case IB_QPT_UC:
 	case IB_QPT_RC:
 	case IB_QPT_UD:
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
