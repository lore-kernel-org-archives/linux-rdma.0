Return-Path: <SRS0=YGWR=5X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D51C2BA1A
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Apr 2020 00:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3400C2076E
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Apr 2020 00:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586218188;
	bh=qM8LL6uEKVv7hUeypNV5D5h6B/YiokxF949tvBiBp3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KLMmQEBRf05BvO06aDsgd2SfhvkCSBKgkDYptTeo+StGaagWqjr6n9BlCYr4cDXXO
	 uzM8DQrAnaRqxdA4U0WV823P1XVzH5rkw5tnqMHiY576dcZbQlagDi1mQdTKxZEyCD
	 pH3HWyeJ1qsXerkVhXbS4FH11hDa6eQ2sTv5JfZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgDGAJo (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgDGABG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C70620768;
        Tue,  7 Apr 2020 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217665;
        bh=qM8LL6uEKVv7hUeypNV5D5h6B/YiokxF949tvBiBp3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVNx8z+dOuUhqS68n/W7Exh8iOk9kunPNtkft0hmbhq34HovW6t6aZOEPi7CpqtmJ
         kQ80qb3CWLc2uPKbO3ikalqX+nfEVEEuom5g5ZUquoBTLoA5UK0XogXuMcnfRhUvRu
         6/MbzqUYEIwUht/N9KcjGg2FmBfXfKo8wpCbKhCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 05/35] net/mlx5e: kTLS, Fix wrong value in record tracker enum
Date:   Mon,  6 Apr 2020 20:00:27 -0400
Message-Id: <20200407000058.16423-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit f28ca65efa87b3fb8da3d69ca7cb1ebc0448de66 ]

Fix to match the HW spec: TRACKING state is 1, SEARCHING is 2.
No real issue for now, as these values are not currently used.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index a3efa29a4629d..63116be6b1d60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -38,8 +38,8 @@ enum {
 
 enum {
 	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     = 0,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 1,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 2,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 2,
 };
 
 struct mlx5e_ktls_offload_context_tx {
-- 
2.20.1

