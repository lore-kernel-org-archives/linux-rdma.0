From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/12] IB/qib: Setup notify free/create mad agent callbacks
 for rdmavt
Date: Sun, 14 Feb 2016 12:10:45 -0800
Message-ID: <20160214201042.1410.51898.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Qib needs to be notified when mad agents are created and freed, there is
some counter maintenance that needs to be performed. Add those callbacks at
registration time with rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 5cf019f..cbf6200 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1682,6 +1682,10 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.query_port_state = qib_query_port;
 	dd->verbs_dev.rdi.driver_f.shut_down_port = qib_shut_down_port;
 	dd->verbs_dev.rdi.driver_f.cap_mask_chg = qib_cap_mask_chg;
+	dd->verbs_dev.rdi.driver_f.notify_create_mad_agent =
+						qib_notify_create_mad_agent;
+	dd->verbs_dev.rdi.driver_f.notify_free_mad_agent =
+						qib_notify_free_mad_agent;
 
 	dd->verbs_dev.rdi.dparms.max_rdma_atomic = QIB_MAX_RDMA_ATOMIC;
 	dd->verbs_dev.rdi.driver_f.get_guid_be = qib_get_guid_be;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
