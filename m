Return-Path: <SRS0=Sij9=6I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD9BC54FCB
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Apr 2020 13:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C96020728
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Apr 2020 13:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgDXNrO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:47:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3288 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726895AbgDXNrO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 24 Apr 2020 09:47:14 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 368F1BF29C90C2F48167;
        Fri, 24 Apr 2020 21:47:05 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 21:46:57 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] net/mlx4_core: Add missing iounmap() in error path
Date:   Fri, 24 Apr 2020 21:53:14 +0800
Message-ID: <1587736394-111502-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This fixes the following coccicheck warning:

drivers/net/ethernet/mellanox/mlx4/crdump.c:200:2-8: ERROR: missing iounmap;
ioremap on line 190 and execution via conditional on line 198

Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 73eae80e..ac5468b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -197,6 +197,7 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	err = devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
 		mlx4_err(dev, "crdump: devlink get snapshot id err %d\n", err);
+		iounmap(cr_space);
 		return err;
 	}
 
-- 
2.6.2

