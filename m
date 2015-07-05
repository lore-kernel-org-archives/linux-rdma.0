From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V5 4/5] RDMA/isert: Set REMOTE_WRITE on DMA MRs to support
	iWARP devices
Date: Sun, 05 Jul 2015 12:45:00 -0500
Message-ID: <20150705174459.10042.37298.stgit@build2.ogc.int>
References: <20150705174353.10042.39648.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150705174353.10042.39648.stgit@build2.ogc.int>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: infinipath@intel.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

iWARP devices require REMOTE_WRITE for MRs used as the destination of
an RDMA READ.  So if the device protocol is iWARP, then set REMOTE_WRITE
when allocating the DMA MR.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/ulp/isert/ib_isert.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9e7b492..ee40478 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -348,6 +348,17 @@ out_cq:
 	return ret;
 }
 
+static int any_port_is_iwarp(struct isert_device *device)
+{
+	int i;
+
+	for (i = rdma_start_port(device->ib_device);
+	     i <= rdma_end_port(device->ib_device); i++)
+		if (rdma_protocol_iwarp(device->ib_device, i))
+			return 1;
+	return 0;
+}
+
 static int
 isert_create_device_ib_res(struct isert_device *device)
 {
@@ -383,7 +394,16 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_cq;
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+	/*
+	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
+	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
+	 * any port is running IWARP, add REMOTE_WRITE.
+	 */
+	if (any_port_is_iwarp(device))
+		device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
+						       IB_ACCESS_REMOTE_WRITE);
+	else
+		device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(device->mr)) {
 		ret = PTR_ERR(device->mr);
 		isert_err("failed to create dma mr, device %p, ret=%d\n",
