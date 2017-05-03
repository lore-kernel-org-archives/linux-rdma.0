From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 06/15] IB/hfi1: Return an error on memory allocation failure
Date: Tue, 02 May 2017 17:41:35 -0700
Message-ID: <20170503004134.6965.97019.stgit@scvm10.sc.intel.com>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

If the eager buffer allocation fails, it is necessary to return
an error code.

Cc: stable@vger.kernel.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index c573f06..b2db776 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1778,6 +1778,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			    !HFI1_CAP_KGET_MASK(rcd->flags, MULTI_PKT_EGR)) {
 				dd_dev_err(dd, "ctxt%u: Failed to allocate eager buffers\n",
 					   rcd->ctxt);
+				ret = -ENOMEM;
 				goto bail_rcvegrbuf_phys;
 			}
 
