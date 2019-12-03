Return-Path: <SRS0=/a3O=ZZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03D4C432C0
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Dec 2019 02:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F688206DC
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Dec 2019 02:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLCCa6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 2 Dec 2019 21:30:58 -0500
Received: from linode.aoot.com ([69.164.194.13]:59738 "EHLO linode.aoot.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfLCCa6 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 2 Dec 2019 21:30:58 -0500
Received: from work.aoot.com.com (li1110-136.members.linode.com [45.79.11.136])
        by linode.aoot.com (Postfix) with ESMTP id C41CE8721;
        Mon,  2 Dec 2019 20:02:04 -0600 (CST)
From:   Steve Wise <larrystevenwise@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Steve Wise <larrystevenwise@gmail.com>
Subject: [PATCH 1/2] Update mailmap info for Steve Wise
Date:   Mon,  2 Dec 2019 20:03:18 -0600
Message-Id: <20191203020319.15036-1-larrystevenwise@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
---
 .mailmap | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.mailmap b/.mailmap
index 83d7e750c2fc..ef79a4a6c258 100644
--- a/.mailmap
+++ b/.mailmap
@@ -267,3 +267,5 @@ Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
 Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
+Steve Wise <larrystevenwise@gmail.com> <swise@chelsio.com>
+Steve Wise <larrystevenwise@gmail.com> <swise@opengridcomputing.com>
-- 
2.20.1

