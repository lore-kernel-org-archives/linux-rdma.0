Return-Path: <SRS0=gcIT=EJ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F75C2D0A3
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Nov 2020 11:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE7AD206C0
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Nov 2020 11:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgKCLqL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 3 Nov 2020 06:46:11 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7411 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgKCLqL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 3 Nov 2020 06:46:11 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CQSfP1fFFz71yY;
        Tue,  3 Nov 2020 19:46:05 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 3 Nov 2020 19:45:58 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <sagi@grimberg.me>, <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] IB/isert: Fix warning Comparison to bool
Date:   Tue, 3 Nov 2020 19:57:54 +0800
Message-ID: <1604404674-32998-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix below warning reported by coccicheck:

./ib_isert.c:1104:12-24: WARNING: Comparison to bool

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index bd47894..e47cd02 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1101,7 +1101,7 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 sequence_cmd:
 	rc = iscsit_sequence_cmd(conn, cmd, buf, hdr->cmdsn);
 
-	if (!rc && dump_payload == false && unsol_data)
+	if (!rc && !dump_payload && unsol_data)
 		iscsit_set_unsolicited_dataout(cmd);
 	else if (dump_payload && imm_data)
 		target_put_sess_cmd(&cmd->se_cmd);
-- 
2.6.2

