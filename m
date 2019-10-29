Return-Path: <SRS0=fADM=YW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0AECA9EC1
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C27F421835
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572330529;
	bh=Ijfxze+D0d1gZ5+SJKYoRih6N+4P4TpA6LATaI8kDiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FoW7nOy7gOKflDaEGWM+HGVDGcZ1PnZdplfZLTrRh9IP3jBiCLOzp/mkqUE6xWq8r
	 YnzYlz/0eBhgCPl6fDeSjPDBgIggxl4TleXBjr708/trJy/gxuck7aHkS7zXRazi3p
	 H9yDPudVSmMV+9AMb3BW3p0m9gs+Imu7xXOlf0hU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfJ2G2t (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732535AbfJ2G2t (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Oct 2019 02:28:49 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F391B217D9;
        Tue, 29 Oct 2019 06:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572330528;
        bh=Ijfxze+D0d1gZ5+SJKYoRih6N+4P4TpA6LATaI8kDiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcf4Z4DDR5UVlqEK/L1XcDUkP1DNvzQZhJgWFHYDAC2fKYrGbYKX1/ZYYOLFRd6w/
         JYPx8K4roJxRgzSFUQT4nR4ZX5TEyvpEuQpzoOgauBgnHT851L9GN2kBm3Ah1ghnh9
         j53ZxXxCxC13NuN10Mh7CV2x5e7EPpn7OiGNzbgA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ralph Campbell <ralph.campbell@qlogic.com>
Subject: [PATCH rdma-next 12/16] RDMA/qib: Delete unreachable code
Date:   Tue, 29 Oct 2019 08:27:41 +0200
Message-Id: <20191029062745.7932-13-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029062745.7932-1-leon@kernel.org>
References: <20191029062745.7932-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

All callers allocate MAD structures with proper sizes,
there is no need to recheck it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/qib/qib_mad.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 5a1e6371ea57..ba8c81e486be 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2397,10 +2397,6 @@ int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
-			 *out_mad_size != sizeof(*out_mad)))
-		return IB_MAD_RESULT_FAILURE;
-
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
 	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
-- 
2.20.1

