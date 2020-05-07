Return-Path: <SRS0=2Aje=6V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E6AC47247
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 14:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B795E2084D
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588861650;
	bh=e0b9s7OdLWu3UwsM0eMiCMeu0kR0EfPAyMaj/JB6Kn0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hvGPn4NqPh9fG3x3BMhi0XmaM5FfwyR5g+UYPWEq3GxpEWpqM8G8SsDWmDawe8ArA
	 1C2Udxkh463wR/rdkmkjgh4nhsqNcBhwda+6KMRhJ8duCdGHxAXkrcrN1D8aHUJQoA
	 tHYyRggA91/MiI2yS5e026Ymh3Ew1hy2gzvYNzwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgEGO13 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 10:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgEGO13 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 7 May 2020 10:27:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F272083B;
        Thu,  7 May 2020 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861648;
        bh=e0b9s7OdLWu3UwsM0eMiCMeu0kR0EfPAyMaj/JB6Kn0=;
        h=From:To:Cc:Subject:Date:From;
        b=y43Hqv7n6ShLSM2r6jRu3EKehaMZ+XFMaK9OX7Zw5lwQUrMID4ybRcvYr4xDzflwx
         TFnYfScoKnleAmg7z2fE5YdkF1/KrYWiy3PIkUBBQGL55ekV5eRzi88mLgslvzBv8j
         RJZICRVCmXju7poUxCzJjmwbmFCuSg4pP6P2FDnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Hleihel <alaa@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 01/50] RDMA/mlx4: Initialize ib_spec on the stack
Date:   Thu,  7 May 2020 10:26:37 -0400
Message-Id: <20200507142726.25751-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit c08cfb2d8d78bfe81b37cc6ba84f0875bddd0d5c ]

Initialize ib_spec on the stack before using it, otherwise we will have
garbage values that will break creating default rules with invalid parsing
error.

Fixes: a37a1a428431 ("IB/mlx4: Add mechanism to support flow steering over IB links")
Link: https://lore.kernel.org/r/20200413132235.930642-1-leon@kernel.org
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2f5d9b181848b..e5758eb0b7d27 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1502,8 +1502,9 @@ static int __mlx4_ib_create_default_rules(
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pdefault_rules->rules_create_list); i++) {
+		union ib_flow_spec ib_spec = {};
 		int ret;
-		union ib_flow_spec ib_spec;
+
 		switch (pdefault_rules->rules_create_list[i]) {
 		case 0:
 			/* no rule */
-- 
2.20.1

