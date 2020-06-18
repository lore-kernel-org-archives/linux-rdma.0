Return-Path: <SRS0=pTjR=77=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30293C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062F92089D
	for <linux-rdma@archiver.kernel.org>; Thu, 18 Jun 2020 02:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592448642;
	bh=lcXH754V5IhHALelKisHGDlzXD3vCcHPDVCwl7AHQoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vq6kVSNgsH58V4Yt1OKKN5ljduNbsbgwnnmtVLKZoWEn62qxCDJhHL1Jn4wqjQybo
	 AjOVn0pr553QFWq60RHkNx6oiwqECi6/OgOTe2mq8par4QmqKGq4I+QFuzkXG3u8nl
	 prKIS7OeI6sQDBLJfVaMPNNm8vBQNfdf/EQr1R/0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgFRCug (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgFRBJO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECA121D7B;
        Thu, 18 Jun 2020 01:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442553;
        bh=lcXH754V5IhHALelKisHGDlzXD3vCcHPDVCwl7AHQoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNJOh01b9YHcHt03ZBCa3VJKu1776XRQNoNlj2PkdEC1okw9wNCKElYsiBOC8cx0u
         qzEUblWOaKfxhQxgc6i6E2UWcv0vxczla+f9W/m+HVlqMUDDUzEuW3I4u3M9GcacRq
         K7ncXV8GsPU2/lGghDkQ3HST7gdkPvi6fbF0U2qA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 051/388] RDMA/uverbs: Fix create WQ to use the given user handle
Date:   Wed, 17 Jun 2020 21:02:28 -0400
Message-Id: <20200618010805.600873-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

[ Upstream commit dbd67252869ba58d086edfa14113e10f8059b97e ]

Fix create WQ to use the given user handle, in addition dropped some
duplicated code from this flow.

Fixes: fd3c7904db6e ("IB/core: Change idr objects to use the new schema")
Fixes: f213c0527210 ("IB/uverbs: Add WQ support")
Link: https://lore.kernel.org/r/20200506082444.14502-9-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 060b4ebbd2ba..d6e9cc94dd90 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2959,6 +2959,7 @@ static int ib_uverbs_ex_create_wq(struct uverbs_attr_bundle *attrs)
 	wq_init_attr.event_handler = ib_uverbs_wq_event_handler;
 	wq_init_attr.create_flags = cmd.create_flags;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
+	obj->uevent.uobject.user_handle = cmd.user_handle;
 
 	wq = pd->device->ops.create_wq(pd, &wq_init_attr, &attrs->driver_udata);
 	if (IS_ERR(wq)) {
@@ -2976,8 +2977,6 @@ static int ib_uverbs_ex_create_wq(struct uverbs_attr_bundle *attrs)
 	atomic_set(&wq->usecnt, 0);
 	atomic_inc(&pd->usecnt);
 	atomic_inc(&cq->usecnt);
-	wq->uobject = obj;
-	obj->uevent.uobject.object = wq;
 
 	memset(&resp, 0, sizeof(resp));
 	resp.wq_handle = obj->uevent.uobject.id;
-- 
2.25.1

