Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961AEEB64DD
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Aug 2023 06:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjHGGpV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Aug 2023 02:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjHGGpU (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Aug 2023 02:45:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDB4BA;
        Sun,  6 Aug 2023 23:45:19 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RK6DQ1H42zNmj8;
        Mon,  7 Aug 2023 14:41:42 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 14:45:09 +0800
From:   Junxian Huang <huangjunxian6@hisilicon.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <huangjunxian6@hisilicon.com>
Subject: [PATCH for-rc] MAINTAINERS: Remove maintainer of HiSilicon RoCE
Date:   Mon, 7 Aug 2023 14:42:28 +0800
Message-ID: <20230807064228.4032536-1-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500006.china.huawei.com (7.221.188.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Haoyue no longer maintains the Hisilicon RoCE driver. So remove him
from MAINTAINERS.

Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3be1bdfe8ecc..a65e2f53bffa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9364,7 +9364,6 @@ F:	drivers/crypto/hisilicon/sgl.c
 F:	include/linux/hisi_acc_qm.h
 
 HISILICON ROCE DRIVER
-M:	Haoyue Xu <xuhaoyue1@hisilicon.com>
 M:	Junxian Huang <huangjunxian6@hisilicon.com>
 L:	linux-rdma@vger.kernel.org
 S:	Maintained
-- 
2.30.0

