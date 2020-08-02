Return-Path: <SRS0=CapX=BM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296AFC433E1
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F6F207DF
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgHBLQH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 2 Aug 2020 07:16:07 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:36739 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728271AbgHBLPr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 2 Aug 2020 07:15:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0U4Tqfqz_1596366943;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4Tqfqz_1596366943)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:43 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        parav@mellanox.com, maorg@mellanox.com, maxg@mellanox.com,
        monis@mellanox.com, chuck.lever@oracle.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@alibaba.com
Subject: [PATCH] IB/core: Fix wrong return value in _ib_modify_qp()
Date:   Sun,  2 Aug 2020 19:15:42 +0800
Message-Id: <20200802111542.5475-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: 7a5c938b9ed09 ("IB/core: Check for rdma_protocol_ib only after validating port_num")
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 53d6505c0c7b..f369f0a19e85 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1712,7 +1712,7 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 		if (!(rdma_protocol_ib(qp->device,
 				       attr->alt_ah_attr.port_num) &&
 		      rdma_protocol_ib(qp->device, port))) {
-			ret = EINVAL;
+			ret = -EINVAL;
 			goto out;
 		}
 	}
-- 
2.26.2

