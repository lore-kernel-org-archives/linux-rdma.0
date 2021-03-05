Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B523C433E6
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Mar 2021 08:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F9764FE6
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Mar 2021 08:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCEItH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229615AbhCEIsv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 5 Mar 2021 03:48:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF5C064DE8;
        Fri,  5 Mar 2021 08:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614934130;
        bh=DqeCSUwH6c0N0clX8uq/415p4ecGV26XXLYTS0utyyg=;
        h=Date:From:To:Cc:Subject:From;
        b=IjG3eqC02GIFIi+xAKxBkFkAPMXgNbEhTiUzTvVgM1VtDmG5HhXBWzjGIyVHtrVx8
         Y52g/18YYsSFAI+ttyN73GZwEoNYyVCIHAUGIFl3bSZYeNOXqnr9MPOfLdZ4ecbyZg
         cWhJvKF1SMnEtJsoRjtcNVz0egAtP331ngGm1w7Si1ttY/YxFl+1zM+8wg6PeDatDX
         b69qoMxrD+Zik8k1RWiT1DXb+wyWUshACHNWMPAeVsgb494EocZGf8O+Z65m2l3O2O
         NbgiJm9Aj4RCi3AWGr5UxPu0K/eaYcKHEEQs5ZS10Zt0wfc14MT2wUh44AYjuGxigc
         e/atl5SthC2gw==
Date:   Fri, 5 Mar 2021 02:48:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net/mlx4: Fix fall-through warnings for Clang
Message-ID: <20210305084847.GA138343@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index a99e71bc7b3c..771b92019af1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -2660,6 +2660,7 @@ int mlx4_FREE_RES_wrapper(struct mlx4_dev *dev, int slave,
 	case RES_XRCD:
 		err = xrcdn_free_res(dev, slave, vhcr->op_modifier, alop,
 				     vhcr->in_param, &vhcr->out_param);
+		break;
 
 	default:
 		break;
-- 
2.27.0

