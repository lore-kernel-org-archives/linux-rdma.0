Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC686C433F5
	for <linux-rdma@archiver.kernel.org>; Sat, 21 May 2022 11:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiEULMB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 21 May 2022 07:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbiEULL7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 21 May 2022 07:11:59 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A28229811;
        Sat, 21 May 2022 04:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J1A0HT4A9+XSBl1+bJCGAWkhJ4mLksjBOsLJ1lWapH8=;
  b=E900oxFFw5U5KgtQAPIqWydJb+bYQDEmKkV50GhoyfSLPckysek5Z1k2
   ZUq0yR3BOKnRpA/8/g/FH8XSqVct6wSjraWkRHK91CWGNdg2yeAOjsGh0
   9LlZVqF+L9yaBwhxnZcR3JwrusOPsYv2w40Ctq61bsO23RLhe6B5iLP/P
   M=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727891"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:52 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     kernel-janitors@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] IB/iser: fix typo in comment
Date:   Sat, 21 May 2022 13:10:14 +0200
Message-Id: <20220521111145.81697-4-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 7e4faf9c5e9e..dee8c97ff056 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -363,7 +363,7 @@ struct iser_fr_pool {
  * @cq:                  Connection completion queue
  * @cq_size:             The number of max outstanding completions
  * @device:              reference to iser device
- * @fr_pool:             connection fast registration poool
+ * @fr_pool:             connection fast registration pool
  * @pi_support:          Indicate device T10-PI support
  * @reg_cqe:             completion handler
  */

