Return-Path: <SRS0=8+f9=6E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E4FC3A5A0
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 14:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B293B20722
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587391641;
	bh=PxpIcf6TtHcXeyyFQPg+9e8Sw7BuqXxY6qCzXuhfY4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gtBOiITl34+jI9StQ4Dp+/9X2tUXgBTR7sP/ekvTOfPyP8j0t0y2nKmFu70a9C8Hk
	 TTuUARnm66Y7WGTms7dcjDVjgJYsfk7VLdzZPq90y6/RmNgpG/r2KLSZgV5/c1v87W
	 Al2+evyBc5K5lO5SMEBj9Hf12edXLym/9Rmcvnz0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgDTOHV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:32904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbgDTOHV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 20 Apr 2020 10:07:21 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76DF2214AF;
        Mon, 20 Apr 2020 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587391640;
        bh=PxpIcf6TtHcXeyyFQPg+9e8Sw7BuqXxY6qCzXuhfY4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7zTNaZxk1oI32YhaZD4GjG+dw0euOCS0kxMJeZsF0VrJosebgmSjTUwJ2LwTLPl+
         BcGL3yy2C4GbhF++ftxked3M0k4SpYdWfMvxdTtrvr/JQd7Y7AEeH7QUBAYR0JGVp3
         lFQ8unhp1VKgQqe00Z4QpUrlC0uzBleL/OxDLxX0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-core 08/12] librdmacm: Add an option to reject ECE request
Date:   Mon, 20 Apr 2020 17:06:44 +0300
Message-Id: <20200420140648.275554-9-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420140648.275554-1-leon@kernel.org>
References: <20200420140648.275554-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

IBTA has specific rejected reason for users who doesn't
want proposed ECE options in request messages. Provide special
version (rdma_reject_ece) to mark such rejects.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 debian/librdmacm1.symbols |  1 +
 librdmacm/cma.c           | 19 +++++++++++++++++--
 librdmacm/librdmacm.map   |  1 +
 librdmacm/rdma_cma.h      |  8 ++++++++
 librdmacm/rdma_cma_abi.h  |  7 ++++++-
 5 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/debian/librdmacm1.symbols b/debian/librdmacm1.symbols
index cc4d7a6c..ce5ffd20 100644
--- a/debian/librdmacm1.symbols
+++ b/debian/librdmacm1.symbols
@@ -44,6 +44,7 @@ librdmacm.so.1 librdmacm1 #MINVER#
  rdma_migrate_id@RDMACM_1.0 1.0.15
  rdma_notify@RDMACM_1.0 1.0.15
  rdma_reject@RDMACM_1.0 1.0.15
+ rdma_reject_ece@RDMACM_1.3 28
  rdma_resolve_addr@RDMACM_1.0 1.0.15
  rdma_resolve_route@RDMACM_1.0 1.0.15
  rdma_set_local_ece@RDMACM_1.3 28
diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 3c356eca..fc6e6a89 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -1731,8 +1731,9 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	return ucma_complete(id);
 }

-int rdma_reject(struct rdma_cm_id *id, const void *private_data,
-		uint8_t private_data_len)
+static int reject_with_reason(struct rdma_cm_id *id, const void *private_data,
+			      uint8_t private_data_len,
+			      enum ucm_abi_reject_reason reason)
 {
 	struct ucma_abi_reject cmd;
 	struct cma_id_private *id_priv;
@@ -1746,6 +1747,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 		memcpy(cmd.private_data, private_data, private_data_len);
 		cmd.private_data_len = private_data_len;
 	}
+	cmd.reason = reason;

 	ret = write(id->channel->fd, &cmd, sizeof cmd);
 	if (ret != sizeof cmd)
@@ -1754,6 +1756,19 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 	return 0;
 }

+int rdma_reject(struct rdma_cm_id *id, const void *private_data,
+		uint8_t private_data_len)
+{
+	return reject_with_reason(id, private_data, private_data_len, 0);
+}
+
+int rdma_reject_ece(struct rdma_cm_id *id, const void *private_data,
+		    uint8_t private_data_len)
+{
+	return reject_with_reason(id, private_data, private_data_len,
+				  RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED);
+}
+
 int rdma_notify(struct rdma_cm_id *id, enum ibv_event_type event)
 {
 	struct ucma_abi_notify cmd;
diff --git a/librdmacm/librdmacm.map b/librdmacm/librdmacm.map
index f29a23b4..d162ef09 100644
--- a/librdmacm/librdmacm.map
+++ b/librdmacm/librdmacm.map
@@ -86,5 +86,6 @@ RDMACM_1.2 {
 RDMACM_1.3 {
 	global:
 		rdma_get_remote_ece;
+		rdma_reject_ece;
 		rdma_set_local_ece;
 } RDMACM_1.2;
diff --git a/librdmacm/rdma_cma.h b/librdmacm/rdma_cma.h
index c42a28f7..e1f4e236 100644
--- a/librdmacm/rdma_cma.h
+++ b/librdmacm/rdma_cma.h
@@ -524,6 +524,14 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param);
 int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 		uint8_t private_data_len);

+/**
+ * rdma_reject_ece - Called to reject a connection request with ECE
+ * rejected reason.
+ * The same as rdma_reject()
+ */
+int rdma_reject_ece(struct rdma_cm_id *id, const void *private_data,
+		uint8_t private_data_len);
+
 /**
  * rdma_notify - Notifies the librdmacm of an asynchronous event.
  * @id: RDMA identifier.
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index 4639941b..911863cc 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -73,6 +73,10 @@ enum {
 	UCMA_CMD_JOIN_MCAST
 };

+enum ucm_abi_reject_reason {
+	RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED = 35
+};
+
 struct ucma_abi_cmd_hdr {
 	__u32 cmd;
 	__u16 in;
@@ -263,7 +267,8 @@ struct ucma_abi_reject {
 	__u16 out;
 	__u32 id;
 	__u8  private_data_len;
-	__u8  reserved[3];
+	__u8  reason; /* enum ucm_abi_reject_reason */
+	__u8  reserved[2];
 	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
 };

--
2.25.2

