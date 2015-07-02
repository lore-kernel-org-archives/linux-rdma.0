From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V4 4/5] RDMA/isert: Set REMOTE_WRITE on DMA MRs to support
 iWARP devices
Date: Thu, 02 Jul 2015 10:16:24 -0500
Message-ID: <20150702151624.12946.45034.stgit@build.ogc.int>
References: <20150702151508.12946.29133.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150702151508.12946.29133.stgit@build.ogc.int>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: roid@mellanox.com, linux-rdma@vger.kernel.org, sagig@mellanox.com, infinipath@intel.com, target-devel@vger.kernel.org, eli@mellanox.com, ogerlitz@mellanox.com
List-Id: linux-rdma@vger.kernel.org

iWARP devices require REMOTE_WRITE for MRs used as the destination of an
RDMA READ.  IB does not require this.  Since isert never advertises the
rkey of its DMA MRs to the peer, just add REMOTE_WRITE to the access flags
when allocating DMA MRs for all devices.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9e7b492..2737ade 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -383,7 +383,8 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_cq;
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
+					       IB_ACCESS_REMOTE_WRITE);
 	if (IS_ERR(device->mr)) {
 		ret = PTR_ERR(device->mr);
 		isert_err("failed to create dma mr, device %p, ret=%d\n",
