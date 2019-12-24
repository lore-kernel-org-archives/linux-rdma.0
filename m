Return-Path: <SRS0=52Hh=2O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC05C2D0D5
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Dec 2019 08:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E6E5206B7
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Dec 2019 08:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfLXIdE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:33:04 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7745 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbfLXIdE (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 24 Dec 2019 03:33:04 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7B65355FED47BDE59E39;
        Tue, 24 Dec 2019 16:33:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 16:32:51 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bmt@zurich.ibm.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <linux-rdma@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 0/5] RDMA: use true,false for bool variable
Date:   Tue, 24 Dec 2019 16:40:07 +0800
Message-ID: <1577176812-2238-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

zhengbin (5):
  RDMA/siw: use true,false for bool variable
  IB/hfi1: use true,false for bool variable
  IB/iser: use true,false for bool variable
  RDMA/mlx4: use true,false for bool variable
  RDMA/mlx5: use true,false for bool variable

 drivers/infiniband/hw/hfi1/rc.c           | 2 +-
 drivers/infiniband/hw/mlx4/qp.c           | 4 ++--
 drivers/infiniband/hw/mlx5/mr.c           | 4 ++--
 drivers/infiniband/hw/mlx5/qp.c           | 2 +-
 drivers/infiniband/sw/siw/siw_cm.c        | 2 +-
 drivers/infiniband/ulp/iser/iser_memory.c | 2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c  | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

--
2.7.4

