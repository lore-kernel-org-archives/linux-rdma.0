Return-Path: <SRS0=3BW3=YQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7435DCA9EAE
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 05:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455DF21906
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 05:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571809368;
	bh=Fru/LW+WN4qlZN9a8ANaKPV+Bqv9V8WTLnRB+1FNXxM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=aMg2FFGQmhWXf1JdImhKiqdwnKWJydstFtitK85NOZZ6oBzHpVnO2FRw44WQ/7YrA
	 sf6uijrGaXdz0FM4ZvPleVknCwbNuFXAGNuq56fZFO4Z3zdr3WlUX+Ru1NLV83j+wT
	 o02W4hrqsmoQF7iLBM8skQvyu2UXoZ/tc9EJs3CI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfJWFmr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Oct 2019 01:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfJWFmr (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 23 Oct 2019 01:42:47 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 233732173B;
        Wed, 23 Oct 2019 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571809366;
        bh=Fru/LW+WN4qlZN9a8ANaKPV+Bqv9V8WTLnRB+1FNXxM=;
        h=From:To:Cc:Subject:Date:From;
        b=BIS5sVTXZ5uP0Cpvig50qKFmUJClX470Wv9WryLEhJ5S2Z7DA+6SV5eRDGozQ+NsV
         vrutzrmjC2oTGBVa0ZkREHkx1trU9HNPs3N+9crG2vGEsMgtgXMs7uJEu9xPmR/c5J
         pfUqosnCE/6Gx/0r7pZ4BxsM6eqBp306NBKlwj1Q=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH rdma-next] RDMA/hns: Delete BITS_PER_BYTE redefinition
Date:   Wed, 23 Oct 2019 08:42:39 +0300
Message-Id: <20191023054239.31648-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

HNS redefined available in bits.h define and didn't use it,
we can safely delete it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index cbd75e466417..940761310430 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -53,8 +53,6 @@
 
 #define BA_BYTE_LEN				8
 
-#define BITS_PER_BYTE				8
-
 /* Hardware specification only for v1 engine */
 #define HNS_ROCE_MIN_CQE_NUM			0x40
 #define HNS_ROCE_MIN_WQE_NUM			0x20
-- 
2.20.1

