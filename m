Return-Path: <SRS0=8X7E=62=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA51C54E8D
	for <linux-rdma@archiver.kernel.org>; Tue, 12 May 2020 03:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37E320757
	for <linux-rdma@archiver.kernel.org>; Tue, 12 May 2020 03:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgELDNN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 11 May 2020 23:13:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:53662 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgELDNN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 11 May 2020 23:13:13 -0400
IronPort-SDR: 8qCBViW473JDQD9VasnKZ5UIkpxMx6LHaIks6cE/yDehOG13upEgZ1BPDf9kQOdkDu39gbHzxw
 S7Kba8+Ko4lA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 20:13:13 -0700
IronPort-SDR: j4L3fUoWUpNa5HI1QuP5QuRjr4y5l5KeFe7s71IpwYhYxVFjOVhm/us8M0Dj1iJXp06GLtiqyM
 F1SAeO0ka3Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="436921157"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga005.jf.intel.com with ESMTP; 11 May 2020 20:13:12 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 04C3DBDf043342;
        Mon, 11 May 2020 20:13:11 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 04C3D96m190290;
        Mon, 11 May 2020 23:13:09 -0400
Subject: [PATCH for-rc or next 0/3] minor hfi and qib fixes
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org
Date:   Mon, 11 May 2020 23:13:09 -0400
Message-ID: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Here are three patches that fix bugs. The first two fix a problem during
device shutdown. The last patch is the result of a comment on the list
last week for a memory leak in qib.

If we are going to send another rc pull request it would be good to get
them in but not worth doing one just for these patches and they can 
just go to for-next and work their way through the stable kernels.

---

Kaike Wan (3):
      IB/hfi1: Do not destroy hfi1_wq when the device is shut down
      IB/hfi1: Do not destroy link_wq when the device is shut down
      IB/qib: Call kobject_put() when kobject_init_and_add() fails


 drivers/infiniband/hw/hfi1/init.c     |   33 ++++++++++++++++++++++++---------
 drivers/infiniband/hw/qib/qib_sysfs.c |    9 +++++----
 2 files changed, 29 insertions(+), 13 deletions(-)

--
-Denny
