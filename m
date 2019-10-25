Return-Path: <SRS0=Cj4f=YS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBCECA9EBE
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Oct 2019 19:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 820B121D71
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Oct 2019 19:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfJYT61 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:58:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:34308 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfJYT61 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 25 Oct 2019 15:58:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 12:58:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="192641465"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2019 12:58:21 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x9PJwJ5d024299;
        Fri, 25 Oct 2019 12:58:20 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x9PJwHEF111946;
        Fri, 25 Oct 2019 15:58:17 -0400
Subject: [PATCH for-rc 0/4] Few more rc fixes
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org
Date:   Fri, 25 Oct 2019 15:58:17 -0400
Message-ID: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Here we have 4 more bug fixing patches. These are all marked stable as well so
it would be good to get these in to 5.4 if possible.

The allow for speeds patch is not a "feature" it is a bug that causes problems
if the host comes up in gen4. Is very small. The other 3 from Kaike fix TID RDMA
bugs. A few more lines of code here but all relegated to TID RDMA.

---

James Erwin (1):
      IB/hfi1: Allow for all speeds higher than gen3

Kaike Wan (3):
      IB/hfi1: Ensure r_tid_ack is valid before building TID RDMA ACK packet
      IB/hfi1: Calculate flow weight based on QP MTU for TID RDMA
      IB/hfi1: TID RDMA WRITE should not return IB_WC_RNR_RETRY_EXC_ERR


 drivers/infiniband/hw/hfi1/init.c     |    1 -
 drivers/infiniband/hw/hfi1/pcie.c     |    4 ++
 drivers/infiniband/hw/hfi1/rc.c       |   16 +++++----
 drivers/infiniband/hw/hfi1/tid_rdma.c |   57 +++++++++++++++++++--------------
 drivers/infiniband/hw/hfi1/tid_rdma.h |    3 +-
 5 files changed, 44 insertions(+), 37 deletions(-)

--
-Denny
