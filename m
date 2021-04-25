Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A663C433B4
	for <linux-rdma@archiver.kernel.org>; Sun, 25 Apr 2021 11:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ADE161165
	for <linux-rdma@archiver.kernel.org>; Sun, 25 Apr 2021 11:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhDYLyM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 25 Apr 2021 07:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhDYLyL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 25 Apr 2021 07:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FF7611B0;
        Sun, 25 Apr 2021 11:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619351611;
        bh=DRqj+jgYbTUnlBQZlpWxl9LPezWuPxaM7xZxvnOkRvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIniyEqaC7wVlCG3Seva3nyNyewPCmaefgOTBwQEo7rXkIWiiXdWLrlsHupoPtzKy
         CkPsiTeni3DZqvAyc4Xu6HiWxPp7CWpyIZzxTyj7PZowFlexr2SLqQtKuB4pmyWIOW
         zPAUtlwdWBFMgU6mxxm7tkFiOkrrIKD7utbnr8WrMwC5qZC2yegxQH3R++pKKHKqZA
         6HHI2wjLYRgU3m0WOlhaohA+NiCFd5rymD1pZfdM2xB3fP+5OFcGRDtROsvqAOnK6B
         zJXh+Gz+/eCjcyEtE4etbQHWEvUEP+KnK4j7XaAd9z203cxjzURRzqfub5gEdMoJF8
         VGZ7CIRLX9rIw==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Neta Ostrovsky <netao@nvidia.com>, Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 1/3] rdma: Update uapi headers
Date:   Sun, 25 Apr 2021 14:53:20 +0300
Message-Id: <dc6ed9c5e6e5247dd65303bdc6d2898d0f90e714.1619351025.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1619351025.git.leonro@nvidia.com>
References: <cover.1619351025.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

Update rdma_netlink.h file upto kernel commit c6c11ad3ab9f
("RDMA/nldev: Add QP numbers to SRQ information")

Reviewed-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 4aef76ae..e161c245 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -293,6 +293,10 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_MR_GET_RAW,
 
+	RDMA_NLDEV_CMD_RES_CTX_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_SRQ_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -533,6 +537,15 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_ATTR_RES_RAW,	/* binary */
 
+	RDMA_NLDEV_ATTR_RES_CTX,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_CTX_ENTRY,		/* nested table */
+
+	RDMA_NLDEV_ATTR_RES_SRQ,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SRQ_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SRQN,		/* u32 */
+
+	RDMA_NLDEV_ATTR_MIN_RANGE,		/* u32 */
+	RDMA_NLDEV_ATTR_MAX_RANGE,		/* u32 */
 	/*
 	 * Always the end
 	 */
-- 
2.30.2

