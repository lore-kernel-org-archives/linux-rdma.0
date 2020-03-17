Return-Path: <SRS0=Q14g=5C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C73C10F29
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Mar 2020 03:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A520920658
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Mar 2020 03:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgCQD7S (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Mar 2020 23:59:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41490 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726192AbgCQD7S (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 16 Mar 2020 23:59:18 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7DDFF21B622A94161AF5;
        Tue, 17 Mar 2020 11:59:15 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 17 Mar 2020 11:59:05 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 0/2] RDMA/hns: Optimize codes related to multi-hop addressing
Date:   Tue, 17 Mar 2020 11:55:22 +0800
Message-ID: <1584417324-2255-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Codes about getting/putting HEM(Hardware Entry Memory) in multi-hop
addressing are not clear enough, so optimize by spliting and encapsulating
them into new functions.

Xi Wang (2):
  RDMA/hns: Optimize mhop get flow for multi-hop addressing
  RDMA/hns: Optimize mhop put flow for multi-hop addressing

 drivers/infiniband/hw/hns/hns_roce_hem.c | 458 ++++++++++++++++---------------
 1 file changed, 243 insertions(+), 215 deletions(-)

-- 
2.8.1

