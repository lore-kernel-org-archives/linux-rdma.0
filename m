From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] opa_vnic: fix check on record->event, incorrect operator used
Date: Thu,  4 Apr 2019 11:04:39 +0100
Message-ID: <20190404100439.19696-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check on record->event is always true because the wrong operator
is being used, used && instead of ||

Addresses-Coverity: ("Constant expression result")
Fixes: fae7a699a925 ("opa_vnic: Convert vport_idr to XArray")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 76cd09410d9a..be5befd92d16 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -869,7 +869,7 @@ static void opa_vnic_event(struct ib_event_handler *handler,
 	      record->event, dev_name(&record->device->dev),
 	      record->element.port_num);
 
-	if (record->event != IB_EVENT_PORT_ERR ||
+	if (record->event != IB_EVENT_PORT_ERR &&
 	    record->event != IB_EVENT_PORT_ACTIVE)
 		return;
 
-- 
2.20.1
