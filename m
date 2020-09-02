Return-Path: <SRS0=RpEd=CL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D8BC433E7
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 17:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474162067C
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 17:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AWg0t4vX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgIBRBt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:01:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728332AbgIBQ6W (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Sep 2020 12:58:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GtQAJ000342;
        Wed, 2 Sep 2020 09:58:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RxDdez9tWPwYBdAHevogiYFHEX9nzupaBbr8IKhLEm0=;
 b=AWg0t4vXFwHddbECrX3XuOGAM3juVpnptRMQaVP1fz7BtS6z4KaVn21ZvV7y7IpCj+xo
 AMtLcWRNinyOiQ7AyJR3z3spqCxLC2WksYBEPPJqgzqRw710F4uOjTpq39LieYe1T92f
 dUrz1wd4QwkBqkA02TqMf0KUnY8POfK24voFmDqn7okYs3A+HOAoZWxtYkKK9O1rbgh/
 gqR3SZSMxdkEv5IN/cDSM3SoaaF73rI9dHuVBqptd5nBLpRy82WbG8FDJh4TpLD9gI6j
 4dvsdSPeX/gwj9Oavuy7gyAYp0uY1fa17ywPSHg5nYXQIn9wcJ0PYx/QOr38xjVlGChR Zg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq7jd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:16 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id BCB5F3F7045;
        Wed,  2 Sep 2020 09:58:13 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 3/8] RDMA/qedr: Fix use of uninitialized field
Date:   Wed, 2 Sep 2020 19:57:36 +0300
Message-ID: <20200902165741.8355-4-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200902165741.8355-1-michal.kalderon@marvell.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_11:2020-09-02,2020-09-02 signatures=0
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

dev->attr.page_size_caps was used uninitialized
when setting device attributes

Fixes: ec72fce401c6 ("qedr: Add support for RoCE HW init")
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index d85f992bac29..8e1365951fb6 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -602,7 +602,7 @@ static int qedr_set_device_attr(struct qedr_dev *dev)
 	qed_attr = dev->ops->rdma_query_device(dev->rdma_ctx);
 
 	/* Part 2 - check capabilities */
-	page_size = ~dev->attr.page_size_caps + 1;
+	page_size = ~qed_attr->page_size_caps + 1;
 	if (page_size > PAGE_SIZE) {
 		DP_ERR(dev,
 		       "Kernel PAGE_SIZE is %ld which is smaller than minimum page size (%d) required by qedr\n",
-- 
2.14.5

