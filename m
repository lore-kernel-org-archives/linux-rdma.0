Return-Path: <SRS0=8+f9=6E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805BFC3A5A0
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 14:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DA99214AF
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Apr 2020 14:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587391637;
	bh=H0n5ezBqxTQpND5weUH6wjdwuBynsEaenbcmn4i58fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1MALYstk1uBFLO/jmKK4GD095nZStNf1Wuohf4rkpQF6xPhoNUCnUN/63goqEK9ir
	 TlG80X/ExBkQqOo3qYERxLM5Z6cRo9YAAbir78LcDmZ0EGBV7p4ny6gstX/sPBiP2L
	 8pt8zykS0MoZl+A8JOPlJ5wEyMwxF0uonCM6Gfng=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgDTOHQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbgDTOHQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 20 Apr 2020 10:07:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C94120722;
        Mon, 20 Apr 2020 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587391636;
        bh=H0n5ezBqxTQpND5weUH6wjdwuBynsEaenbcmn4i58fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWNcXT29uumz6znSojHzu9VRxSh2Tj1IdKuk+i+gF1Ld0XH6ou3v5I2E2JuCT5MLF
         AFtds3wCzk78M/jMRhvZ3UNYYbcUUSX6Y8PlO+h9aWLp9drrCPsA8PeN2li6vAnSR2
         eXGq1ANG01BC0YGEEIUCdeMhFovjFSHhkHnTqLW8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-core 07/12] librdmacm: Return ECE results through rdma_accept
Date:   Mon, 20 Apr 2020 17:06:43 +0300
Message-Id: <20200420140648.275554-8-leon@kernel.org>
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

Passive side (server) returns its answer through REP message,
which is constructed as a result of rdma_accept().

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 librdmacm/cma.c          | 9 +++++++++
 librdmacm/rdma_cma_abi.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 91735225..3c356eca 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -1668,6 +1668,14 @@ err:
 	return ret;
 }

+static void ucma_copy_ece_param_to_kern_rep(struct cma_id_private *id_priv,
+					    struct ucma_abi_ece *dst)
+{
+	/* Return result with same ID as received. */
+	dst->vendor_id = id_priv->remote_ece.vendor_id;
+	dst->attr_mod = id_priv->local_ece.options;
+}
+
 int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
 	uint32_t qp_num = id->qp ? id->qp->qp_num : conn_param->qp_num;
@@ -1709,6 +1717,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	cmd.uid = (uintptr_t) id_priv;
 	ucma_copy_conn_param_to_kern(id_priv, &cmd.conn_param, conn_param,
 				     qp_num, srq);
+	ucma_copy_ece_param_to_kern_rep(id_priv, &cmd.ece);

 	ret = write(id->channel->fd, &cmd, sizeof cmd);
 	if (ret != sizeof cmd) {
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index 6451862e..4639941b 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -254,6 +254,7 @@ struct ucma_abi_accept {
 	struct ucma_abi_conn_param conn_param;
 	__u32 id;
 	__u32 reserved;
+	struct ucma_abi_ece ece;
 };

 struct ucma_abi_reject {
--
2.25.2

