Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F39BC4332E
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Mar 2021 17:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4827464F2F
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Mar 2021 17:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351522AbhCBRFJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Mar 2021 12:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376804AbhCBH5c (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 2 Mar 2021 02:57:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E867C64D74;
        Tue,  2 Mar 2021 07:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614670943;
        bh=Sj3t8PWAHUIXJukhWVhODTADibSIRqXDU8iycU0raZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7NcM/F2xy/ZRXnh2jMdH/HUE40g/1gNZ02Bi573FhDO4ax91GXmVN8iyp+PJzJ3f
         NSZasxRtnGj8FRCEZE0bWdC2bW/FHp0kOKop1ykZhP3icXrvfMbD1ijMKmg3tkBsy5
         3XvPWs9xvG1i8YZUDueRq/+7zhPyjH1br+XqRF7FKWIYTtsfx1E+dlpnU3P1lzFVRu
         So18lnSyk4i9pcx/w3MrVAcO7bWwoucM8De4fMKfxYw1NcnLh9gccIfn90yTrHS2iI
         vBXo02YJOWRdVwDO1l4UOdbSrQwO/rodV3jnJOVkvUNj6CLLf8CPM8cLeADJK4idTz
         6P0d47FxUjfZg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH rdma-rc 2/2] RDMA/uverbs: Fix kernel-doc warning of _uverbs_alloc
Date:   Tue,  2 Mar 2021 09:42:14 +0200
Message-Id: <20210302074214.1054299-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210302074214.1054299-1-leon@kernel.org>
References: <20210302074214.1054299-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the following W=1 compilation warning:
drivers/infiniband/core/uverbs_ioctl.c:108: warning: expecting prototype for uverbs_alloc(). Prototype was for _uverbs_alloc() instead

Fixes: 461bb2eee4e1 ("IB/uverbs: Add a simple allocator to uverbs_attr_bundle")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/uverbs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index e47c5949013f..3871049a48f7 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -90,8 +90,8 @@ void uapi_compute_bundle_size(struct uverbs_api_ioctl_method *method_elm,
 	WARN_ON_ONCE(method_elm->bundle_size > PAGE_SIZE);
 }

-/**
- * uverbs_alloc() - Quickly allocate memory for use with a bundle
+/*
+ * _uverbs_alloc() - Quickly allocate memory for use with a bundle
  * @bundle: The bundle
  * @size: Number of bytes to allocate
  * @flags: Allocator flags
--
2.29.2

