Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD7DC41620
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Mar 2021 19:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EABF464FDE
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Mar 2021 19:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhCJTEW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhCJTEB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3609564EAE;
        Wed, 10 Mar 2021 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403041;
        bh=43+/ZZSPKSiMCVCq2+3jniZ9miyU2OH6HlnfC0/Rg+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQKl03SCXl1UUdMUfJvEYq1KpIJsFsyXBuiyYgAFnQio9pV5DcxqO7MUECyeeEmMm
         qpbWxy/p2FFO6mLyAhZaLMQpYBLAMD0G1TaOjr3Gaz6MkPDVIW/vvC/fppXlgnGm0F
         Yj7offNIYfIOTQtIXb5RepEXTSZhwlHkelbc3XPlchORV+8VLmsO8oU72x9q/QGH/i
         3aYQBEpanNT5vrrUPVUiD2098KlwU17sje7IITEh+y4392kAJZU3IgcMxDx938jctL
         mLlqE0897EimkPyegYWOoGEZ8SErXr1cRE9vF8MxG+C+tsbPLd2knQRjvoowt0Llgf
         MtLM9Z7YgMrNg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/18] net/mlx5: SF, Correct vhca context size
Date:   Wed, 10 Mar 2021 11:03:39 -0800
Message-Id: <20210310190342.238957-16-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Fix vhca context size as defined by device interface specification.

Fixes: f3196bb0f14c ("net/mlx5: Introduce vhca state event notifier")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
index 1daf5a122ba3..4fc870140d71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
@@ -20,7 +20,7 @@ struct mlx5_ifc_vhca_state_context_bits {
 
 	u8         sw_function_id[0x20];
 
-	u8         reserved_at_40[0x80];
+	u8         reserved_at_40[0x40];
 };
 
 struct mlx5_ifc_query_vhca_state_out_bits {
-- 
2.29.2

