Return-Path: <SRS0=aLju=C3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32687C43465
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E045920771
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397451;
	bh=gQj01qDyAwAaQcwZQ5/a6f6D4fUtuinq65dyj/G7YxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Tf8ifNjP/59v7rSUktTs8hdyhg+VRQ0aqksLsBvkAr00jzkyaS9IfMQvAMthQnlcq
	 jcALwphHaOAl+WtRqhbBq2zTtXhVq90Q1RE+Br3H3l5fDH4h2CB7KoR9smC/DvkiCA
	 FG+g/f4B60yX8xFJytFiFl3RQgJSRNbUTzH7Bm6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgIRCup (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgIRCIh (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806E22388E;
        Fri, 18 Sep 2020 02:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394917;
        bh=gQj01qDyAwAaQcwZQ5/a6f6D4fUtuinq65dyj/G7YxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxBsT2pTO9Nj1fscHyXmcgLjcax8xaX1oaumf0ikXXdjO7FVqwhjM9n9SThDxgQhC
         93Q8pMX/wH7XDVAI6GHrasrRq3BELVKhyLiClATIyi2fLTkZwRsPDxV7uRI1tvRhow
         fy1/FyK/gk/1vyOsvoFHbNub7RIHe7PGetscqwoE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 029/206] RDMA/i40iw: Fix potential use after free
Date:   Thu, 17 Sep 2020 22:05:05 -0400
Message-Id: <20200918020802.2065198-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit da046d5f895fca18d63b15ac8faebd5bf784e23a ]

Release variable dst after logging dst->error to avoid possible use after
free.

Link: https://lore.kernel.org/r/1573022651-37171-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 4321b9e3dbb4b..0273d0404e740 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2071,9 +2071,9 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 	dst = i40iw_get_dst_ipv6(&src_addr, &dst_addr);
 	if (!dst || dst->error) {
 		if (dst) {
-			dst_release(dst);
 			i40iw_pr_err("ip6_route_output returned dst->error = %d\n",
 				     dst->error);
+			dst_release(dst);
 		}
 		return rc;
 	}
-- 
2.25.1

