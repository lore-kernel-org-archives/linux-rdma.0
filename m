Return-Path: <SRS0=aLju=C3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08898C43466
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A2323770
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600396391;
	bh=pEocZdUoVNcT48AhOZV2wN7OAEKpeFRTRBWqmsjCs7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KZMNVAGhbwjbCanmlYU8KnXj0f53EqVZ94UU/P+/WLEdPESQFgX2iL9FDlIe1z/ds
	 4cht7NuSQ1tIIEOXaqBSQhVQpywwpkIp63XQeQJ1m96GGpK9CWJ4aoIOXbE1Y1G+M2
	 1aau6kig89mBGok8X1/U8YxVBs8CdMwfXvJi860w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgIRCdK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgIRCNu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9D5235F7;
        Fri, 18 Sep 2020 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395230;
        bh=pEocZdUoVNcT48AhOZV2wN7OAEKpeFRTRBWqmsjCs7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3O3AhSPRgHeYdFAAojEwsF/Wm4/4NMMJeSYOiylF25KXhftnwzPsLXxH15WTb29P
         iOVk1/LviZVcu+Jhz63dML/U2stuWYpAsTGTn+boYsgCu8UsP/jc2P+PZpMIVj7OhG
         H6x7Sm/dQ0Sf2EsWx5bWO308W6eyFOa3AjWMFr28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 075/127] RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices
Date:   Thu, 17 Sep 2020 22:11:28 -0400
Message-Id: <20200918021220.2066485-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

[ Upstream commit d0ca2c35dd15a3d989955caec02beea02f735ee6 ]

The RXE driver doesn't set sys_image_guid and user space applications see
zeros. This causes to pyverbs tests to fail with the following traceback,
because the IBTA spec requires to have valid sys_image_guid.

 Traceback (most recent call last):
   File "./tests/test_device.py", line 51, in test_query_device
     self.verify_device_attr(attr)
   File "./tests/test_device.py", line 74, in verify_device_attr
     assert attr.sys_image_guid != 0

In order to fix it, set sys_image_guid to be equal to node_guid.

Before:
 5: rxe0: ... node_guid 5054:00ff:feaa:5363 sys_image_guid
 0000:0000:0000:0000

After:
 5: rxe0: ... node_guid 5054:00ff:feaa:5363 sys_image_guid
 5054:00ff:feaa:5363

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200323112800.1444784-1-leon@kernel.org
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 8c3d30b3092d4..2c9e616cfe0e8 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -126,6 +126,8 @@ static int rxe_init_device_param(struct rxe_dev *rxe)
 	rxe->attr.max_fast_reg_page_list_len	= RXE_MAX_FMR_PAGE_LIST_LEN;
 	rxe->attr.max_pkeys			= RXE_MAX_PKEYS;
 	rxe->attr.local_ca_ack_delay		= RXE_LOCAL_CA_ACK_DELAY;
+	addrconf_addr_eui48((unsigned char *)&rxe->attr.sys_image_guid,
+			rxe->ndev->dev_addr);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
 
-- 
2.25.1

