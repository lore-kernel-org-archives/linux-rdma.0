Return-Path: <SRS0=rt4E=4I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165C0C11D07
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 10:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CDA20801
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Feb 2020 10:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgBTKIZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 20 Feb 2020 05:08:25 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38687 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726813AbgBTKIZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 20 Feb 2020 05:08:25 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Feb 2020 12:08:19 +0200
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01KA8J3n011773;
        Thu, 20 Feb 2020 12:08:19 +0200
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, leon@kernel.org, linux-rdma@vger.kernel.org
Cc:     israelr@mellanox.com, logang@deltatee.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH v2 1/2] RDMA/rw: fix error flow during RDMA context initialization
Date:   Thu, 20 Feb 2020 12:08:18 +0200
Message-Id: <20200220100819.41860-1-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In case the SGL was mapped for P2P DMA operation, we must unmap it using
pci_p2pdma_unmap_sg.

Fixes: 7f73eac3a713 ("PCI/P2PDMA: Introduce pci_p2pdma_unmap_sg()")
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/core/rw.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 4fad732f9b3c..69513b484507 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -273,6 +273,24 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 	return 1;
 }
 
+static void rdma_rw_unmap_sg(struct ib_device *dev, struct scatterlist *sg,
+		u32 sg_cnt, enum dma_data_direction dir)
+{
+	if (is_pci_p2pdma_page(sg_page(sg)))
+		pci_p2pdma_unmap_sg(dev->dma_device, sg, sg_cnt, dir);
+	else
+		ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+}
+
+static int rdma_rw_map_sg(struct ib_device *dev, struct scatterlist *sg,
+		u32 sg_cnt, enum dma_data_direction dir)
+{
+	if (is_pci_p2pdma_page(sg_page(sg)))
+		return pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
+	else
+		return ib_dma_map_sg(dev, sg, sg_cnt, dir);
+}
+
 /**
  * rdma_rw_ctx_init - initialize a RDMA READ/WRITE context
  * @ctx:	context to initialize
@@ -295,11 +313,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 	struct ib_device *dev = qp->pd->device;
 	int ret;
 
-	if (is_pci_p2pdma_page(sg_page(sg)))
-		ret = pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
-	else
-		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
-
+	ret = rdma_rw_map_sg(dev, sg, sg_cnt, dir);
 	if (!ret)
 		return -ENOMEM;
 	sg_cnt = ret;
@@ -338,7 +352,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 	return ret;
 
 out_unmap_sg:
-	ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+	rdma_rw_unmap_sg(dev, sg, sg_cnt, dir);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_rw_ctx_init);
@@ -588,11 +602,7 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		break;
 	}
 
-	if (is_pci_p2pdma_page(sg_page(sg)))
-		pci_p2pdma_unmap_sg(qp->pd->device->dma_device, sg,
-				    sg_cnt, dir);
-	else
-		ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+	rdma_rw_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 
-- 
2.20.1

