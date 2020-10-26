Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49667C55178
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2E022281
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603718866;
	bh=BaGxlou8wCAIvs8WOUa+hIQt0xRb0OUf/kp3YJdXiNw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hpzBwbhf/leyZ24z+minL+KyXxOor5LoUHRUN20Os9MdN0oP52buzs506lHeYN3Ha
	 3UHNx0KHJC6tNQQymykN/IwnzZZ7eR7aMjIdImc45RAxtyEW9STDqSUyMZuvyEK5Ja
	 0i5BZ2RsMUu+NOBHE1EuYCm+/8QOLDZpr5mf411U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770572AbgJZN1p (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1770558AbgJZN1m (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 09:27:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D81208E4;
        Mon, 26 Oct 2020 13:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603718862;
        bh=BaGxlou8wCAIvs8WOUa+hIQt0xRb0OUf/kp3YJdXiNw=;
        h=From:To:Cc:Subject:Date:From;
        b=yJaKvws0cpwQDsoNHNvptafstF8xKicsSUWXivCDOnNBNNT91gU2+jt8WYoJ9mxzP
         b4oPcCpsIHfST2GtBCY18wTXM+QI2bBMAUSmdLKS1Bk7ANdqarDzIZar9p7Y5zU7J8
         F+iSeK9MxtATonRtZmLSGhtNaAxI0FBb7Y52sftc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-rdma@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        target-devel@vger.kernel.org
Subject: [PATCH rdma-next] IB/srpt: Fix memory leak in srpt_add_one
Date:   Mon, 26 Oct 2020 15:27:37 +0200
Message-Id: <20201026132737.1338171-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

In case srpt_refresh_port failed for the second port, then
we don't unregister the MAD agnet.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 30 ++++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0065eb17ae36..cfe38996ea91 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -619,13 +619,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	return 0;
 }
 
-/**
- * srpt_unregister_mad_agent - unregister MAD callback functions
- * @sdev: SRPT HCA pointer.
- *
- * Note: It is safe to call this function more than once for the same device.
- */
-static void srpt_unregister_mad_agent(struct srpt_device *sdev)
+static void __srpt_unregister_mad_agent(struct srpt_device *sdev, int port_cnt)
 {
 	struct ib_port_modify port_modify = {
 		.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP,
@@ -633,7 +627,10 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	struct srpt_port *sport;
 	int i;
 
-	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
+	if (!port_cnt)
+		return;
+
+	for (i = 1; i <= port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		WARN_ON(sport->port != i);
 		if (sport->mad_agent) {
@@ -644,6 +641,17 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	}
 }
 
+/**
+ * srpt_unregister_mad_agent - unregister MAD callback functions
+ * @sdev: SRPT HCA pointer.
+ *
+ * Note: It is safe to call this function more than once for the same device.
+ */
+static void srpt_unregister_mad_agent(struct srpt_device *sdev)
+{
+	__srpt_unregister_mad_agent(sdev, sdev->device->phys_port_cnt);
+}
+
 /**
  * srpt_alloc_ioctx - allocate a SRPT I/O context structure
  * @sdev: SRPT HCA pointer.
@@ -3185,7 +3193,8 @@ static int srpt_add_one(struct ib_device *device)
 		if (ret) {
 			pr_err("MAD registration failed for %s-%d.\n",
 			       dev_name(&sdev->device->dev), i);
-			goto err_event;
+			i--;
+			goto err_port;
 		}
 	}
 
@@ -3197,7 +3206,8 @@ static int srpt_add_one(struct ib_device *device)
 	pr_debug("added %s.\n", dev_name(&device->dev));
 	return 0;
 
-err_event:
+err_port:
+	__srpt_unregister_mad_agent(sdev, i);
 	ib_unregister_event_handler(&sdev->event_handler);
 err_cm:
 	if (sdev->cm_id)
-- 
2.26.2

