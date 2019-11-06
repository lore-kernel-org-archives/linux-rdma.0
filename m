Return-Path: <SRS0=/r8L=Y6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8254EC5DF62
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 06:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 362E52173E
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 06:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="S314PZdg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbfKFG7f (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 6 Nov 2019 01:59:35 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:48246 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfKFG7f (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 6 Nov 2019 01:59:35 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2019 01:59:34 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=6VwGQ5l/KHaUkHzUwx
        fxyN0z/nNADVZmGBoR+CEIEok=; b=S314PZdgSxxGR3mxVByXgpZfccNhpoo0DT
        nxsXiDOmN2lINO82O10eLehUm2I2o74zl7cY7+c6wHnrlDlyMBo75FilcW3CDj5P
        KtQINWtlF2DdjK7OISHmNZwO/lLIlXX3DAJplpZ/g/Y0dHpvFgfwpyTrKi6EPhkj
        fNuvrYueQ=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp5 (Coremail) with SMTP id HdxpCgAnI128a8Jd9n5eKA--.114S3;
        Wed, 06 Nov 2019 14:44:22 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Faisal Latif <faisal.latif@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] RDMA/i40iw: fix potential use after free
Date:   Wed,  6 Nov 2019 14:44:11 +0800
Message-Id: <1573022651-37171-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: HdxpCgAnI128a8Jd9n5eKA--.114S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF1kXr1UKFy8ArykGFW3Wrg_yoW3trgEya
        12g3WxWr15Cr17Wr45ArnxZFy2krWqga1Fvw4ktFn3JryYg3Z8C395CF1ru393Xr1xKrZx
        W348Gr18CF4rGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU14v37UUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiDg9lclXluaIe5wACsG
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Release variable dst after logging dst->error to avoid possible use after
free.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 2d6a378e8560..bb78d3280acc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2079,9 +2079,9 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 	dst = i40iw_get_dst_ipv6(&src_addr, &dst_addr);
 	if (!dst || dst->error) {
 		if (dst) {
-			dst_release(dst);
 			i40iw_pr_err("ip6_route_output returned dst->error = %d\n",
 				     dst->error);
+			dst_release(dst);
 		}
 		return rc;
 	}
-- 
2.7.4

