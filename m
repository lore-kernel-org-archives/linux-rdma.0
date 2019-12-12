Return-Path: <SRS0=BWFQ=2C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFED9C43603
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 938CD24658
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576143601;
	bh=+LsPaH2jIxW7nbre660RK1jeEaE+IL/OO5bq7xQ7tO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KD05Nz07QyCiXKTheh/FtpExw0XQnuKpWheFRms+X/15+UoXcua7J8wtrLUSZnCqg
	 j6krurAyI+JmQfpddPJ0CbMfxH1BnkETw9rfK+VmpsniM4SZvmaL5UhZCcuVo7ioJa
	 SftLpfEG2tNF5UrzzaJB2BqJhayw7Bi8/NfHlqB8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfLLJkB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfLLJkA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Dec 2019 04:40:00 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADDE2173E;
        Thu, 12 Dec 2019 09:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143600;
        bh=+LsPaH2jIxW7nbre660RK1jeEaE+IL/OO5bq7xQ7tO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THKzLM/elt/AVUAfQgtXZ7jmba8rFDb5DXtmhWFs0RWYXs2w1gKW/P6d+9rxQ0iY6
         ZwcHD7Lay2FmdjV99hOi+Nq2rQ62EdQYbIKcf1Rz6sm//mQbxSaxXIP35h3kTx+gs5
         0baYv53kJODg6Xnflo8wDCmA0vsSHDFasJ0d0A1w=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-rc v2 26/48] RDMA/cm: Convert REQ RNR retry timeout counter
Date:   Thu, 12 Dec 2019 11:38:08 +0200
Message-Id: <20191212093830.316934-27-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191212093830.316934-1-leon@kernel.org>
References: <20191212093830.316934-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Convert REQ RNR retry timeout counter to new scheme.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c      |  6 +++---
 drivers/infiniband/core/cm_msgs.h | 12 ------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d7f0b929147b..549ea886f0de 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1296,7 +1296,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 		IBA_SET(CM_REQ_RESPONDED_RESOURCES, req_msg,
 		       param->responder_resources);
 		IBA_SET(CM_REQ_RETRY_COUNT, req_msg, param->retry_count);
-		cm_req_set_rnr_retry_count(req_msg, param->rnr_retry_count);
+		IBA_SET(CM_REQ_RNR_RETRY_COUNT, req_msg, param->rnr_retry_count);
 		cm_req_set_srq(req_msg, param->srq);
 	}
 
@@ -1703,7 +1703,7 @@ static void cm_format_req_event(struct cm_work *work,
 	param->remote_cm_response_timeout =
 		IBA_GET(CM_REQ_LOCAL_CM_RESPONSE_TIMEOUT, req_msg);
 	param->retry_count = IBA_GET(CM_REQ_RETRY_COUNT, req_msg);
-	param->rnr_retry_count = cm_req_get_rnr_retry_count(req_msg);
+	param->rnr_retry_count = IBA_GET(CM_REQ_RNR_RETRY_COUNT, req_msg);
 	param->srq = cm_req_get_srq(req_msg);
 	param->ppath_sgid_attr = cm_id_priv->av.ah_attr.grh.sgid_attr;
 	work->cm_event.private_data = &req_msg->private_data;
@@ -2036,7 +2036,7 @@ static int cm_req_handler(struct cm_work *work)
 	cm_id_priv->pkey = req_msg->pkey;
 	cm_id_priv->sq_psn = IBA_GET(CM_REQ_STARTING_PSN, req_msg);
 	cm_id_priv->retry_count = IBA_GET(CM_REQ_RETRY_COUNT, req_msg);
-	cm_id_priv->rnr_retry_count = cm_req_get_rnr_retry_count(req_msg);
+	cm_id_priv->rnr_retry_count = IBA_GET(CM_REQ_RNR_RETRY_COUNT, req_msg);
 	cm_id_priv->qp_type = cm_req_get_qp_type(req_msg);
 
 	cm_format_req_event(work, cm_id_priv, &listen_cm_id_priv->id);
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index dbc5acdd7a71..a754c7fa4fc0 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -70,18 +70,6 @@ struct cm_req_msg {
 
 } __packed;
 
-static inline u8 cm_req_get_rnr_retry_count(struct cm_req_msg *req_msg)
-{
-	return req_msg->offset50 & 0x7;
-}
-
-static inline void cm_req_set_rnr_retry_count(struct cm_req_msg *req_msg,
-					      u8 rnr_retry_count)
-{
-	req_msg->offset50 = (u8) ((req_msg->offset50 & 0xF8) |
-				  (rnr_retry_count & 0x7));
-}
-
 static inline u8 cm_req_get_max_cm_retries(struct cm_req_msg *req_msg)
 {
 	return req_msg->offset51 >> 4;
-- 
2.20.1

