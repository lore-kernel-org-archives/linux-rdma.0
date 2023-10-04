Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7D1E7C4D0
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Oct 2023 15:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjJDP3q (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 4 Oct 2023 11:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbjJDP3p (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 4 Oct 2023 11:29:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D520EBD
        for <linux-rdma@vger.kernel.org>; Wed,  4 Oct 2023 08:29:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D73AC433C8;
        Wed,  4 Oct 2023 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696433382;
        bh=c4pF46O42WnzDGmUyCITipFiqwlOLHHxQdH7r6djoFY=;
        h=Subject:From:To:Cc:Date:From;
        b=H/QXzpG6rcQ68ECtdNTow2wPgDJ+rmYiq7dregPhccmtG1VqhkqHZ7gnqsB5+jlub
         HXvvO0j2xTHUamnwWXiI7ztViMSir/AnlkfGt2nrAuSPXEiZ2UctyR3lnG1/uBc/IT
         Ix/nv1zZdiOM10ic0JvMKEXhCbB5/XOi7gtXYNihpSxI41is6/l+uEI3ubrx7ZfMM6
         xvjt/WWT1VAM6xzQ0GlvUHAfJ1v9zueVRCGGP2jA83v635kR7i120JnHOcm0SIMoEX
         gKEtw1hHCQKbPYJa9XbRENmk1PvB+pUC640LyPlJiUV1g8QoZPAXxB2sc5zyvfeyMM
         wC1q17H01h7ew==
Subject: [PATCH] RDMA/core: Fix a couple of obvious typos in comments
From:   Chuck Lever <cel@kernel.org>
To:     jgg@nvidia.com, leon@kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>, linux-rdma@vger.kernel.org
Date:   Wed, 04 Oct 2023 11:29:41 -0400
Message-ID: <169643338101.8035.6826446669479247727.stgit@manet.1015granger.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 drivers/infiniband/core/rw.c |    2 +-
 include/rdma/ib_verbs.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 8367974b7998..6354ddf2a274 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -666,7 +666,7 @@ void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 	factor = 1;
 
 	/*
-	 * If the devices needs MRs to perform RDMA READ or WRITE operations,
+	 * If the device needs MRs to perform RDMA READ or WRITE operations,
 	 * we'll need two additional MRs for the registrations and the
 	 * invalidation.
 	 */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 533ab92684d8..67cc6880b28b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1094,7 +1094,7 @@ struct ib_qp_cap {
 
 	/*
 	 * Maximum number of rdma_rw_ctx structures in flight at a time.
-	 * ib_create_qp() will calculate the right amount of neededed WRs
+	 * ib_create_qp() will calculate the right amount of needed WRs
 	 * and MRs based on this.
 	 */
 	u32	max_rdma_ctxs;


