Return-Path: <SRS0=fADM=YW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFD5CA9EB9
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5D63214B2
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572330518;
	bh=QCRqW2glWZkGVXrLCWjpVgqgtmYbmITfk6+RifjWSzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nfY1KRTP6dSXVwfOd7Mp6sbNm6PbjzAFihZNq0/iMBpCT/JkhKjKfNgO0fnvh/d1y
	 TeNEyioxUKIIHuawu4ig9sB6oW9R2wSab9JBYlmKaQO3cUVbe1dI+XzPEWqZpvM2IQ
	 MAzRCsu45jdPXpGMpPVzagjDh7jle5YU2W6s3IPU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbfJ2G2i (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732529AbfJ2G2i (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Oct 2019 02:28:38 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E80D92087E;
        Tue, 29 Oct 2019 06:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572330517;
        bh=QCRqW2glWZkGVXrLCWjpVgqgtmYbmITfk6+RifjWSzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0pVg6U8bNMqM5UaTjePK3cQMuvsjzG9rrENQtSrRJK3sdz12KtZ0MOxT+OO0xCuX
         RXadxL8ZQ1Q9kGpBYTOJ+TadpY15rWKWy+/Mb3yefAP00YXtuZjdzZ9Lzm89pnqA7T
         fNfV/G0oTAbVFYoHiK8uU6ZhHshw3ynRAwFpsquc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ralph Campbell <ralph.campbell@qlogic.com>
Subject: [PATCH rdma-next 14/16] RDMA/qib: Delete extra line
Date:   Tue, 29 Oct 2019 08:27:43 +0200
Message-Id: <20191029062745.7932-15-leon@kernel.org>
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

Trivial cleanup to fix the following warning:
 drivers/infiniband/hw/qib/qib_iba6120.c:1420: warning: bad line:

Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/qib/qib_iba6120.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 531d8a1db2c3..ca5ea734e3d0 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1417,7 +1417,6 @@ static void qib_6120_quiet_serdes(struct qib_pportdata *ppd)
  *
  * The exact combo of LEDs if on is true is determined by looking
  * at the ibcstatus.
-
  * These LEDs indicate the physical and logical state of IB link.
  * For this chip (at least with recommended board pinouts), LED1
  * is Yellow (logical state) and LED2 is Green (physical state),
-- 
2.20.1

