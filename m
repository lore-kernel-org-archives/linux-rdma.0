Return-Path: <SRS0=q+lP=53=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94019C2BA19
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6442F206E9
	for <linux-rdma@archiver.kernel.org>; Sat, 11 Apr 2020 23:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648000;
	bh=FTpG7R38HuM8STl+pDNu6+MFbXvI8frBuqk3VjG0Vzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rei81evfAkO7fVvNePbelv+9BbAGJX5vCUJG/ZyT61uVvVFDfaTW3o4LtHK0dZKYU
	 Bp4l3f9V6/4f2hBV0aJm/uhq4ziZoX5uFOu5LGm23lIYlTSeSGR2XakVpZL+iu+XR1
	 QgyWUPHsDRL2oee+aEqhwikpn4r/uMZ8nojYn1Xk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgDKXdO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbgDKXJu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7EBD20787;
        Sat, 11 Apr 2020 23:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646590;
        bh=FTpG7R38HuM8STl+pDNu6+MFbXvI8frBuqk3VjG0Vzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vz5S6euZM40a/wHniaF0/PHAzC9OjAs3S4Jxj5R461YCBLMJ+Bf5s1lms6LDLnug5
         wCLRWdYfj/BjCdHTu8pUF9elJG7caJSWBmpjLfTVwvekEWrnm2Cu0NDEhKertG0IpF
         K5GANC7UJqGB4EP0kHTIheYOvXGtSELBXUt4gI88=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 005/108] RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices
Date:   Sat, 11 Apr 2020 19:08:00 -0400
Message-Id: <20200411230943.24951-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
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
index a8c11b5e1e943..a92aca1745c16 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -116,6 +116,8 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 	rxe->attr.max_fast_reg_page_list_len	= RXE_MAX_FMR_PAGE_LIST_LEN;
 	rxe->attr.max_pkeys			= RXE_MAX_PKEYS;
 	rxe->attr.local_ca_ack_delay		= RXE_LOCAL_CA_ACK_DELAY;
+	addrconf_addr_eui48((unsigned char *)&rxe->attr.sys_image_guid,
+			rxe->ndev->dev_addr);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
 }
-- 
2.20.1

