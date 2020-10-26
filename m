Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F0FC4363A
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6CC22284
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603719473;
	bh=2a/YL1qYp6Mc5uAWYRi10oqxgLL97JmP/BMSStLb4yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=s2GwGzXy3xXYt4Ne7+/2BgtGDnvDxrNh5FEUXbvej8jA7XWB2RkwejLh+A5LsQxPJ
	 CNUzU+SoBNrKQ8lYSpQAhu3iwZ0krQvED1PpNPbXTK5z5zbQn7WT8W0MU42SrFYggX
	 tJVT79dawXOxEYHU5EUGYQzffLGGrat1KyKIjErg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775732AbgJZNhu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775618AbgJZNht (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 09:37:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7227321BE5;
        Mon, 26 Oct 2020 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603719469;
        bh=2a/YL1qYp6Mc5uAWYRi10oqxgLL97JmP/BMSStLb4yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEu/t97kyareyrTNlmX4wrrRnYHhj/tTpDXy7WtxYsyL6rSPo+IxVvKKEBOitaGFQ
         ab5o1EI5jvrbBVl1NQp8mSxzTep46FpUmsZkMOCYTy80xi2rRAPOxOtGO09OXQ+KS0
         REOhGl3hGxowlzcTvaQnHvUgkyF6l1HZ2COqBr8g=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Meir Lichtinger <meirl@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 1/2] IB/core: Add support for NDR link speed
Date:   Mon, 26 Oct 2020 15:37:37 +0200
Message-Id: <20201026133738.1340432-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026133738.1340432-1-leon@kernel.org>
References: <20201026133738.1340432-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Add new IBTA speed NDR, supporting signaling rate of 100Gb.

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 914cddea525d..2f032e79f36f 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -273,6 +273,10 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 		speed = " HDR";
 		rate = 500;
 		break;
+	case IB_SPEED_NDR:
+		speed = " NDR";
+		rate = 1000;
+		break;
 	case IB_SPEED_SDR:
 	default:		/* default to SDR for invalid rates */
 		speed = " SDR";
-- 
2.26.2

