Return-Path: <SRS0=Ta2D=3F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FF1C33CAF
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 18:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03C220730
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198801;
	bh=SohZIyWFWMTpPw87zHrJTPxC3ujInMULYFxaLiydzbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=y3GEHT5q955NqTLGUW5RJoLh2JCuG7IRzPo4iubiZKGYmHYYdkn0ZrdQ4CqmLwqEf
	 Ve40UZtvSrQU7bQM2k1anZRKh0IvhXr/F/JsDworLVMzcpoRSCZi1wiz3JQzE/6d8u
	 fr5IfgDKA2RoVltvGlVvx7fj/QxhqC3Ww1hs7Y8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404181AbgAPR2T (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404173AbgAPR2R (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF16C246E4;
        Thu, 16 Jan 2020 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195696;
        bh=SohZIyWFWMTpPw87zHrJTPxC3ujInMULYFxaLiydzbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqOWkxtrZE7Hp8n/QSU/9gPmq4C7i2aujhFRPEi/LKejwRGAMPV2/Swa95cdP3xs6
         1tqE7YZGyRDb6MP8+vfPkr1DSqJGsZC/TOdT79XjeHY9g28/lIZOkcInxka1q3VLfN
         VOfwDtWyM3R1FBXshubiDYs4GdBOXjy0s4g33ktQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xi Wang <wangxi11@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 246/371] RDMA/hns: Fixs hw access invalid dma memory error
Date:   Thu, 16 Jan 2020 12:21:58 -0500
Message-Id: <20200116172403.18149-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit ec5bc2cc69b4fc494e04d10fc5226f6f9cf67c56 ]

When smmu is enable, if execute the perftest command and then use 'kill
-9' to exit, follow this operation repeatedly, the kernel will have a high
probability to print the following smmu event:

  arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00007d0000000010
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000020900000080
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000f47cf000
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000f47cf000

This is because the hw will periodically refresh the qpc cache until the
next reset.

This patch fixed it by removing the action that release qpc memory in the
'hns_roce_qp_free' function.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 3a37d26889df..281e9987ffc8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -241,7 +241,6 @@ void hns_roce_qp_free(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 
 	if ((hr_qp->ibqp.qp_type) != IB_QPT_GSI) {
 		hns_roce_table_put(hr_dev, &qp_table->irrl_table, hr_qp->qpn);
-		hns_roce_table_put(hr_dev, &qp_table->qp_table, hr_qp->qpn);
 	}
 }
 
-- 
2.20.1

