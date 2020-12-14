Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A6BC2BB40
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Dec 2020 13:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCDA22A84
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Dec 2020 13:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbgLNNmO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Dec 2020 08:42:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9202 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406675AbgLNNmE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 14 Dec 2020 08:42:04 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CvjFb1l3bzkqyJ;
        Mon, 14 Dec 2020 21:40:35 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 14 Dec 2020 21:41:15 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] ulp/opa_vnic/opa_vnic_vema: convert comma to semicolon
Date:   Mon, 14 Dec 2020 21:41:46 +0800
Message-ID: <20201214134146.4456-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 4933085a864a..cecf0f7cadf9 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -233,7 +233,7 @@ static void vema_get_class_port_info(struct opa_vnic_vema_port *port,
 
 	port_info = (struct opa_class_port_info *)rsp_mad->data;
 	memcpy(port_info, &port->class_port_info, sizeof(*port_info));
-	port_info->base_version = OPA_MGMT_BASE_VERSION,
+	port_info->base_version = OPA_MGMT_BASE_VERSION;
 	port_info->class_version = OPA_EMA_CLASS_VERSION;
 
 	/*
-- 
2.22.0

