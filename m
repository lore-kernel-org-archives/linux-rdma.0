Return-Path: <SRS0=TGoC=XL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0728C49ED7
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 07:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B65EF20890
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Sep 2019 07:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568617935;
	bh=st9B31xKUy/VBwiWwoFPkbUMOmiagK1DV0YrEHiryaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cEuxrQiKZIllqumlDm+3P4zukmysNp4X6ZyymsYaUO+4m4HeiwDd+hpJR4GLDXsTM
	 uZmvyrZp8y3vB+vQyT0/USgmDZK6hieNIYifMQm8vRE2Qd+BaEFsjigbHwvTpgkoDN
	 NPgj2LHDP8/eYTNyfo/HmWvhtEekBWIDRjps5WvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfIPHMP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Sep 2019 03:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfIPHMP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 16 Sep 2019 03:12:15 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0226E2067D;
        Mon, 16 Sep 2019 07:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568617934;
        bh=st9B31xKUy/VBwiWwoFPkbUMOmiagK1DV0YrEHiryaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqQYHq5gztV4bzXyKFZyXs26MmN32QvRyBJx7nvBDdgbgTKplKP7DP1Z3WjjHCTab
         V8W6P8i1h4JX3AqTIe6h1rKb+hYn0rvlU4DSZOrPBCPi/ai5Mf9GYmP6Z4buawjBbn
         20P+/FyjIXAoJuQ3ZsAlUoLFMwWoHyLSAwWfb1ZM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Mark Zhang <markz@mellanox.com>
Subject: [PATCH 2/4] RDMA/counter: Prevent QP counter manual binding in auto mode
Date:   Mon, 16 Sep 2019 10:11:52 +0300
Message-Id: <20190916071154.20383-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916071154.20383-1-leon@kernel.org>
References: <20190916071154.20383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

If auto mode is configured, manual counter allocation and QP bind is
not allowed.

Fixes: 1bd8e0a9d0fd ("RDMA/counter: Allow manual mode configuration support")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 680ad27f497d..736ab760025d 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -463,10 +463,15 @@ static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
 int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
 			  u32 qp_num, u32 counter_id)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
 	struct ib_qp *qp;
 	int ret;

+	port_counter = &dev->port_data[port].port_counter;
+	if (port_counter->mode.mode == RDMA_COUNTER_MODE_AUTO)
+		return -EINVAL;
+
 	qp = rdma_counter_get_qp(dev, qp_num);
 	if (!qp)
 		return -ENOENT;
@@ -503,6 +508,7 @@ int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
 int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 				u32 qp_num, u32 *counter_id)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
 	struct ib_qp *qp;
 	int ret;
@@ -510,9 +516,13 @@ int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 	if (!rdma_is_port_valid(dev, port))
 		return -EINVAL;

-	if (!dev->port_data[port].port_counter.hstats)
+	port_counter = &dev->port_data[port].port_counter;
+	if (!port_counter->hstats)
 		return -EOPNOTSUPP;

+	if (port_counter->mode.mode == RDMA_COUNTER_MODE_AUTO)
+		return -EINVAL;
+
 	qp = rdma_counter_get_qp(dev, qp_num);
 	if (!qp)
 		return -ENOENT;
--
2.20.1

