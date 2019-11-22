Return-Path: <SRS0=yC1B=ZO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D84C432C3
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 05:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B297220672
	for <linux-rdma@archiver.kernel.org>; Fri, 22 Nov 2019 05:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574402045;
	bh=XixCqk5Dctp3gu17mdUdZfPgqxJFaELcs0HpON1q1h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QhAkjGBU44XY2Fprl98Bbow/wtHDRsMo5d5BWMvz3LsJ/4QOUpKOu0aCaEn947o7l
	 QhS6MwChGSzagA9RH+F6XlZAE8sUoK1wRoQoMmHSxr3FyYau+gXAqdj3C7YqDJpu9n
	 9J+WlX9TQBwhUJdWGocRaw6K/F3dZBVXdnQQsaF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfKVFxR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbfKVFxP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D38C12082F;
        Fri, 22 Nov 2019 05:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401994;
        bh=XixCqk5Dctp3gu17mdUdZfPgqxJFaELcs0HpON1q1h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Urk9/6Bmg5HSJVE4IpPkL5G4YH+O0r4rqtb2EpDVh9LibeBk0x2Rt4WXtmn48qPLe
         qdaJRH0MyHf+EH/7p5gLC0+AQ7Yj1acBWLSnR6gUsBrmXWFSoLtbzQRwzQJnnr1LWZ
         C545Ph9qNi/x+Vlwz6kEN+ZchaPtll8ypq+mrFSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 212/219] RDMA/hns: Bugfix for the scene without receiver queue
Date:   Fri, 22 Nov 2019 00:49:03 -0500
Message-Id: <20191122054911.1750-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 4d103905eb1e4f14cb62fcf962c9d35da7005dea ]

In some application scenario, the user could not have receive queue when
run rdma write or read operation.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 2fa4fb17f6d3c..44729ae5f11cd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -503,7 +503,8 @@ static int hns_roce_qp_has_sq(struct ib_qp_init_attr *attr)
 static int hns_roce_qp_has_rq(struct ib_qp_init_attr *attr)
 {
 	if (attr->qp_type == IB_QPT_XRC_INI ||
-	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq)
+	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq ||
+	    !attr->cap.max_recv_wr)
 		return 0;
 
 	return 1;
-- 
2.20.1

