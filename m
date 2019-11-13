Return-Path: <SRS0=Aeev=ZF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E67BC17440
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Nov 2019 02:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F265222D0
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Nov 2019 02:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573611851;
	bh=0fCyDe2XJ+/YJ9Rha8IJWPEjZCdyHlAaygACeS00hbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SHeSoCrUNkDq4p6tpmBDe0QCkesEkpCI4Ofk5AYFVRMAoOwqzUhSwTJOdXS73h5gc
	 BzyOUcBFmuvHw2v5BF9exxPYDO5ztkemUKRr+XMNN3TiQMrxwq1+o5noJIB2nr3Q6o
	 hE9uXjZ9Njt3yfIkr7d2hJc66JCZtH8DkLbDnIC8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbfKMCYD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbfKMBwK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22AD72245D;
        Wed, 13 Nov 2019 01:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609929;
        bh=0fCyDe2XJ+/YJ9Rha8IJWPEjZCdyHlAaygACeS00hbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RurpCokUzEofHBJQTJaxf3kixp7GAKhqa1bNNOCiYhCRO56EXUxMKO/3kg/Gt8n+o
         aLRW2Eit5iOsPQDoeWFJvaOBivMsNOJUkN3vPMgr2SeEHwit53IQ9qZZD0rZoHtCqU
         tG2FJeG3FFOp57hr23LuRtPrSFymH/a55CsyDx+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/209] RDMA/hns: Bugfix for CM test
Date:   Tue, 12 Nov 2019 20:48:11 -0500
Message-Id: <20191113015025.9685-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 15fc056fba7b17b9abfbe80a12f188403fc949fb ]

It will print the warning when the MSB bit of SLID is not zero running
cm_req_handler function that test CM. It needs to fixed zero when test
RoCE device.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ce44a90d2bd3e..b5150d7b953bd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2268,6 +2268,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		wc->src_qp = (u8)roce_get_field(cqe->byte_32,
 						V2_CQE_BYTE_32_RMT_QPN_M,
 						V2_CQE_BYTE_32_RMT_QPN_S);
+		wc->slid = 0;
 		wc->wc_flags |= (roce_get_bit(cqe->byte_32,
 					      V2_CQE_BYTE_32_GRH_S) ?
 					      IB_WC_GRH : 0);
-- 
2.20.1

