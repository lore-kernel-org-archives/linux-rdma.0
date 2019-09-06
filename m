Return-Path: <SRS0=objV=XB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49833C43331
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Sep 2019 14:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28ABB20854
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Sep 2019 14:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394263AbfIFORs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 6 Sep 2019 10:17:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41046 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392868AbfIFORs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 6 Sep 2019 10:17:48 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 893DF1D8CAAEA04C5933;
        Fri,  6 Sep 2019 22:17:45 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 6 Sep 2019
 22:17:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <oulijun@huawei.com>, <xavier.huwei@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] RDMA/hns: use devm_platform_ioremap_resource() to simplify code
Date:   Fri, 6 Sep 2019 22:17:27 +0800
Message-ID: <20190906141727.26552-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index dc9a1cd..5f74bf5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -4511,7 +4511,6 @@ static int hns_roce_get_cfg(struct hns_roce_dev *hr_dev)
 	struct platform_device *pdev = NULL;
 	struct net_device *netdev = NULL;
 	struct device_node *net_node;
-	struct resource *res;
 	int port_cnt = 0;
 	u8 phy_port;
 	int ret;
@@ -4550,8 +4549,7 @@ static int hns_roce_get_cfg(struct hns_roce_dev *hr_dev)
 	}
 
 	/* get the mapped register base address */
-	res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
-	hr_dev->reg_base = devm_ioremap_resource(dev, res);
+	hr_dev->reg_base = devm_platform_ioremap_resource(hr_dev->pdev, 0);
 	if (IS_ERR(hr_dev->reg_base))
 		return PTR_ERR(hr_dev->reg_base);
 
-- 
2.7.4


