From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB: vmw_pvrdma: info leak in pvrdma_alloc_ucontext()
Date: Wed, 4 Jan 2017 09:41:11 +0300
Message-ID: <20170104064110.GA8957@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We need to clear out the ->reserved member so we don't disclose
uninitialized stack information.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
There are a bunch of ways to fix this...  I just the most mindless one
because I can never guess what IB prefers.  Feel free to fix it however
you feel is appropriate and give me a Reported-by tag.

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index 54891370d18a..c00c27f48f46 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -339,6 +339,7 @@ struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
 	context->ctx_handle = resp->ctx_handle;
 
 	/* copy back to user */
+	memset(&uresp, 0, sizeof(uresp));
 	uresp.qp_tab_size = vdev->dsr->caps.max_qp;
 	ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (ret) {
