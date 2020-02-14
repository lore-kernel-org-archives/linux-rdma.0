Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D03C2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58BC20873
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581703071;
	bh=4Wa/QB+IckNJ0b9xJIugVaiu2lf8uvi1J/olPIqS1SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sQ3ozmxwb3YvagqvakGdhERJ53gq2tMh0Vsr9qYWUT6ck3GkEDbHjPwwS/NtHiqI2
	 uAtyx/CdzASAjYW09ed3MvFCMkbM5mvEYqIbU/VuF+WIrfvlguVj+J3/MT1n7swBIC
	 DvO72DYaQ4d1Gh7w8dRaTQuA4KRlqMXaAqpqNhiQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387961AbgBNR5k (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388193AbgBNP5V (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEEF524654;
        Fri, 14 Feb 2020 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695840;
        bh=4Wa/QB+IckNJ0b9xJIugVaiu2lf8uvi1J/olPIqS1SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWn95NDHP4a33SIHib/6sFQ0VfLN1FUAHl9a7pRz1tVxz6v7eDAXLSZQM9NqyqIC/
         1ya4uZnMpf3uByLWAsOUzlSGEGZwOJjq2sn36EfbqtNC3G3pfFxRA244SVdRs8YJjf
         n8cPMSNQGuGjlMwgApyWoTSHVfpCCstjZ7bPldyY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 391/542] RDMA/uverbs: Verify MR access flags
Date:   Fri, 14 Feb 2020 10:46:23 -0500
Message-Id: <20200214154854.6746-391-sashal@kernel.org>
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
index cb02d36d41d22..a14f837fb1c84 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4303,6 +4303,9 @@ static inline int ib_check_mr_access(int flags)
 	    !(flags & IB_ACCESS_LOCAL_WRITE))
 		return -EINVAL;
 
+	if (flags & ~IB_ACCESS_SUPPORTED)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.20.1

