Return-Path: <SRS0=aLju=C3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C66C43464
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BCD23730
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Sep 2020 02:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600396639;
	bh=fO1WEb94QCbDjhfkjOsJon78TmvGQdqcmX/unoJm1l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jOKRdEbTNaUxLjvSFCg3vn1RXmZfIPAw2j4IrALxbDKjmDstiC4tzZkfdiAAGRGf+
	 zLUlZakAkI6HFYdjzRYdPpLyMvnRF4HtdP2gP7j3Am00+q8NVqy0y/99MWb0nvCap+
	 +7Lt4H4H0DXIY8mh/pnFAtIkP2g/pEN2cCVjkahw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgIRChG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbgIRCMl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424C0235FC;
        Fri, 18 Sep 2020 02:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395160;
        bh=fO1WEb94QCbDjhfkjOsJon78TmvGQdqcmX/unoJm1l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOISsC8ZK264m8f/YxNB5m1Mdvd5EU2874wVb3oIg3xHPXqkezlD8c6+hbT5iCpNQ
         20XQYvp4h8NtX+cQjxK+zLbo4gABh2gc7yV7bHz8R2MB4oP1OgNXoyEp8mkQRkChNB
         q1smslNIg3wTP6a5WaFcr0bVg8LcGh7op915X9rc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 018/127] RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'
Date:   Thu, 17 Sep 2020 22:10:31 -0400
Message-Id: <20200918021220.2066485-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9067f2f0b41d7e817fc8c5259bab1f17512b0147 ]

We should jump to fail3 in order to undo the 'xa_insert_irq()' call.

Link: https://lore.kernel.org/r/20190923190746.10964-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 7eb1cc1b1aa04..5aa545f9a4232 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3265,7 +3265,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		if (raddr->sin_addr.s_addr == htonl(INADDR_ANY)) {
 			err = pick_local_ipaddrs(dev, cm_id);
 			if (err)
-				goto fail2;
+				goto fail3;
 		}
 
 		/* find a route */
@@ -3287,7 +3287,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		if (ipv6_addr_type(&raddr6->sin6_addr) == IPV6_ADDR_ANY) {
 			err = pick_local_ip6addrs(dev, cm_id);
 			if (err)
-				goto fail2;
+				goto fail3;
 		}
 
 		/* find a route */
-- 
2.25.1

