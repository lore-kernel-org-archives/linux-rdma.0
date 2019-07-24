Return-Path: <SRS0=tGD2=VV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8E8C76186
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Jul 2019 03:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90999206A2
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Jul 2019 03:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfGXDpW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Jul 2019 23:45:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2744 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfGXDpW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Jul 2019 23:45:22 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7FACC3A2733C13E2EE4B;
        Wed, 24 Jul 2019 11:45:19 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 11:45:13 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <oulijun@huawei.com>, <xavier.huwei@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] RDMA/hns: Fix build error for hip06
Date:   Wed, 24 Jul 2019 11:44:28 +0800
Message-ID: <20190724034428.13944-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190723024535.61412-1-yuehaibing@huawei.com>
References: <20190723024535.61412-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

If INFINIBAND_HNS_HIP06 is selected and HNS_DSAF
is m, but INFINIBAND_HNS is y, building fails:

drivers/infiniband/hw/hns/hns_roce_hw_v1.o: In function `hns_roce_v1_reset':
hns_roce_hw_v1.c:(.text+0x39fa): undefined reference to `hns_dsaf_roce_reset'
hns_roce_hw_v1.c:(.text+0x3a25): undefined reference to `hns_dsaf_roce_reset'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 08805fdbeb2d ("RDMA/hns: Split hw v1 driver from hns roce driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: use select instead of depends
---
 drivers/infiniband/hw/hns/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
index b9dfac0..5f6d750 100644
--- a/drivers/infiniband/hw/hns/Kconfig
+++ b/drivers/infiniband/hw/hns/Kconfig
@@ -12,7 +12,8 @@ config INFINIBAND_HNS
 
 config INFINIBAND_HNS_HIP06
 	bool "Hisilicon Hip06 Family RoCE support"
-	depends on INFINIBAND_HNS && HNS && HNS_DSAF && HNS_ENET
+	depends on INFINIBAND_HNS && HNS && HNS_ENET
+	select HNS_DSAF
 	---help---
 	  RoCE driver support for Hisilicon RoCE engine in Hisilicon Hip06 and
 	  Hip07 SoC. These RoCE engines are platform devices.
-- 
2.7.4


