Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8732C2D0F9
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 09:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13CB20769
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 09:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589363461;
	bh=sca3rWAhFzenaiyT5wR727McPP6gfJb62ZWaYzqpjc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iCeKdi6xymB6dEWgVSdbseDgv8nVCHDOalRJ7Z87xwC0rmNNezmNduynvFYT4fFDZ
	 ErtAktOF6oqDJONhjqAePIoVv8sQ3lUJah7cfXJoBoKqnLW3DLX5trNTkqGZsgi7qu
	 izW7Cf2TcSPlzU7Hz18Oe7DYZ4sj2A6umPRbQ03M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387579AbgEMJu7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 05:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387576AbgEMJu6 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 05:50:58 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B130B23128;
        Wed, 13 May 2020 09:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363458;
        bh=sca3rWAhFzenaiyT5wR727McPP6gfJb62ZWaYzqpjc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGA6xLeXLsonLg3+xS2/l44XV0rdO1u9fQGrhTOglFtdPGvaYOLtQWWV18K/j5NNr
         VDUDTkucF2Dj91qEaGTRToXrKOckypDyZlcdEOMzBe9Dkeb+vJrOJhxSdrL1D1RDFR
         iHRDvXuBGeaF9S4188ohN/RZowXGodyw07KDYRWI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 03/14] RDMA/core: Fix double put of resource
Date:   Wed, 13 May 2020 12:50:23 +0300
Message-Id: <20200513095034.208385-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513095034.208385-1-leon@kernel.org>
References: <20200513095034.208385-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Avoid decrease reference count of resource tracker object in the error
flow of res_get_common_doit.

Fixes: c5dfe0ea6ffa ("RDMA/nldev: Add resource tracker doit callback")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 9eec26d10d7b..e16105be2eb2 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1292,11 +1292,10 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	has_cap_net_admin = netlink_capable(skb, CAP_NET_ADMIN);
 
 	ret = fill_func(msg, has_cap_net_admin, res, port);
-
-	rdma_restrack_put(res);
 	if (ret)
 		goto err_free;
 
+	rdma_restrack_put(res);
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
-- 
2.26.2

