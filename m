Return-Path: <SRS0=8+f9=6E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AB7C3815B
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 06:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5752078C
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 06:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="BeUTcZMc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgDTGWd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Apr 2020 02:22:33 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:28541 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgDTGWc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 20 Apr 2020 02:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587363752; x=1618899752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wugPN7wpot9zOnBv/NgVUdd311ptZ4cSgNtrjbH7cuw=;
  b=BeUTcZMch5cIoR0VxFeR12mj7bCo2d2ml58GKXXAn3rNR1sGn0JY2zeV
   4TCm7dEXOrzub2Ic1+IWbFhgfEOAbyff08lD/o/pgGp6r1u3dYhQzIpL6
   9+71wOAwg3/v/88Kxxc76CEd2AjH2sYP9r6azvSmaQ66etyGO2gofTCA9
   E=;
IronPort-SDR: /3Xqa5JvlMG6OOaX/2rrU9e5C+B5mT0xzchoWaKFq4BaJLf+Y0kFLb+8Frr28LWHLiEXGHiLVm
 7mwJO4kfcXBg==
X-IronPort-AV: E=Sophos;i="5.72,405,1580774400"; 
   d="scan'208";a="29678424"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Apr 2020 06:22:31 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 83295A21BB;
        Mon, 20 Apr 2020 06:22:29 +0000 (UTC)
Received: from EX13D19EUB001.ant.amazon.com (10.43.166.229) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Apr 2020 06:22:28 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D19EUB001.ant.amazon.com (10.43.166.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Apr 2020 06:22:27 +0000
Received: from 8c85908914bf.ant.amazon.com (10.1.212.20) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 20 Apr 2020 06:22:25 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Firas JahJah <firasj@amazon.com>,
        "Yossi Leybovich" <sleybo@amazon.com>
Subject: [PATCH for-next 1/3] RDMA/efa: Report create CQ error counter
Date:   Mon, 20 Apr 2020 09:22:11 +0300
Message-ID: <20200420062213.44577-2-galpress@amazon.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420062213.44577-1-galpress@amazon.com>
References: <20200420062213.44577-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Create CQ errors are already being counted, report them along all other
counters.

Reviewed-by: Firas JahJah <firasj@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 5c57098a4aee..b555845d6c14 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -41,6 +41,7 @@ struct efa_user_mmap_entry {
 	op(EFA_KEEP_ALIVE_RCVD, "keep_alive_rcvd") \
 	op(EFA_ALLOC_PD_ERR, "alloc_pd_err") \
 	op(EFA_CREATE_QP_ERR, "create_qp_err") \
+	op(EFA_CREATE_CQ_ERR, "create_cq_err") \
 	op(EFA_REG_MR_ERR, "reg_mr_err") \
 	op(EFA_ALLOC_UCONTEXT_ERR, "alloc_ucontext_err") \
 	op(EFA_CREATE_AH_ERR, "create_ah_err")
@@ -1753,6 +1754,7 @@ int efa_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
 	stats->value[EFA_KEEP_ALIVE_RCVD] = atomic64_read(&s->keep_alive_rcvd);
 	stats->value[EFA_ALLOC_PD_ERR] = atomic64_read(&s->sw_stats.alloc_pd_err);
 	stats->value[EFA_CREATE_QP_ERR] = atomic64_read(&s->sw_stats.create_qp_err);
+	stats->value[EFA_CREATE_CQ_ERR] = atomic64_read(&s->sw_stats.create_cq_err);
 	stats->value[EFA_REG_MR_ERR] = atomic64_read(&s->sw_stats.reg_mr_err);
 	stats->value[EFA_ALLOC_UCONTEXT_ERR] = atomic64_read(&s->sw_stats.alloc_ucontext_err);
 	stats->value[EFA_CREATE_AH_ERR] = atomic64_read(&s->sw_stats.create_ah_err);
-- 
2.26.1

