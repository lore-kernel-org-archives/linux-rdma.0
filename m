From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/usnic: clean up some error handling code
Date: Thu, 4 Jun 2015 12:02:18 +0300
Message-ID: <20150604090218.GD22838@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Upinder Malhi <umalhi@cisco.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This code causes a static checker warning:

	drivers/infiniband/hw/usnic/usnic_uiom.c:476 usnic_uiom_alloc_pd()
	warn: passing zero to 'PTR_ERR'

This code isn't buggy, but iommu_domain_alloc() doesn't return an error
pointer so we can simplify the error handling and silence the static
checker warning.

The static checker warning is to catch place which do:

	if (!ptr)
		return ERR_PTR(ptr);

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 417de1f..cb2337f 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -472,11 +472,10 @@ struct usnic_uiom_pd *usnic_uiom_alloc_pd(void)
 		return ERR_PTR(-ENOMEM);
 
 	pd->domain = domain = iommu_domain_alloc(&pci_bus_type);
-	if (IS_ERR_OR_NULL(domain)) {
-		usnic_err("Failed to allocate IOMMU domain with err %ld\n",
-				PTR_ERR(pd->domain));
+	if (!domain) {
+		usnic_err("Failed to allocate IOMMU domain");
 		kfree(pd);
-		return ERR_PTR(domain ? PTR_ERR(domain) : -ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	iommu_set_fault_handler(pd->domain, usnic_uiom_dma_fault, NULL);
