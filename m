Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AD9C2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06E1820848
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581703523;
	bh=mHCqROaKJ7SzNg5MXZjS44KD2tpZdsshpaEXfJi5wlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WlO+bA8tx1RXoMRxqqJ2MZLvhLt7cVKgXav0dIde9Utxg3GSPMSFh3oHr2kYLVdgt
	 nS7u7RZhisFAW4d4vMaxXm4N8jZ8t3/joFoZAs2soVia90Df1o0yRDbhn2tB2bJwro
	 GB6EqLij0CvCdXgGJiqUVITwRzXhrz4iFCfoDOLw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbgBNPzS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731731AbgBNPzS (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6EBA24684;
        Fri, 14 Feb 2020 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695717;
        bh=mHCqROaKJ7SzNg5MXZjS44KD2tpZdsshpaEXfJi5wlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAslCNFzmbg7v/jqHu+YLQQpsFYLj4NJffFj1w+sZwYDNT6esyXbwV4fzfkl+yquJ
         h8igydmTQqH8L9mGTo34AaAsT1f7GWzEjBVBQDtydPE5hSlyXR+KDJKCv8SkqVWWyy
         IbvnxRV8mxySrTg7hV2/RtbCtypAXGPUmAmuCvDE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 295/542] RDMA/hns: Avoid printing address of mtt page
Date:   Fri, 14 Feb 2020 10:44:47 -0500
Message-Id: <20200214154854.6746-295-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit eca44507c3e908b7362696a4d6a11d90371334c6 ]

Address of a page shouldn't be printed in case of security issues.

Link: https://lore.kernel.org/r/1578313276-29080-2-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 9ad19170c3f97..95765560c1cfb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -1064,8 +1064,8 @@ int hns_roce_ib_umem_write_mtt(struct hns_roce_dev *hr_dev,
 		if (!(npage % (1 << (mtt->page_shift - PAGE_SHIFT)))) {
 			if (page_addr & ((1 << mtt->page_shift) - 1)) {
 				dev_err(dev,
-					"page_addr 0x%llx is not page_shift %d alignment!\n",
-					page_addr, mtt->page_shift);
+					"page_addr is not page_shift %d alignment!\n",
+					mtt->page_shift);
 				ret = -EINVAL;
 				goto out;
 			}
-- 
2.20.1

