Return-Path: <SRS0=2Aje=6V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44967C38A2A
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 11:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB3620CC7
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 11:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEGLuZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 07:50:25 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:13180 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgEGLuY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 7 May 2020 07:50:24 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11]) by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee75eb3f5d03fa-3f90d; Thu, 07 May 2020 19:49:37 +0800 (CST)
X-RM-TRANSID: 2ee75eb3f5d03fa-3f90d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.0.146.193])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee65eb3f5ce9a8-d2e33;
        Thu, 07 May 2020 19:49:37 +0800 (CST)
X-RM-TRANSID: 2ee65eb3f5ce9a8-d2e33
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
Date:   Thu,  7 May 2020 19:50:10 +0800
Message-Id: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
to simplify code, avoid redundant judgements.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index af4ebd295..00e7add0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -93,9 +93,8 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 	}
 
 	rt = ip_route_output_key(dev_net(mirred_dev), fl4);
-	ret = PTR_ERR_OR_ZERO(rt);
-	if (ret)
-		return ret;
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
 
 	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
 		ip_rt_put(rt);
-- 
2.20.1.windows.1



