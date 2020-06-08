Return-Path: <SRS0=N7RC=7W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79840C433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 00:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42021207ED
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 00:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591662357;
	bh=lPvZX0Wp2EfZQC/gJBV02gxIl1d/7MDhp2Ch2tlx7JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZsxThzwnwNiSsa0T9X16/dephemBzrND1MyNrJBXWMafL+DsKPLkpM9JV3WAD89ph
	 /Ly9pDmTNk6Cue635QaJlT+FIYYJcd45zSYdvfg5rQwkS1ILqD2jJOxl2QBq8NGEQP
	 kh6ZHXELE9Z0Hs7qnOPMf1xw9SIRhfkWjF8um5Dg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgFHXQy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730348AbgFHXQw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC5E2083E;
        Mon,  8 Jun 2020 23:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658212;
        bh=lPvZX0Wp2EfZQC/gJBV02gxIl1d/7MDhp2Ch2tlx7JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCbQmY839ZShz7ppcefFc0xltfYriiuYC+XVVvOExCG7Tp1ZXSJR6GUGPI4yFx6c+
         gf3ubzs18AEbmFpuE2o23YP+BE6yiJjg6lq4k98Qjau+oPf4BtSvCMsPsozUkfhYaM
         w7v5CmQAocfhiXwjW6WYZGdqN9Y9hotKNwGFLQjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 229/606] net/mlx5e: kTLS, Destroy key object after destroying the TIS
Date:   Mon,  8 Jun 2020 19:05:54 -0400
Message-Id: <20200608231211.3363633-229-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 16736e11f43b80a38f98f6add54fab3b8c297df3 ]

The TLS TIS object contains the dek/key ID.
By destroying the key first, the TIS would contain an invalid
non-existing key ID.
Reverse the destroy order, this also acheives the desired assymetry
between the destroy and the create flows.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 46725cd743a3..7d1985fa0d4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -69,8 +69,8 @@ static void mlx5e_ktls_del(struct net_device *netdev,
 	struct mlx5e_ktls_offload_context_tx *tx_priv =
 		mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
-	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
 	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
+	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
 	kvfree(tx_priv);
 }
 
-- 
2.25.1

