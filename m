Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92406C433FE
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Dec 2020 12:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4309220784
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Dec 2020 12:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgLGMDV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:03:21 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9113 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgLGMDV (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Dec 2020 07:03:21 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CqMP14rHLzM1rW;
        Mon,  7 Dec 2020 20:01:57 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Dec 2020 20:02:26 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] net/mlx5_core: remove unused including <generated/utsrelease.h>
Date:   Mon, 7 Dec 2020 20:14:00 +0800
Message-ID: <1607343240-39155-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Remove including <generated/utsrelease.h> that don't need it.

Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 989c70c..82ecc161 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <generated/utsrelease.h>
 #include <linux/mlx5/fs.h>
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
-- 
2.6.2

