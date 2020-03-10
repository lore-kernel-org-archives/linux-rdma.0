Return-Path: <SRS0=u98Z=43=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF2EC10F27
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 09:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 780FF2467F
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 09:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583831716;
	bh=kQX+tjTfhAzxpKLGh/hc6MApJ2s0Xzf/OgSzIAmQHkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Gnxw9YY72KQl55ko37bO3os8uhuHQdQe2z7QOE9hMLPPxY8D6x3LnQ9Zc68r8O9Ch
	 89smIYJFJ/bDeFdxhCwoUtbgJ0u2ArGE6go71sI3nR4F8IZybQkvm9NEmsyZ5A3IsB
	 wgm0ZWi6baxKJPJ04N8teArE5Ntk+whI8x6GFrc4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgCJJPQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgCJJPP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Mar 2020 05:15:15 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C335024681;
        Tue, 10 Mar 2020 09:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583831715;
        bh=kQX+tjTfhAzxpKLGh/hc6MApJ2s0Xzf/OgSzIAmQHkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPux+VH8ZUhmq1NTIQVDYAHNIn6nYXtJGz1Gflec+Ks96HnjVPofb1hrVOS0dV8vW
         mmlzR6zYqcfyBrMNih5lfOWMc48+gwosDmWNzvrdfvnU/Z3ta1/oZf018XHby0r5mP
         3WsCbEP88cUZwrQhw0gJflAF0Rb+wyXCaUd5pP8M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v1 06/11] RDMA/uapi: Add ECE definitions to UCMA
Date:   Tue, 10 Mar 2020 11:14:33 +0200
Message-Id: <20200310091438.248429-7-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310091438.248429-1-leon@kernel.org>
References: <20200310091438.248429-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

ECE parameters are used to perform handshake between different
CMID nodes in order to allow extra connection setup supported
by those two nodes. The data is provided by rdma_connect()
for the client and rdma_get_events() for the server.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/uapi/rdma/rdma_user_cm.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index e42940a215a3..150b3f075f99 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -206,10 +206,16 @@ struct rdma_ucm_ud_param {
 	__u8  reserved[7];
 };
 
+struct rdma_ucm_ece {
+	__u32 vendor_id;
+	__u32 attr_mod;
+};
+
 struct rdma_ucm_connect {
 	struct rdma_ucm_conn_param conn_param;
 	__u32 id;
 	__u32 reserved;
+	struct rdma_ucm_ece ece;
 };
 
 struct rdma_ucm_listen {
@@ -287,6 +293,7 @@ struct rdma_ucm_event_resp {
 		struct rdma_ucm_ud_param   ud;
 	} param;
 	__u32 reserved;
+	struct rdma_ucm_ece ece;
 };
 
 /* Option levels */
-- 
2.24.1

