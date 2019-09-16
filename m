Return-Path: <SRS0=TGoC=XL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2285EC4CEC7
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 07:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFAAE214D9
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568617929;
	bh=GWvqmCyeZJZ2w++/99BcZaKWWS6gtv57aOqzrg0OR3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xPGGuxLNnbgycFsjkxPrnFuNeGrgvuRMtw7BvG5IkE7MWB0NZv7EaktslGKxSGueQ
	 jeZA86WWDReLkQ/vpBzBqT7UhZjlLxvXxhn1sJN044DIqusvaxxiTyIwkt8vNkXhdN
	 aBc6FLs3+tePlwHFAVqeQ/YABvdVLjU43jWUJ6iU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfIPHMI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Sep 2019 03:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfIPHMI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 16 Sep 2019 03:12:08 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA322067D;
        Mon, 16 Sep 2019 07:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568617927;
        bh=GWvqmCyeZJZ2w++/99BcZaKWWS6gtv57aOqzrg0OR3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rz5XS9o8Jqb6Rqqh0yTyblIpMZW9JaTS2cMUDG8JPMa9Q//gjaOcdG88Ku+ZDxpMj
         Luk2DI+UeQ0FANjXpxQinKysVCT7yitniFqTnSFpw2Aiiw7tkPKBNAj2L80VqSqYmK
         ZXseZRJO17tb93mSEd09FKXrm9RCiarDjSodvon4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH 3/4] RDMA/nldev: Reshuffle the code to avoid need to rebind QP in error path
Date:   Mon, 16 Sep 2019 10:11:53 +0300
Message-Id: <20190916071154.20383-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916071154.20383-1-leon@kernel.org>
References: <20190916071154.20383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Properly unwind QP counter rebinding in case of failure.

Fixes: b389327df905 ("RDMA/nldev: Allow counter manual mode configration through RDMA netlink")
Reviewed-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5e2b7eb0761b..6eb14481a72e 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1860,24 +1860,22 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,

 	cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
 	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
-	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
-	if (ret)
-		goto err_unbind;
-
 	if (fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
 		ret = -EMSGSIZE;
-		goto err_fill;
+		goto err_unbind;
 	}

+	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
+	if (ret)
+		goto err_unbind;
+
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);

-err_fill:
-	rdma_counter_bind_qpn(device, port, qpn, cntn);
 err_unbind:
 	nlmsg_free(msg);
 err:
--
2.20.1

