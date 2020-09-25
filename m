Return-Path: <SRS0=psLl=DC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BE6C4727D
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Sep 2020 16:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B144E22B2D
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Sep 2020 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601052223;
	bh=vCavm+41tX+dRSaZvXie4KfHuLanChjfGVl1TGFbDho=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=R16dI7r1mzQBOYCKVz3cgGGWBlTol59gd+T4b/p23I8P+ZlAvpwOMLoZzTTwy17My
	 2ts8xDWn8TL4ExVTQZz1m3EeJEeTU6eS5pOr9qZQriZIUa4Gt9Ha9sYVUdzW5TzqX3
	 CTyDKBjkgbck+1AtGWKlfPRncRN3sbqj3HzuZ5tM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgIYQnn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbgIYQnn (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 25 Sep 2020 12:43:43 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5867B2075F;
        Fri, 25 Sep 2020 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601052222;
        bh=vCavm+41tX+dRSaZvXie4KfHuLanChjfGVl1TGFbDho=;
        h=Date:From:To:Cc:Subject:From;
        b=Zs81yYRt72eFESB9GdL18cG5D5L3wZXGBJm8A/A5BIWV6hFX9ROv9Ki/nHNuEdyMK
         9MuMXSfaNoZxtRSkgdBYpUjDEWCQmttoWBmmpQP6H3oZElrY0YTD1cUpVFl4cCyZSx
         Y1YoqSv1lcxMGntcYYbFALXaoxpQNvtZDQra9yhY=
Date:   Fri, 25 Sep 2020 11:49:13 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ariel Levkovich <lariel@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net/mlx5e: Fix potential null pointer dereference
Message-ID: <20200925164913.GA18472@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Calls to kzalloc() and kvzalloc() should be null-checked
in order to avoid any potential failures. In this case,
a potential null pointer dereference.

Fix this by adding null checks for _parse_attr_ and _flow_
right after allocation.

Addresses-Coverity-ID: 1497154 ("Dereference before null check")
Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f815b0c60a6c..fb27154bfddb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4534,20 +4534,22 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr;
 	struct mlx5e_tc_flow *flow;
-	int out_index, err;
+	int err = -ENOMEM;
+	int out_index;
 
 	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 	parse_attr = kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
+	if (!parse_attr || !flow)
+		goto err_free;
 
 	flow->flags = flow_flags;
 	flow->cookie = f->cookie;
 	flow->priv = priv;
 
 	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
-	if (!parse_attr || !flow || !attr) {
-		err = -ENOMEM;
+	if (!attr)
 		goto err_free;
-	}
+
 	flow->attr = attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
-- 
2.27.0

