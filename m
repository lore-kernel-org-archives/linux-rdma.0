Return-Path: <SRS0=0596=4W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33FEC3F2D1
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Mar 2020 15:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB2220801
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Mar 2020 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583420652;
	bh=rNXfzrMjEBXctNAdJevmFGW6sA3EF5J/MmKdke46iyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UshHWBBTrQpeaCi0wCBvO5igHN5UvbQRxCN3WAH3Xo6tkTCLg2Rxeqruu27m4OmFj
	 kQVpoL8EfNEH/4kz9Fq4AIUDVFgViIFHGni5Ij+bDFQCyrwlgRGLQm8Gn5dp0SytCC
	 xk+Ik4WII8mQh503zHCEEEkgNei+13gsc+GI542g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCEPEM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:04:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCEPEL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Mar 2020 10:04:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1D1120848;
        Thu,  5 Mar 2020 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583420651;
        bh=rNXfzrMjEBXctNAdJevmFGW6sA3EF5J/MmKdke46iyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4KXglFfkeSvGX3ztwgvHz8lP7Z81welgh6GO1VIy92mS1lE0qI4Ql6JQI4+6m9wp
         bJdeOloAukAJtJzwm5jaLY3CbxdLKKYfWIh0cwucw8db0cTbB2AzIl/Imxleqa84pv
         m9yXDEWCHqtVEzkAXm20KhDIM5vAcB43lhYHVCmc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [RFC PATCH rdma-core 01/11] Update kernel headers
Date:   Thu,  5 Mar 2020 17:03:46 +0200
Message-Id: <20200305150356.208843-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305150356.208843-1-leon@kernel.org>
References: <20200305150356.208843-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

To commit 1ab53e5ec89e ("RDMA/cma: Provide ECE reject reason")

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 kernel-headers/rdma/rdma_user_cm.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel-headers/rdma/rdma_user_cm.h b/kernel-headers/rdma/rdma_user_cm.h
index e42940a2..e545f2de 100644
--- a/kernel-headers/rdma/rdma_user_cm.h
+++ b/kernel-headers/rdma/rdma_user_cm.h
@@ -78,6 +78,10 @@ enum rdma_ucm_port_space {
 	RDMA_PS_UDP   = 0x0111,
 };

+enum rdma_ucm_reject_reason {
+	RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED = 35
+};
+
 /*
  * command ABI structures.
  */
@@ -206,10 +210,16 @@ struct rdma_ucm_ud_param {
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
@@ -222,12 +232,14 @@ struct rdma_ucm_accept {
 	struct rdma_ucm_conn_param conn_param;
 	__u32 id;
 	__u32 reserved;
+	struct rdma_ucm_ece ece;
 };

 struct rdma_ucm_reject {
 	__u32 id;
 	__u8  private_data_len;
-	__u8  reserved[3];
+	__u8  reason; /* enum rdma_ucm_reject_reason */
+	__u8  reserved[2];
 	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
 };

@@ -287,6 +299,7 @@ struct rdma_ucm_event_resp {
 		struct rdma_ucm_ud_param   ud;
 	} param;
 	__u32 reserved;
+	struct rdma_ucm_ece ece;
 };

 /* Option levels */
--
2.24.1

