Return-Path: <SRS0=aLju=C3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB01C43464
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90EC02078B
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397466;
	bh=Jrjz1w+nRAnz2QLcyTOmt09nTzFZzNmf2WOi96S4Bjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=O9qKz4NvJ61T3bauu4uZlAXU3IAN1ykCsNelauQuwhF0ZBeTUeBUHvdg/ykq2O6cW
	 yWyRg9U56LMyJAIx1cMQT7SeJZDQ135KRHUFYV7ewIwA5FIJ5EplMb+M4x6glP8L0y
	 QI+BHE70THn1mLtbKze+Brn83duBsIn46SFuhnuU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgIRCux (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgIRCIg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649202399C;
        Fri, 18 Sep 2020 02:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394916;
        bh=Jrjz1w+nRAnz2QLcyTOmt09nTzFZzNmf2WOi96S4Bjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF7rMuqOHtcrV+HVzL4G9hCKduSl5VBcACGIBNoqRjI1qVs18MswXtdY4pb2rUAD8
         WdYgBHf3zv66zMKdgh89ed8O4rsnPwLMFHvkYsrnOb4iCgET1coKQeOpPLGzctvchk
         /CPVhwsNIqhLjE495otpO+uOVnPVa+TXJ6Rdv8RI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 028/206] RDMA/qedr: Fix potential use after free
Date:   Thu, 17 Sep 2020 22:05:04 -0400
Message-Id: <20200918020802.2065198-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 960657b732e1ce21b07be5ab48a7ad3913d72ba4 ]

Move the release operation after error log to avoid possible use after
free.

Link: https://lore.kernel.org/r/1573021434-18768-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 2566715773675..e908dfbaa1378 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -460,10 +460,10 @@ qedr_addr6_resolve(struct qedr_dev *dev,
 
 	if ((!dst) || dst->error) {
 		if (dst) {
-			dst_release(dst);
 			DP_ERR(dev,
 			       "ip6_route_output returned dst->error = %d\n",
 			       dst->error);
+			dst_release(dst);
 		}
 		return -EINVAL;
 	}
-- 
2.25.1

