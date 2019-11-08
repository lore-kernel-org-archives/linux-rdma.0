Return-Path: <SRS0=fYhk=ZA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630B5C5DF60
	for <linux-rdma@archiver.kernel.org>; Fri,  8 Nov 2019 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AC412084D
	for <linux-rdma@archiver.kernel.org>; Fri,  8 Nov 2019 11:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214372;
	bh=5y7jySM1EY7FEWm+rSzD2iseCEIB0/ban7fS0k4+TEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ay9OjtZOXI5qRN+IYN6CKXe+RnWnf7Ue/o2esxiwU1gvreOPsbmN7sa9/cXeFLuj+
	 HzxBfjxBwYfiYLPeXwBCCx9f6fC6KwFivAqCDAhvpZdT5G2LJ6pDilqOGAi7K/E21y
	 RapNzOdp8GGc+069rIDNUQ2pS+6amuUpRB0seAOg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbfKHL71 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389081AbfKHLoM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5FDF21D82;
        Fri,  8 Nov 2019 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213451;
        bh=5y7jySM1EY7FEWm+rSzD2iseCEIB0/ban7fS0k4+TEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xB5ZKhuEwLL3DvBsRxoo7BG7So4ogzWgNAd/1nvlmBepbMEsmy85UeJ6/rT7zR0Or
         aq4e7TPHLk8Q1hpBKQCECp5/wgkL815betMAZbXnk+QhKrIVtYS4t2dpz+I7cPPGk/
         dOeH0jgDa4HbxfZGudeiGcw09kJUNl9xaosq0Q00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muhammad Sammar <muhammads@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 043/103] IB/ipoib: Ensure that MTU isn't less than minimum permitted
Date:   Fri,  8 Nov 2019 06:42:08 -0500
Message-Id: <20191108114310.14363-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Muhammad Sammar <muhammads@mellanox.com>

[ Upstream commit 142a9c287613560edf5a03c8d142c8b6ebc1995b ]

It is illegal to change MTU to a value lower than the minimum MTU
stated in ethernet spec. In addition to that we need to add 4 bytes
for encapsulation header (IPOIB_ENCAP_LEN).

Before "ifconfig ib0 mtu 0" command, succeeds while it obviously shouldn't.

Signed-off-by: Muhammad Sammar <muhammads@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1a93d3d58c8a4..caae4bfab950d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -249,7 +249,8 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 		return 0;
 	}
 
-	if (new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
+	if (new_mtu < (ETH_MIN_MTU + IPOIB_ENCAP_LEN) ||
+	    new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
 		return -EINVAL;
 
 	priv->admin_mtu = new_mtu;
-- 
2.20.1

