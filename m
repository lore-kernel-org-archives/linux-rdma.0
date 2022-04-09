Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F37AC433F5
	for <linux-rdma@archiver.kernel.org>; Sat,  9 Apr 2022 08:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbiDIIfl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 9 Apr 2022 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiDIIfk (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 9 Apr 2022 04:35:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D0A2B1BC
        for <linux-rdma@vger.kernel.org>; Sat,  9 Apr 2022 01:33:34 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kb7fj68CGzdZLf;
        Sat,  9 Apr 2022 16:33:01 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 9 Apr 2022 16:33:32 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 9 Apr 2022 16:33:32 +0800
From:   Wenpeng Liang <liangwenpeng@huawei.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <liangwenpeng@huawei.com>
Subject: [PATCH for-next 4/5] RDMA/hns: Add judgment on the execution result of CMDQ that free vf resource
Date:   Sat, 9 Apr 2022 16:32:53 +0800
Message-ID: <20220409083254.9696-5-liangwenpeng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220409083254.9696-1-liangwenpeng@huawei.com>
References: <20220409083254.9696-1-liangwenpeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

CDMQ may fail to execute, so its return value should not be ignored.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index aa3eca16e04a..5d6da396586d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1510,7 +1510,7 @@ static void __hns_roce_function_clear(struct hns_roce_dev *hr_dev, int vf_id)
 	hns_roce_func_clr_rst_proc(hr_dev, ret, fclr_write_fail_flag);
 }
 
-static void hns_roce_free_vf_resource(struct hns_roce_dev *hr_dev, int vf_id)
+static int hns_roce_free_vf_resource(struct hns_roce_dev *hr_dev, int vf_id)
 {
 	enum hns_roce_opcode_type opcode = HNS_ROCE_OPC_ALLOC_VF_RES;
 	struct hns_roce_cmq_desc desc[2];
@@ -1521,17 +1521,26 @@ static void hns_roce_free_vf_resource(struct hns_roce_dev *hr_dev, int vf_id)
 	desc[0].flag |= cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
 	hns_roce_cmq_setup_basic_desc(&desc[1], opcode, false);
 	hr_reg_write(req_a, FUNC_RES_A_VF_ID, vf_id);
-	hns_roce_cmq_send(hr_dev, desc, 2);
+
+	return hns_roce_cmq_send(hr_dev, desc, 2);
 }
 
 static void hns_roce_function_clear(struct hns_roce_dev *hr_dev)
 {
+	int ret;
 	int i;
 
 	for (i = hr_dev->func_num - 1; i >= 0; i--) {
 		__hns_roce_function_clear(hr_dev, i);
-		if (i != 0)
-			hns_roce_free_vf_resource(hr_dev, i);
+
+		if (i == 0)
+			continue;
+
+		ret = hns_roce_free_vf_resource(hr_dev, i);
+		if (ret)
+			ibdev_err(&hr_dev->ib_dev,
+				  "failed to free vf resource, vf_id = %d, ret = %d.\n",
+				  i, ret);
 	}
 }
 
-- 
2.33.0

