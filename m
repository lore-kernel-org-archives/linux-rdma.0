Return-Path: <SRS0=j6t7=6T=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C231BC47254
	for <linux-rdma@archiver.kernel.org>; Tue,  5 May 2020 10:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4977206A4
	for <linux-rdma@archiver.kernel.org>; Tue,  5 May 2020 10:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEEKaa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 5 May 2020 06:30:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728547AbgEEKa3 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 5 May 2020 06:30:29 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8558CD311C5FE287AA5B;
        Tue,  5 May 2020 18:30:25 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 5 May 2020 18:30:16 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 1/3] RDMA/hns: Add a macro for next generation of hip08
Date:   Tue, 5 May 2020 18:30:05 +0800
Message-ID: <1588674607-25337-2-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1588674607-25337-1-git-send-email-liweihang@huawei.com>
References: <1588674607-25337-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

0x30 is the new revision id for next generation of the pci device hip08,
add a macro of it for further features.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index ecbfeb6..c38ebce 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -37,9 +37,10 @@
 
 #define DRV_NAME "hns_roce"
 
-/* hip08 is a pci device, it includes two version according pci version id */
+/* hip08 is a pci device of three versions according to the revision id */
 #define PCI_REVISION_ID_HIP08_A			0x20
 #define PCI_REVISION_ID_HIP08_B			0x21
+#define PCI_REVISION_ID_HIP08_C			0x30
 
 #define HNS_ROCE_HW_VER1	('h' << 24 | 'i' << 16 | '0' << 8 | '6')
 
-- 
2.8.1

