Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FABC433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F200D206E2
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592447877;
	bh=pwL+vZd6p6HkyS/+DqSOcCIG9MvPvuGdkVsdRKMbYzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lh65GGAAWk4vY5Vq90GBd8EeZFqsy1ozKZA5GZP47sCyOa/zRJBurtuzQDQGIRY6E
	 d48L78WXIT0uiVMiE80ioK9kYylWn+7gKTDYPOx0/+2cZzj3JpiVlZ2MkZ7aJcgi6g
	 8/pKAUI+dxPjMLuwGhNGlM7I33mQKLA63tVQeFWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgFRChz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgFRBNf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B64D21974;
        Thu, 18 Jun 2020 01:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442815;
        bh=pwL+vZd6p6HkyS/+DqSOcCIG9MvPvuGdkVsdRKMbYzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJmV525nbVnrVnyqEH3lvSYVERPlm5BTeFixxyBCXlxNauKBBXy02DvZIaIzi21D2
         tKLtIjRxEH1zwJVVJqYUVx9AcAhCEKNmfiIMEHb83Gd8RRG0V4o8iOrjU12moWUe2h
         5ElwF2FJ4jiA1bHnbgiQ515ZluCiOXEYTzd0NZks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Firas JahJah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 253/388] RDMA/efa: Fix setting of wrong bit in get/set_feature commands
Date:   Wed, 17 Jun 2020 21:05:50 -0400
Message-Id: <20200618010805.600873-253-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit cc8a635e24acf2793605f243c913c51b8c3702ab ]

When using a control buffer the ctrl_data bit should be set in order to
indicate the control buffer address is valid, not ctrl_data_indirect
which is used when the control buffer itself is indirect.

Fixes: e9c6c5373088 ("RDMA/efa: Add common command handlers")
Link: https://lore.kernel.org/r/20200512152204.93091-2-galpress@amazon.com
Reviewed-by: Firas JahJah <firasj@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index eea5574a62e8..69f842c92ff6 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -388,7 +388,7 @@ static int efa_com_get_feature_ex(struct efa_com_dev *edev,
 
 	if (control_buff_size)
 		EFA_SET(&get_cmd.aq_common_descriptor.flags,
-			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA_INDIRECT, 1);
+			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
 
 	efa_com_set_dma_addr(control_buf_dma_addr,
 			     &get_cmd.control_buffer.address.mem_addr_high,
@@ -540,7 +540,7 @@ static int efa_com_set_feature_ex(struct efa_com_dev *edev,
 	if (control_buff_size) {
 		set_cmd->aq_common_descriptor.flags = 0;
 		EFA_SET(&set_cmd->aq_common_descriptor.flags,
-			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA_INDIRECT, 1);
+			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
 		efa_com_set_dma_addr(control_buf_dma_addr,
 				     &set_cmd->control_buffer.address.mem_addr_high,
 				     &set_cmd->control_buffer.address.mem_addr_low);
-- 
2.25.1

