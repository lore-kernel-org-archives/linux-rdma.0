Return-Path: <SRS0=gJYK=45=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5567C1975A
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 08:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4740206B7
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 08:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584002233;
	bh=gJT5naPN5Xn9NuiSUHLGKB78VjoNV2j8Vc4s7/Pwl3Y=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mkudlXbH13IWSxsESCcEGTnpt/i2vuO6EvWX+8XX/UGGO29EoqqRDBa+IDyMRBfjx
	 0ZwK6czXXYIX7aCT8btXSdQDPeIBHdGyt1ie5m5kkuqvlojbcWDSkQQE4Gl72Gz723
	 9HN0lHr/2KdRlcaTSs4TfTTAOoCg9+/OD9fA2y7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCLIhM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgCLIhL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Mar 2020 04:37:11 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9851206B7;
        Thu, 12 Mar 2020 08:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584002231;
        bh=gJT5naPN5Xn9NuiSUHLGKB78VjoNV2j8Vc4s7/Pwl3Y=;
        h=From:To:Cc:Subject:Date:From;
        b=cc3Rz/cZqwAB9bJ07Dfcy4aDX9Gs/8NrpppVcXVbn+NwIPVsj0IeuhGohf+CgeCBM
         mFxn0mLDMfUzVXNEWT/WcgpMkfGA0Ov8RvyXHop9JXRo80VxwpHtPiYodMW0HbBxWE
         lXzrh6lhOoYCUwkIdAeRGPZ/xS/8vqVoq33kjaLM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moni Shoua <monis@mellanox.com>,
        Zhu Yanjun <yanjunz@mellanox.com>
Subject: [PATCH rdma-next] MAINTAINERS: Clean RXE section and add Zhu as RXE maintainer
Date:   Thu, 12 Mar 2020 10:36:58 +0200
Message-Id: <20200312083658.29603-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Zhu Yanjun contributed many patches to RXE and expressed genuine
interest in improve RXE even more. Let's add him as a maintainer.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 MAINTAINERS | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6fbdf354d34..83b420d76f43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15418,11 +15418,9 @@ F:	drivers/infiniband/sw/siw/
 F:	include/uapi/rdma/siw-abi.h

 SOFT-ROCE DRIVER (rxe)
-M:	Moni Shoua <monis@mellanox.com>
+M:	Zhu Yanjun <yanjunz@mellanox.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-W:	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/sw/rxe/
 F:	include/uapi/rdma/rdma_user_rxe.h

--
2.24.1

