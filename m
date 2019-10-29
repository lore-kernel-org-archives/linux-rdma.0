Return-Path: <SRS0=fADM=YW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B45FCA9EB9
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22DA92086D
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572330494;
	bh=QiVeTlKAIpjT8Y6NaGKZXudMXq7ScjW6RpgOl7QRgZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aMRi19XJgHtsL9Or5FXVwwK9eV898fmlNHyuxLZsp+UW5NE+kUpKsvZERa+fAEUq5
	 aXs3AHv+ZeL6y5A7h4zdHSceu6bfNoFmuGwV6Qc1i0Cvi4U5xB4AFMFs4rjOh+aCg5
	 hkXa9+/Zs3LIdOalKGx0W44ZmiGg5GJGgzUBxK2o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbfJ2G2N (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbfJ2G2N (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Oct 2019 02:28:13 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A40920862;
        Tue, 29 Oct 2019 06:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572330492;
        bh=QiVeTlKAIpjT8Y6NaGKZXudMXq7ScjW6RpgOl7QRgZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgazuVhe9iZGdkEi5zmUDrCgs8uHMs5h4QTepQbAR067HkP1qYmr3XKJ1aHirJ2Lg
         z0UnX/5sbmA+6KUGixZPg6v+BoQfK0GtL0RGomSeyl9cZ/rRTQ6siJ7fik3IL+dUyT
         kY2xTraBlfKczCy66TS0zPBT3BrW88afbGIVYlD8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ralph Campbell <ralph.campbell@qlogic.com>
Subject: [PATCH rdma-next 07/16] RDMA/hfi1: Delete unreachable code
Date:   Tue, 29 Oct 2019 08:27:36 +0200
Message-Id: <20191029062745.7932-8-leon@kernel.org>
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
 drivers/infiniband/hw/hfi1/mad.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index d8ff063a5419..a54746f4a0ae 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -4921,10 +4921,6 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 {
 	switch (in_mad->base_version) {
 	case OPA_MGMT_BASE_VERSION:
-		if (unlikely(in_mad_size != sizeof(struct opa_mad))) {
-			dev_err(ibdev->dev.parent, "invalid in_mad_size\n");
-			return IB_MAD_RESULT_FAILURE;
-		}
 		return hfi1_process_opa_mad(ibdev, mad_flags, port,
 					    in_wc, in_grh,
 					    (struct opa_mad *)in_mad,
-- 
2.20.1

