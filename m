From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/7] IB/qib: Use rdmavt device allocation function
Date: Fri, 22 Jan 2016 13:07:23 -0800
Message-ID: <20160122210721.10962.48520.stgit@scvm10.sc.intel.com>
References: <20160122210559.10962.33295.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210559.10962.33295.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No longer do drivers need to call into the IB core to allocate the verbs
device.  Use the functionality provided by rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 5087a1f..a3c74bb 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1131,9 +1131,12 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 {
 	unsigned long flags;
 	struct qib_devdata *dd;
-	int ret;
+	int ret, nports;
 
-	dd = (struct qib_devdata *) ib_alloc_device(sizeof(*dd) + extra);
+	/* extra is * number of ports */
+	nports = extra / sizeof(struct qib_pportdata);
+	dd = (struct qib_devdata *)rvt_alloc_device(sizeof(*dd) + extra,
+						    nports);
 	if (!dd)
 		return ERR_PTR(-ENOMEM);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
