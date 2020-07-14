Return-Path: <SRS0=LoKS=AZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEBAC433E7
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jul 2020 08:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4327C217D8
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jul 2020 08:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdjsX1x7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGNILB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgGNILB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 14 Jul 2020 04:11:01 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F56C061755
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2020 01:11:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z2so20210328wrp.2
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2020 01:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VaUnzA+VnyAFjx4M4tqIGYLdyaDf1nvOkia8P/7QAX4=;
        b=MdjsX1x7MTwv5wq1CiEWVJeJ6IbkHSZeq4HdOBckVi6MvZDb+OEuF1PfZqlWaGgI+M
         02YmYtfPDnZou4DpN1AEe0E7Xoi2vgo6c1hff7/QDKQxJMLHYvxVg+207Ym15KjfniUO
         kdrNxZI4MSSOZnKQ7Dx+Fq+1ISfNevjKocjOtDhbg5hbMBTQE3KK+MpzUNA5Adh8sqf3
         FLzzpUKl2VTd3K7kuFw23K8/XXS9+xwYcJ3OKW12VoPEqvc/d2YHWt4e6yE84J/kMqLa
         pvNX2ryyz3lszl8hSARaa94AvXl1KIdw5YPGMMNdwLABL8CjD+R9vSNsqNoi63Luv+kG
         StHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VaUnzA+VnyAFjx4M4tqIGYLdyaDf1nvOkia8P/7QAX4=;
        b=F2wOTUd4K/+5FuwDPZ03Va8mRvrNGaZh6Y//B1UutcYaDVzr5ixz/37qWbApSYmNuq
         9wt1g0BJr7OCNiEvrSHfvIJyWfTsp1zWqNlNpVtKMNcpf/47P7Vxxk9cfZ3TkWFHFFXX
         a37+Sxwyip0gvq0p/8OFNQRg6IwkKYBFtfpTTiJE3MQF0wbWXTe7rp0CkXjPjoTDLwoE
         HNnbOEEQrgWMlH2LTWmXHjyBZ0eT2KzEztcw/x105ugaPP7XhBFTuJsUYoisFS0e22sQ
         frJlxjpK+EzwSVt9HjopI++opsfV4pb5LkOusm5brXklCFfOEkXrtpOzds1X+Dh0XN98
         V89g==
X-Gm-Message-State: AOAM532y6PrEll0CmZi9Wg6WYSEtSQ4/e5AdG2jyTtD8X/68bG3uDNjA
        JQRMsxIX2hY92ACFDEM31Q0va3F3V2U=
X-Google-Smtp-Source: ABdhPJyQkCk4efjh0sQ3vxIL7ibk4e3gJFItXfMFk4MH45F2K6G7DiMORQIIuEM+xVX3m4axE4w3xQ==
X-Received: by 2002:a5d:4051:: with SMTP id w17mr3587010wrp.183.1594714259234;
        Tue, 14 Jul 2020 01:10:59 -0700 (PDT)
Received: from kheib-workstation.redhat.com (bzq-79-176-63-152.red.bezeqint.net. [79.176.63.152])
        by smtp.gmail.com with ESMTPSA id f197sm3403891wme.33.2020.07.14.01.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 01:10:58 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Michal Kalderon <mkalderon@marvell.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next 7/7] RDMA/qedr: Remove the query_pkey callback
Date:   Tue, 14 Jul 2020 11:10:38 +0300
Message-Id: <20200714081038.13131-8-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200714081038.13131-1-kamalheib1@gmail.com>
References: <20200714081038.13131-1-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Now that the query_pkey() isn't mandatory by the RDMA core for iwarp
providers, this callback can be removed from the common ops and moved to
the RoCE only ops within the qedr driver.

Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/hw/qedr/main.c  | 3 +--
 drivers/infiniband/hw/qedr/verbs.c | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index ccaedfd53e49..c9eeed25c662 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -110,7 +110,6 @@ static int qedr_iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	if (err)
 		return err;
 
-	immutable->pkey_tbl_len = 1;
 	immutable->gid_tbl_len = 1;
 	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 	immutable->max_mad_size = 0;
@@ -179,6 +178,7 @@ static int qedr_iw_register_device(struct qedr_dev *dev)
 
 static const struct ib_device_ops qedr_roce_dev_ops = {
 	.get_port_immutable = qedr_roce_port_immutable,
+	.query_pkey = qedr_query_pkey,
 };
 
 static void qedr_roce_register_device(struct qedr_dev *dev)
@@ -221,7 +221,6 @@ static const struct ib_device_ops qedr_dev_ops = {
 	.post_srq_recv = qedr_post_srq_recv,
 	.process_mad = qedr_process_mad,
 	.query_device = qedr_query_device,
-	.query_pkey = qedr_query_pkey,
 	.query_port = qedr_query_port,
 	.query_qp = qedr_query_qp,
 	.query_srq = qedr_query_srq,
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 3d7d5617818f..63eb935a1596 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -239,7 +239,6 @@ int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
 	attr->ip_gids = true;
 	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
 		attr->gid_tbl_len = 1;
-		attr->pkey_tbl_len = 1;
 	} else {
 		attr->gid_tbl_len = QEDR_MAX_SGID;
 		attr->pkey_tbl_len = QEDR_ROCE_PKEY_TABLE_LEN;
-- 
2.25.4

