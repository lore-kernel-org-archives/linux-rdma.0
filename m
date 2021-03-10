Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B63C4321A
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Mar 2021 19:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F20D64FCC
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Mar 2021 19:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhCJTEU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhCJTD5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E96164E98;
        Wed, 10 Mar 2021 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403037;
        bh=WhXFYRPJ5hNR0ip3KieHgzv6gTBOgxCYIB5+nZfp9pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riJBTIt6ufgknTj6yVL80ENanK3YzSWxIo5vMXwRPY+2X5jkHnYdCUOeXgQfH/b1K
         N5NgJ0n5GjpRB1JtEGxVlySQmoOViADsedzovK74ULPnPckNFTUtzZnt0HcWsc/49z
         x2ySZwnjyZfVKzO8bWTJdg7zb/JdH0Uuc/+J4tMx1rbhiKt/FlBZDIZ+E1At7YEeHy
         JMla/p1Dg0ZPGOsA8HJEBS9Ga3KyVZE4o2j7gC6w+5mr1WP5Qn4TqOg7kVHRn2cV56
         7nt+KwkxHMOT+sHhmEwIbX5yEsw/kZzuhwnB3WeEnh1D/rDcN008ygmvRfMyWKGjD9
         UPHS4217uDCRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/18] net/mlx5e: Don't match on Geneve options in case option masks are all zero
Date:   Wed, 10 Mar 2021 11:03:31 -0800
Message-Id: <20210310190342.238957-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The cited change added offload support for Geneve options without verifying
the validity of the options masks, this caused offload of rules with match
on Geneve options with class,type and data masks which are zero to fail.

Fix by ignoring the match on Geneve options in case option masks are
all zero.

Fixes: 9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows offload")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index e472ed0eacfb..7ed3f9f79f11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -227,6 +227,10 @@ static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 	option_key = (struct geneve_opt *)&enc_opts.key->data[0];
 	option_mask = (struct geneve_opt *)&enc_opts.mask->data[0];
 
+	if (option_mask->opt_class == 0 && option_mask->type == 0 &&
+	    !memchr_inv(option_mask->opt_data, 0, option_mask->length * 4))
+		return 0;
+
 	if (option_key->length > max_tlv_option_data_len) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Matching on GENEVE options: unsupported option len");
-- 
2.29.2

