Return-Path: <SRS0=UaOm=CW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C607C43461
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Sep 2020 10:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A4920709
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Sep 2020 10:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599992979;
	bh=C8/Beu3dUK9BCHuZ8zUj6D2cJUePFIr4x5XdPI8kuxs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=pa5KhW0vO8Uk+eo7KabdLR8Fh45A6+bDOqer4l4qu9I6N3BWzdaydur8gm9MyRdpH
	 oCDP7dX11IHKL6P1an9TN73bHKJ3vjOCpnJQSnwNlj2mrLGTNcR/AE4DWp7wDnzVLT
	 EF14uRjIxUPwe5fp8NmHfR3AfTvH6yeHz27SbsAQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgIMK3g (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 13 Sep 2020 06:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbgIMK3e (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 13 Sep 2020 06:29:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0699A20709;
        Sun, 13 Sep 2020 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599992973;
        bh=C8/Beu3dUK9BCHuZ8zUj6D2cJUePFIr4x5XdPI8kuxs=;
        h=From:To:Cc:Subject:Date:From;
        b=sCPQdk0aHUtYiiJUF7OA1d/xSMN3qS3V9MhryCOzMjERAJM2FLGuqnlQLL3AOdEEX
         uZw9oA+wVyt1dzWUGMC2KsjgeSvwDYS68uJjOg6+lZzYQ1qBh1VtL99f7CDzbF9/vw
         X/D00NzExCyiUgPtJ+7BSzb8RVdvKdxS5j2Alxlw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH rdma-next] overflow: Include header file with SIZE_MAX declaration
Date:   Sun, 13 Sep 2020 13:29:28 +0300
Message-Id: <20200913102928.134985-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The various array_size functions use SIZE_MAX define, but missed limits.h
causes to failure to compile code that needs overflow.h.

 In file included from drivers/infiniband/core/uverbs_std_types_device.c:6:
 ./include/linux/overflow.h: In function 'array_size':
 ./include/linux/overflow.h:258:10: error: 'SIZE_MAX' undeclared (first use in this function)
   258 |   return SIZE_MAX;
       |          ^~~~~~~~

Fixes: 610b15c50e86 ("overflow.h: Add allocation size calculation helpers")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/overflow.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 93fcef105061..ff3c48f0abc5 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -3,6 +3,7 @@
 #define __LINUX_OVERFLOW_H

 #include <linux/compiler.h>
+#include <linux/limits.h>

 /*
  * In the fallback code below, we need to compute the minimum and
--
2.26.2

