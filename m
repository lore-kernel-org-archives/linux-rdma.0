Return-Path: <SRS0=2Aje=6V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C93C38A24
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 14:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE6C12073A
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588862044;
	bh=bBX5vsv5Qb1hWqXDmtdgS4cIpPpDSzw4sadAlQDqz0k=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Ih1r8yuiekqddZMy5CJUsH/fuCYjdiVrY2Atj+G8qNllarZlzILnSlyJDBg9MrXoH
	 T6nZTdg8BXRNOZ4kZKzkOuiabOSc0XxcjtGOD7hQzsSFFE+4fjeCJ7lC/yUTxVp/+/
	 xIlqwVUr/Q8HBZhG9cqKDrfhqMutbJrqXHaDx9J4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgEGO3Y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 10:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgEGO3T (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 7 May 2020 10:29:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32ADE2073A;
        Thu,  7 May 2020 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861759;
        bh=bBX5vsv5Qb1hWqXDmtdgS4cIpPpDSzw4sadAlQDqz0k=;
        h=From:To:Cc:Subject:Date:From;
        b=lJWHcn5ki5a4z885DFOvuCX/IT4hvT6trodNx1GXhA0VvAddmzaq6pOIvaaC3WoLK
         e7Ac4+bLd63VS3uyxYgXeTnKF7zl/uSDfh5ZHxvS6maXhh3qgeSHWOkN8qs893Uomq
         UCWAVtjqn3hip1hJIo+hOyJCv8QIcRmDnkUbZVjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Hleihel <alaa@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/20] RDMA/mlx4: Initialize ib_spec on the stack
Date:   Thu,  7 May 2020 10:28:57 -0400
Message-Id: <20200507142917.26612-1-sashal@kernel.org>
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
index a19d3ad14dc37..eac4ade456119 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1606,8 +1606,9 @@ static int __mlx4_ib_create_default_rules(
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

