Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4FDE9413F
	for <linux-rdma@archiver.kernel.org>; Sat,  7 Oct 2023 04:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343527AbjJGECM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 7 Oct 2023 00:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjJGECH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 7 Oct 2023 00:02:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C21AC2;
        Fri,  6 Oct 2023 21:02:05 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S2WjX1P0GzNnxZ;
        Sat,  7 Oct 2023 11:58:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 7 Oct 2023 12:02:01 +0800
From:   Junxian Huang <huangjunxian6@hisilicon.com>
To:     <jgg@ziepe.ca>, <leon@kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <huangjunxian6@hisilicon.com>
Subject: [PATCH iproute2-next 1/2] rdma: Update uapi headers
Date:   Sat, 7 Oct 2023 11:58:54 +0800
Message-ID: <20231007035855.2273364-2-huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20231007035855.2273364-1-huangjunxian6@hisilicon.com>
References: <20231007035855.2273364-1-huangjunxian6@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500006.china.huawei.com (7.221.188.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Update rdma_netlink.h file upto kernel commit aebf8145e11a
("RDMA/core: Add support to dump SRQ resource in RAW format")

Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 92c528a0..84f775be 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -299,6 +299,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_STAT_GET_STATUS,
 
+	RDMA_NLDEV_CMD_RES_SRQ_GET_RAW,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
-- 
2.30.0

