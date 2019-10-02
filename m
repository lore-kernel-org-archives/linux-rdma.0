Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E50C35280
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 11:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BB9021929
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 11:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570017394;
	bh=x3b8HXOm0lUQb7btwLDXxfUwLlrxHpyHCm2+n9hFG9s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=CEsxEuDxjHDX0CQ4Exg+jThFAcHNuC8Rboq67HZmZ+q5Ny7ggSfJ7dDvTuF9LnlOs
	 9OwtUEey34F535CkqCmpuW+zndqcyn5r6TPCivhSsU99X2nvSgEOdiWNAVuG0I5Do7
	 KloW+ohb+ipP3p4TAXGO2GcZTz8HMGezahiWtQJY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfJBL4d (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 07:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfJBL4d (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Oct 2019 07:56:33 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F2422133F;
        Wed,  2 Oct 2019 11:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570017392;
        bh=x3b8HXOm0lUQb7btwLDXxfUwLlrxHpyHCm2+n9hFG9s=;
        h=From:To:Cc:Subject:Date:From;
        b=Wmp1ngpUa++X6mo3xSanlafL4qNHowlUHUmGcFL9gPGSl21y1t/6gsJprmKQf9RdP
         OJ/Z1MxIRWXJnvfeq0X5uFIB0Y8Jb+rR3m9xAyBZTLNpuICnA052BJ/viRKXdkfqkB
         rXAOqtfvrE0i4BFlYzdY09sNe/I4Mr0uhO48eUuE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH rdma-rc v1] RDMA/nldev: Reshuffle the code to avoid need to rebind QP in error path
Date:   Wed,  2 Oct 2019 14:56:27 +0300
Message-Id: <20191002115627.16740-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
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
 Changelog v0->v1: https://lore.kernel.org/linux-rdma/20190916071154.20383-4-leon@kernel.org
 * Used different goto label.
---
 drivers/infiniband/core/nldev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 7a7474000100..068ac0719ca5 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1787,10 +1787,6 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,

 	cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
 	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
-	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
-	if (ret)
-		goto err_unbind;
-
 	if (fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
@@ -1799,13 +1795,15 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err_fill;
 	}

+	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
+	if (ret)
+		goto err_fill;
+
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);

 err_fill:
-	rdma_counter_bind_qpn(device, port, qpn, cntn);
-err_unbind:
 	nlmsg_free(msg);
 err:
 	ib_device_put(device);
--
2.20.1

