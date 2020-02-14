Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD5FC2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D2D520656
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581699850;
	bh=e44IC8GFuV3boKQtWCZUBvuFPlOG/mEAYoki+2zkLxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SrgjH8c2YkpiOPV/8/Q7uPMSZK/Pex/DwJoamJIjdWUKYEGN8RzTPUBAX2YXplW+C
	 +vJdcV4CH/K00eWjSmAyUvxbD8BibdA3nTvr67V18zIfl5vgh2yQEZQUVFqP4EcO13
	 PHNY7IpcNKopceziS7S3a+tt+I5hAHvV0z8KpVH8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392482AbgBNQPl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392479AbgBNQPk (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 803DF246F1;
        Fri, 14 Feb 2020 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696940;
        bh=e44IC8GFuV3boKQtWCZUBvuFPlOG/mEAYoki+2zkLxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rqiu4pTaGT2IdRwS3aoZKb6EsR5I68rlCytQ4bj+CVT0awi6WoWBdgy/IzfL7gG/n
         qwfz5jvU6NUddYNEVq/gNlNTL9Jvyy0H2TgRovlVpZ3dUsJkKla8sH/PfBMmcVow4g
         x9prwCTAPaxvh8pBbwEkSXyG+M5ajqNdHOr5e3F0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 183/252] RDMA/uverbs: Verify MR access flags
Date:   Fri, 14 Feb 2020 11:10:38 -0500
Message-Id: <20200214161147.15842-183-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

[ Upstream commit ca95c1411198c2d87217c19d44571052cdc94725 ]

Verify that MR access flags that are passed from user are all supported
ones, otherwise an error is returned.

Fixes: 4fca03778351 ("IB/uverbs: Move ib_access_flags and ib_read_counters_flags to uapi")
Link: https://lore.kernel.org/r/1578506740-22188-6-git-send-email-yishaih@mellanox.com
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_verbs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 54e4d1fd21f8f..874cd6e94093b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3864,6 +3864,9 @@ static inline int ib_check_mr_access(int flags)
 	    !(flags & IB_ACCESS_LOCAL_WRITE))
 		return -EINVAL;
 
+	if (flags & ~IB_ACCESS_SUPPORTED)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.20.1

