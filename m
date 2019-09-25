Return-Path: <SRS0=78Cs=XU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CF1C4360C
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Sep 2019 16:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC6921D79
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Sep 2019 16:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391996AbfIYQpp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:45:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:8827 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390600AbfIYQpo (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 25 Sep 2019 12:45:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 09:45:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="191395571"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.122.128.45])
  by orsmga003.jf.intel.com with ESMTP; 25 Sep 2019 09:45:41 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        "Shiraz, Saleem" <shiraz.saleem@intel.com>
Subject: [PATCH for-5.4] RDMA/i40iw: Associate ibdev to netdev before IB device registration
Date:   Wed, 25 Sep 2019 11:45:24 -0500
Message-Id: <20190925164524.856-1-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: "Shiraz, Saleem" <shiraz.saleem@intel.com>

i40iw IB device registration fails with ENODEV.

ib_register_device
 setup_device/setup_port_data
  i40iw_port_immutable
   ib_query_port
     iw_query_port
      ib_device_get_netdev(ENODEV)

ib_device_get_netdev() does not have a netdev associated
with the ibdev and thus fails.
Use ib_device_set_netdev() to associate netdev to ibdev
in i40iw before IB device registration.

Fixes: 4929116bdf72 ("RDMA/core: Add common iWARP query port")
Signed-off-by: Shiraz, Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 8056930..cd9ee166 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2773,6 +2773,10 @@ int i40iw_register_rdma_device(struct i40iw_device *iwdev)
 		return -ENOMEM;
 	iwibdev = iwdev->iwibdev;
 	rdma_set_device_sysfs_group(&iwibdev->ibdev, &i40iw_attr_group);
+	ret = ib_device_set_netdev(&iwibdev->ibdev, iwdev->netdev, 1);
+	if (ret)
+		goto error;
+
 	ret = ib_register_device(&iwibdev->ibdev, "i40iw%d");
 	if (ret)
 		goto error;
-- 
1.8.3.1

