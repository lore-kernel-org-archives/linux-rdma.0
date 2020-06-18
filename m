Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D53C433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 01:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB97122247
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 01:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592445520;
	bh=I6xtW/C29jKr+Sxh28IcwGqum2+CjTHubDmIj/WsSI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=T6awsyZSbCdyBi1Zk+EmRa1pwHyA6W9+u0H+fa9Ge+iylZNLeZ05VpVF74a3aVgTy
	 b8j8TRQQEnUEPzVwlfimCONyqTb/30/2Z1jj1f/zLaSbiRtlh+mbEvrtUgIiZL8O3H
	 PbUHApcuwxz+dj+G2ltS8MatW8s//0n3yI4uxby4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgFRB6i (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbgFRBYt (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:24:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAFBB21927;
        Thu, 18 Jun 2020 01:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443489;
        bh=I6xtW/C29jKr+Sxh28IcwGqum2+CjTHubDmIj/WsSI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZB0ypnytsOEQyofV6448IC1CaH3QYybRZS6K2uEre+xdSW1geaQK9ucRqCBvhlTAD
         cNS8i5yeaFux2z/47V629b3TRZCdeBeYNEG/8HMZSz0C4pME8Te7AzwpsUH2eyJJCq
         fhSj2XcujHnOVoBg8PT6W+ketoknRehVeZepcSbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 117/172] RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove
Date:   Wed, 17 Jun 2020 21:21:23 -0400
Message-Id: <20200618012218.607130-117-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 49ea0c036ede81f126f1a9389d377999fdf5c5a1 ]

Remove device specific debugfs entries immediately if LLD detaches a
particular ULD device in case of fatal PCI errors.

Link: https://lore.kernel.org/r/20200524190814.17599-1-bharat@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index c13c0ba30f63..af974a257086 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -945,6 +945,7 @@ void c4iw_dealloc(struct uld_ctx *ctx)
 static void c4iw_remove(struct uld_ctx *ctx)
 {
 	pr_debug("c4iw_dev %p\n", ctx->dev);
+	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_unregister_device(ctx->dev);
 	c4iw_dealloc(ctx);
 }
-- 
2.25.1

