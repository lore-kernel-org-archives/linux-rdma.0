From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] IB/usnic: use GFP_ATOMIC under spinlock
Date: Mon, 20 Jan 2014 13:32:49 +0300
Message-ID: <20140120103248.GE14233@elgon.mountain>
References: <20131211223934.GB3955@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131211223934.GB3955-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is called from qp_grp_and_vf_bind() and we are holding the
"vf->lock" so the allocation can't sleep.

Fixes: e3cf00d0a87f ('IB/usnic: Add Cisco VIC low-level hardware driver')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index ae6934c0d05a..16755cdab2c0 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -498,7 +498,7 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
 	struct usnic_uiom_dev *uiom_dev;
 	int err;
 
-	uiom_dev = kzalloc(sizeof(*uiom_dev), GFP_KERNEL);
+	uiom_dev = kzalloc(sizeof(*uiom_dev), GFP_ATOMIC);
 	if (!uiom_dev)
 		return -ENOMEM;
 	uiom_dev->dev = dev;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
