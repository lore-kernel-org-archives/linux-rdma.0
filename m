Return-Path: <SRS0=Ta2D=3F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A67BC33CB3
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 17:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59799246BA
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579196167;
	bh=ylVJds/P9o73SzI4s7sAWE/o6yIInOgsdjpWigBNx3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m4/wqvWoRDb0wJ6BbQCv1hDecVw2OjN+TdNkGsEeyOaM/9+Cglrnscv4VlaLSzE+K
	 UMZseL3R5GPKb11s4JLiz+YDx56rJlx/gsPdFGtWVifT0ov7UgmfY6HNNDxkJlPkZA
	 LvYmir4XmWGn+nyO0lIeM3ly1fyMbV0ZfDnVyjw8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405151AbgAPRfe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405145AbgAPRfe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Jan 2020 12:35:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3858F246A9;
        Thu, 16 Jan 2020 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196133;
        bh=ylVJds/P9o73SzI4s7sAWE/o6yIInOgsdjpWigBNx3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hL5MsKMiGF8bjnQWkENdaw+hR2biPfFQ+nHesPPaTVM+gvqaAS/qtjpJU0zJhTxuS
         OiuKePPXv9RkyyvnK8mv1GOeRejhWqaBAHpv8JHkZ5b+Cl2w53Yq6cBn3GybnRt9gz
         //Iv3f8TBATIuC2pklhHLGT/yLdH2j/IFrz1bIHY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 036/251] IB/usnic: Fix out of bounds index check in query pkey
Date:   Thu, 16 Jan 2020 12:31:10 -0500
Message-Id: <20200116173445.21385-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit 4959d5da5737dd804255c75b8cea0a2929ce279a ]

The pkey table size is one element, index should be tested for > 0 instead
of > 1.

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
Signed-off-by: Gal Pressman <galpress@amazon.com>
Acked-by: Parvi Kaustubhi <pkaustub@cisco.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index a5bfbba6bbac..cacb720f44a0 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -425,7 +425,7 @@ int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 				u16 *pkey)
 {
-	if (index > 1)
+	if (index > 0)
 		return -EINVAL;
 
 	*pkey = 0xffff;
-- 
2.20.1

