Return-Path: <SRS0=Drwg=WW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8522FC3A59F
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Aug 2019 11:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506592070B
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Aug 2019 11:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="S0PEDg8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfHZLya (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Aug 2019 07:54:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:6547 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfHZLya (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 26 Aug 2019 07:54:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566820469; x=1598356469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cl+DGdzJKaLlOSCxii9ydwrEAJfwIHGbxo+RP1PWUlk=;
  b=S0PEDg8e/gGgmzkGsi8IfxhqEPQ+cu7DKvlqdHjSLbFXXkxGlFs3AQTb
   AUWYYnhDFifH4q5f/6dZe6woAG6T6++JZaGgMhQ/ZEjs05OcyTQkLvWLM
   4yZOSPaTGyqVXSQVYglg1UQeXitxfbMwMI0vtsB7qE3v+kg35Hcunxr6b
   I=;
X-IronPort-AV: E=Sophos;i="5.64,433,1559520000"; 
   d="scan'208";a="697491091"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Aug 2019 11:54:27 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 85FE7A2090;
        Mon, 26 Aug 2019 11:54:27 +0000 (UTC)
Received: from EX13D19EUB002.ant.amazon.com (10.43.166.78) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 26 Aug 2019 11:54:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D19EUB002.ant.amazon.com (10.43.166.78) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 26 Aug 2019 11:54:26 +0000
Received: from 8c85908914bf.ant.amazon.com (10.218.69.144) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 26 Aug 2019 11:54:22 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, Gal Pressman <galpress@amazon.com>,
        "Firas JahJah" <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>
Subject: [PATCH for-next 1/2] RDMA/efa: Remove umem check on dereg MR flow
Date:   Mon, 26 Aug 2019 14:53:49 +0300
Message-ID: <20190826115350.21718-2-galpress@amazon.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190826115350.21718-1-galpress@amazon.com>
References: <20190826115350.21718-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

EFA driver is not a kverbs provider, the check for MR umem is redundant.

Reviewed-by: Firas JahJah <firasj@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 70851bd7f801..1e23c621a419 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1500,14 +1500,12 @@ int efa_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	ibdev_dbg(&dev->ibdev, "Deregister mr[%d]\n", ibmr->lkey);
 
-	if (mr->umem) {
-		params.l_key = mr->ibmr.lkey;
-		err = efa_com_dereg_mr(&dev->edev, &params);
-		if (err)
-			return err;
-	}
-	ib_umem_release(mr->umem);
+	params.l_key = mr->ibmr.lkey;
+	err = efa_com_dereg_mr(&dev->edev, &params);
+	if (err)
+		return err;
 
+	ib_umem_release(mr->umem);
 	kfree(mr);
 
 	return 0;
-- 
2.22.0

