Return-Path: <SRS0=BWFQ=2C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA60C43603
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB5C2465A
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576143620;
	bh=1MUaeCQCqDeb3pyieL5IHACYtN3paRyQK9IRSQC418I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fLP0nvy9ZVnbdVqIvKw7zYCnAQmFrgCgQZx6NVv+BK6/pLnquF6X2oj7XMKUu0irP
	 Nbq9ttTbvhkX4ArPFu7KIL2FmGmCAfJjtnsXrnkFez9boOLzLbZY8TjhC3XtRW0Ip/
	 dyFOQ10xNiCgjGwIaxCY5BibRqQZvlY+LqjFTt98=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfLLJkU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfLLJkU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Dec 2019 04:40:20 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905AA2173E;
        Thu, 12 Dec 2019 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143619;
        bh=1MUaeCQCqDeb3pyieL5IHACYtN3paRyQK9IRSQC418I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYDbJEse9Eyy8DlNZzQ5qjYH7axDeOIti66EJEz0s3dgHrHHxW8f99q/McTmwzWeo
         1sEC+26JNre2P7Zqb/j9AoZ0v1cHOxUqXMzTdkxJ5pXE3r7MGC/EOTKXBq1ozy3s5v
         EOd6bv/uKyI+4N6bbuCF2cCyD4vCbU8WSDtr8xD8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-rc v2 32/48] RDMA/cm: Convert REQ subnet local fields
Date:   Thu, 12 Dec 2019 11:38:14 +0200
Message-Id: <20191212093830.316934-33-leon@kernel.org>
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

Convert REQ subnet local fields.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c      |  9 +++++----
 drivers/infiniband/core/cm_msgs.h | 24 ------------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index b6da28d43b46..1a5d5d401c72 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1324,7 +1324,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 	req_msg->primary_traffic_class = pri_path->traffic_class;
 	req_msg->primary_hop_limit = pri_path->hop_limit;
 	IBA_SET(CM_REQ_PRIMARY_SL, req_msg, pri_path->sl);
-	cm_req_set_primary_subnet_local(req_msg, (pri_path->hop_limit <= 1));
+	IBA_SET(CM_REQ_PRIMARY_SUBNET_LOCAL, req_msg, (pri_path->hop_limit <= 1));
 	cm_req_set_primary_local_ack_timeout(req_msg,
 		cm_ack_timeout(cm_id_priv->av.port->cm_dev->ack_delay,
 			       pri_path->packet_life_time));
@@ -1359,7 +1359,8 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 		req_msg->alt_traffic_class = alt_path->traffic_class;
 		req_msg->alt_hop_limit = alt_path->hop_limit;
 		IBA_SET(CM_REQ_ALTERNATE_SL, req_msg, alt_path->sl);
-		cm_req_set_alt_subnet_local(req_msg, (alt_path->hop_limit <= 1));
+		IBA_SET(CM_REQ_ALTERNATE_SUBNET_LOCAL, req_msg,
+			(alt_path->hop_limit <= 1));
 		cm_req_set_alt_local_ack_timeout(req_msg,
 			cm_ack_timeout(cm_id_priv->av.port->cm_dev->ack_delay,
 				       alt_path->packet_life_time));
@@ -1907,7 +1908,7 @@ static struct cm_id_private * cm_match_req(struct cm_work *work,
  */
 static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
 {
-	if (!cm_req_get_primary_subnet_local(req_msg)) {
+	if (!IBA_GET(CM_REQ_PRIMARY_SUBNET_LOCAL, req_msg)) {
 		if (req_msg->primary_local_lid == IB_LID_PERMISSIVE) {
 			req_msg->primary_local_lid = ib_lid_be16(wc->slid);
 			IBA_SET(CM_REQ_PRIMARY_SL, req_msg, wc->sl);
@@ -1917,7 +1918,7 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
 			req_msg->primary_remote_lid = cpu_to_be16(wc->dlid_path_bits);
 	}
 
-	if (!cm_req_get_alt_subnet_local(req_msg)) {
+	if (!IBA_GET(CM_REQ_ALTERNATE_SUBNET_LOCAL, req_msg)) {
 		if (req_msg->alt_local_lid == IB_LID_PERMISSIVE) {
 			req_msg->alt_local_lid = ib_lid_be16(wc->slid);
 			IBA_SET(CM_REQ_ALTERNATE_SL, req_msg, wc->sl);
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index b82eb10e22f6..3933c29b569b 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -70,18 +70,6 @@ struct cm_req_msg {
 
 } __packed;
 
-static inline u8 cm_req_get_primary_subnet_local(struct cm_req_msg *req_msg)
-{
-	return (u8) ((req_msg->primary_offset94 & 0x08) >> 3);
-}
-
-static inline void cm_req_set_primary_subnet_local(struct cm_req_msg *req_msg,
-						   u8 subnet_local)
-{
-	req_msg->primary_offset94 = (u8) ((req_msg->primary_offset94 & 0xF7) |
-					  ((subnet_local & 0x1) << 3));
-}
-
 static inline u8 cm_req_get_primary_local_ack_timeout(struct cm_req_msg *req_msg)
 {
 	return (u8) (req_msg->primary_offset95 >> 3);
@@ -94,18 +82,6 @@ static inline void cm_req_set_primary_local_ack_timeout(struct cm_req_msg *req_m
 					  (local_ack_timeout << 3));
 }
 
-static inline u8 cm_req_get_alt_subnet_local(struct cm_req_msg *req_msg)
-{
-	return (u8) ((req_msg->alt_offset138 & 0x08) >> 3);
-}
-
-static inline void cm_req_set_alt_subnet_local(struct cm_req_msg *req_msg,
-					       u8 subnet_local)
-{
-	req_msg->alt_offset138 = (u8) ((req_msg->alt_offset138 & 0xF7) |
-				       ((subnet_local & 0x1) << 3));
-}
-
 static inline u8 cm_req_get_alt_local_ack_timeout(struct cm_req_msg *req_msg)
 {
 	return (u8) (req_msg->alt_offset139 >> 3);
-- 
2.20.1

