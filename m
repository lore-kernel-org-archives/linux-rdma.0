Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69082C2D0E4
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Nov 2020 10:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1675923A32
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Nov 2020 10:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="RmfJvGZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKOKeN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 15 Nov 2020 05:34:13 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:60475 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKOKeM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 15 Nov 2020 05:34:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605436453; x=1636972453;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4Ne5/a94BmoMFZV40fDneeH74q15SgdCOR21CAz3cMw=;
  b=RmfJvGZ0JnjS2GjxkhZ1AohvvEeLZPPPCqhi++latvwpWzg51Fkt6QKN
   KIBdtB3BzXd8MBxEL58+kP1a5JZAKbaQCq8Qrm00j6UgwXiC6A24IAuXr
   itSKVgl0uDF8L1pT3X+lVLdgmsTNbRPShLIvXXCm7zpCAAoVOiPPee2z4
   M=;
X-IronPort-AV: E=Sophos;i="5.77,480,1596499200"; 
   d="scan'208";a="65065439"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 15 Nov 2020 10:34:12 +0000
Received: from EX13D19EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 31D42A17C5;
        Sun, 15 Nov 2020 10:34:11 +0000 (UTC)
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D19EUA003.ant.amazon.com (10.43.165.175) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 15 Nov 2020 10:34:09 +0000
Received: from 8c85908914bf.ant.amazon.com (10.1.212.17) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 15 Nov 2020 10:34:06 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, Gal Pressman <galpress@amazon.com>
Subject: [PATCH for-next 0/2] create_user_ah introduction fixups
Date:   Sun, 15 Nov 2020 12:34:01 +0200
Message-ID: <20201115103404.48829-1-galpress@amazon.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The first patch fixes the create_ah NULL check to only happen in case of
kernel AH (!udata).
The second patch removes the create_ah callback from EFA as it does not
support kverbs.

Thanks,
Gal

Gal Pressman (2):
  RDMA/core: Check .create_ah is not NULL only in case it's needed
  RDMA/efa: Remove .create_ah callback assignment

 drivers/infiniband/core/verbs.c      | 2 +-
 drivers/infiniband/hw/efa/efa_main.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
2.29.2

