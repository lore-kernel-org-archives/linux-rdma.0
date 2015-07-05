From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to
	device fastreg max depth
Date: Sun, 05 Jul 2015 12:44:54 -0500
Message-ID: <20150705174452.10042.44695.stgit@build2.ogc.int>
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

Currently the sg tablesize, which dictates fast register page list
depth to use, does not take into account the limits of the rdma device.
So adjust it once we discover the device fastreg max depth limit.  Also
adjust the max_sectors based on the resulting sg tablesize.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/ulp/iser/iscsi_iser.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6a594aa..de8730d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 						   SHOST_DIX_GUARD_CRC);
 		}
 
+		/*
+		 * Limit the sg_tablesize and max_sectors based on the device
+		 * max fastreg page list length.
+		 */
+		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
+			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
+		shost->max_sectors = min_t(unsigned int,
+			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
+
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
 			mutex_unlock(&iser_conn->state_mutex);
