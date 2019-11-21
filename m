Return-Path: <SRS0=NZET=ZN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0968DC432C0
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 18:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D30206CB
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574360097;
	bh=30SzVLqrvzScTMJIRpaN7UgMLpXBcNAOjRTRVlvaPS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZEn3kHUcEZvWbZ5EwqB5+t7KkU5kQWRg32TS/ZrUW6kHop0pma12FaHyluj9BVS2x
	 V+vXx1kZ8zLFkY0lqbJZcvVbY4BzGZ5rWjrjAZd4WjmSl63EWUhKxuCljd9MsVHjTt
	 Ejb1h1IA46h3k/bo8ZI3wmiDa9+CxCjOVNZD17+Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKUSO5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 21 Nov 2019 13:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKUSO5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 21 Nov 2019 13:14:57 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25102068E;
        Thu, 21 Nov 2019 18:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574360096;
        bh=30SzVLqrvzScTMJIRpaN7UgMLpXBcNAOjRTRVlvaPS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWS/+arUEJ1ujgHsc8uIUaNj9ArstoWtBtxIyc1b6AGbBzuogPk6Puc6+3lRL6433
         xWT41QHsq5NmLgZTPA5vqHT/7s5/Ow7p2v7GfMul02V5rYfgAgnxsFXZXQ3Ce6rwSv
         svqWouQBSgg06S88aC3w0EASx8D6463sMBgiXgjI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-next v1 28/48] RDMA/cm: Convert REQ SRQ field
Date:   Thu, 21 Nov 2019 20:12:53 +0200
Message-Id: <20191121181313.129430-29-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121181313.129430-1-leon@kernel.org>
References: <20191121181313.129430-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Convert REQ SRQ field to new scheme.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c      |  4 ++--
 drivers/infiniband/core/cm_msgs.h | 11 -----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1b0cdaea035e..673ff1da05bd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1297,7 +1297,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 		       param->responder_resources);
 		IBA_SET(CM_REQ_RETRY_COUNT, req_msg, param->retry_count);
 		IBA_SET(CM_REQ_RNR_RETRY_COUNT, req_msg, param->rnr_retry_count);
-		cm_req_set_srq(req_msg, param->srq);
+		IBA_SET(CM_REQ_SRQ, req_msg, param->srq);
 	}
 
 	req_msg->primary_local_gid = pri_path->sgid;
@@ -1704,7 +1704,7 @@ static void cm_format_req_event(struct cm_work *work,
 		IBA_GET(CM_REQ_LOCAL_CM_RESPONSE_TIMEOUT, req_msg);
 	param->retry_count = IBA_GET(CM_REQ_RETRY_COUNT, req_msg);
 	param->rnr_retry_count = IBA_GET(CM_REQ_RNR_RETRY_COUNT, req_msg);
-	param->srq = cm_req_get_srq(req_msg);
+	param->srq = IBA_GET(CM_REQ_SRQ, req_msg);
 	param->ppath_sgid_attr = cm_id_priv->av.ah_attr.grh.sgid_attr;
 	work->cm_event.private_data = &req_msg->private_data;
 	work->cm_event.private_data_len = CM_REQ_PRIVATE_DATA_SIZE;
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index 54573280652a..23a48211d15e 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -70,17 +70,6 @@ struct cm_req_msg {
 
 } __packed;
 
-static inline u8 cm_req_get_srq(struct cm_req_msg *req_msg)
-{
-	return (req_msg->offset51 & 0x8) >> 3;
-}
-
-static inline void cm_req_set_srq(struct cm_req_msg *req_msg, u8 srq)
-{
-	req_msg->offset51 = (u8) ((req_msg->offset51 & 0xF7) |
-				  ((srq & 0x1) << 3));
-}
-
 static inline __be32 cm_req_get_primary_flow_label(struct cm_req_msg *req_msg)
 {
 	return cpu_to_be32(be32_to_cpu(req_msg->primary_offset88) >> 12);
-- 
2.20.1

