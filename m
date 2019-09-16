Return-Path: <SRS0=TGoC=XL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDB0C49ED7
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 07:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 686AE214AF
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 07:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568617932;
	bh=p7wbeqmXqC0Qjyn6d4/0x3bJ5jEUrnDeGfHVQipBIlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tMUmSk2n7p3bIfPmPbsaMu4wszCWK4e5foWCfOxyDHija9QflzX2zhJ7lyfYiqRzB
	 9ykKQ3X411/djYfRBopSnrNuv9dZGVFRxn8C/zlOTqwysjggBsbmszEQ027nC0/o7M
	 cWo3rnNRd7TW1BZrkU8DdPZMKW+TyTmTzZKD77I8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfIPHML (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Sep 2019 03:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfIPHML (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 16 Sep 2019 03:12:11 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFCC2067D;
        Mon, 16 Sep 2019 07:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568617931;
        bh=p7wbeqmXqC0Qjyn6d4/0x3bJ5jEUrnDeGfHVQipBIlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpeI30rYUUliDZ7W9roidB0Zup1QNz7uEbOSMjN6Gk4PXLeZWfWEdSV5VL9twzXI3
         em+wb9yyS55BNInMJJTKXAv6+xUO5PBho8gQhRgvp8hGWNGOje0sJkB//wLfLMqC1k
         EXqk6WOLfIg4lSU0aXNsXQnRBQpljxREEjyPFHdQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH 4/4] RDMA: Fix double-free in srq creation error flow
Date:   Mon, 16 Sep 2019 10:11:54 +0300
Message-Id: <20190916071154.20383-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916071154.20383-1-leon@kernel.org>
References: <20190916071154.20383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

The cited commit introduced a double-free of the srq buffer
in the error flow of procedure __uverbs_create_xsrq().

The problem is that procedure ib_destroy_srq_user() called
in the error flow also frees the srq buffer.

Thus, if uverbs_response() fails in __uverbs_create_srq(),
the srq buffer will be freed twice.

Fixes: 68e326dea1db ("RDMA: Handle SRQ allocations by IB/core")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8f4fd4fac159..13af88da5f79 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3482,7 +3482,8 @@ static int __uverbs_create_xsrq(struct uverbs_attr_bundle *attrs,

 err_copy:
 	ib_destroy_srq_user(srq, uverbs_get_cleared_udata(attrs));
-
+	/* It was released in ib_destroy_srq_user */
+	srq = NULL;
 err_free:
 	kfree(srq);
 err_put:
--
2.20.1

