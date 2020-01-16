Return-Path: <SRS0=Ta2D=3F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72824C33CAF
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 18:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4AC214AF
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jan 2020 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198970;
	bh=wwbE6782tZaeUv5UL03nSo40w+1Six7/290IIljvBUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LYmuwAFP1O5bidHSsPDJLrnBle++l9QhzEfzscF2FIEc5NdspID6rW8mYQyq8lBE7
	 Q2y7pdFfr6TnastpvyD1DTDt+/TbWS8Bb2KRWklKoyH9P4CeyZ+FWXr9v5f9EL9oR5
	 eghoh9yF1cy+PEZVQ93OAbSV4tFN6TGnPfN/emDc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390484AbgAPSWs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404020AbgAPR1Z (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD9EC246D0;
        Thu, 16 Jan 2020 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195644;
        bh=wwbE6782tZaeUv5UL03nSo40w+1Six7/290IIljvBUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKptHAxpRO3Ft+4mACFYhNXQgVYax7TzlLoPfPzjOlJ605A2krmgkhanSzhJ23SCh
         fgPdsvuBx5VnIc3X52Q1Q81eocF4Mf9Y60Lr6jvrAaPmIcCaa1BUP12LhI3W5w6sLj
         X367f3atBIv4KazVRUTT2C57XUfFdYgKnMhxcGEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagiv Ozeri <sagiv.ozeri@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 208/371] RDMA/qedr: Fix incorrect device rate.
Date:   Thu, 16 Jan 2020 12:21:20 -0500
Message-Id: <20200116172403.18149-151-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Sagiv Ozeri <sagiv.ozeri@marvell.com>

[ Upstream commit 69054666df0a9b4e8331319f98b6b9a88bc3fcc4 ]

Use the correct enum value introduced in commit 12113a35ada6 ("IB/core:
Add HDR speed enum") Prior to this change a 50Gbps port would show 40Gbps.

This patch also cleaned up the redundant redefiniton of ib speeds for
qedr.

Fixes: 12113a35ada6 ("IB/core: Add HDR speed enum")
Signed-off-by: Sagiv Ozeri <sagiv.ozeri@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 8bfe9073da78..6ae72accae3d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -178,54 +178,47 @@ int qedr_query_device(struct ib_device *ibdev,
 	return 0;
 }
 
-#define QEDR_SPEED_SDR		(1)
-#define QEDR_SPEED_DDR		(2)
-#define QEDR_SPEED_QDR		(4)
-#define QEDR_SPEED_FDR10	(8)
-#define QEDR_SPEED_FDR		(16)
-#define QEDR_SPEED_EDR		(32)
-
 static inline void get_link_speed_and_width(int speed, u8 *ib_speed,
 					    u8 *ib_width)
 {
 	switch (speed) {
 	case 1000:
-		*ib_speed = QEDR_SPEED_SDR;
+		*ib_speed = IB_SPEED_SDR;
 		*ib_width = IB_WIDTH_1X;
 		break;
 	case 10000:
-		*ib_speed = QEDR_SPEED_QDR;
+		*ib_speed = IB_SPEED_QDR;
 		*ib_width = IB_WIDTH_1X;
 		break;
 
 	case 20000:
-		*ib_speed = QEDR_SPEED_DDR;
+		*ib_speed = IB_SPEED_DDR;
 		*ib_width = IB_WIDTH_4X;
 		break;
 
 	case 25000:
-		*ib_speed = QEDR_SPEED_EDR;
+		*ib_speed = IB_SPEED_EDR;
 		*ib_width = IB_WIDTH_1X;
 		break;
 
 	case 40000:
-		*ib_speed = QEDR_SPEED_QDR;
+		*ib_speed = IB_SPEED_QDR;
 		*ib_width = IB_WIDTH_4X;
 		break;
 
 	case 50000:
-		*ib_speed = QEDR_SPEED_QDR;
-		*ib_width = IB_WIDTH_4X;
+		*ib_speed = IB_SPEED_HDR;
+		*ib_width = IB_WIDTH_1X;
 		break;
 
 	case 100000:
-		*ib_speed = QEDR_SPEED_EDR;
+		*ib_speed = IB_SPEED_EDR;
 		*ib_width = IB_WIDTH_4X;
 		break;
 
 	default:
 		/* Unsupported */
-		*ib_speed = QEDR_SPEED_SDR;
+		*ib_speed = IB_SPEED_SDR;
 		*ib_width = IB_WIDTH_1X;
 	}
 }
-- 
2.20.1

