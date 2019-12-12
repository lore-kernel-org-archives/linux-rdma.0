Return-Path: <SRS0=BWFQ=2C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA6CC43603
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 456442173E
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Dec 2019 09:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576143566;
	bh=cBp6OwmXInsOJZ9pnr7Na1+SAmOOCaGyukNTM34upos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rijNj5SnXrPgiv6jIQif20bzqDHvrS6wbO9MAqQ7iiyK++4EtkwM4fif/nmcoUj+q
	 m7uRqC9IudbAZOmARGL4rlIdlFzcnSJA6/58KAlO17tFBndDoQkLVARNRexxHTmYXg
	 nKYJgWB+O3N0T8Gu1CtO+z/ofBnt8xa+5OHBvJdc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfLLJjZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfLLJjZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Dec 2019 04:39:25 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31AD524658;
        Thu, 12 Dec 2019 09:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143564;
        bh=cBp6OwmXInsOJZ9pnr7Na1+SAmOOCaGyukNTM34upos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TACFjSgr50QeobmBdj8s8BEeSGr14DgxDOkGkiozBIlNGrf73CxkIpdmDuxHi4TW4
         RrZbn9mGM3S32xx0mTphO98lGWQJjOWo0gkHWkYgXzXsQspC7vFYO4b1zSAEJoQuxs
         3MMfwweK8hg89Q+bpub3uaoArMuA3h4J1Skl75jg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-rc v2 11/48] RDMA/cm: Reply To Request For Communication Release (DREP) definitions
Date:   Thu, 12 Dec 2019 11:37:53 +0200
Message-Id: <20191212093830.316934-12-leon@kernel.org>
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

Add DREP definitions as it is written in IBTA release 1.3 volume 1.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c      | 4 ++--
 drivers/infiniband/core/cm_msgs.h | 2 +-
 include/rdma/ib_cm.h              | 1 -
 include/rdma/ibta_vol1_c12.h      | 6 ++++++
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 57e35d2f657f..d11ca6bdf016 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2517,7 +2517,7 @@ int ib_send_cm_drep(struct ib_cm_id *cm_id,
 	void *data;
 	int ret;
 
-	if (private_data && private_data_len > IB_CM_DREP_PRIVATE_DATA_SIZE)
+	if (private_data && private_data_len > CM_DREP_PRIVATE_DATA_SIZE)
 		return -EINVAL;
 
 	data = cm_copy_private_data(private_data, private_data_len);
@@ -2678,7 +2678,7 @@ static int cm_drep_handler(struct cm_work *work)
 		return -EINVAL;
 
 	work->cm_event.private_data = &drep_msg->private_data;
-	work->cm_event.private_data_len = IB_CM_DREP_PRIVATE_DATA_SIZE;
+	work->cm_event.private_data_len = CM_DREP_PRIVATE_DATA_SIZE;
 
 	spin_lock_irq(&cm_id_priv->lock);
 	if (cm_id_priv->id.state != IB_CM_DREQ_SENT &&
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index c2b19d21fbe6..98088a84f2fc 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -615,7 +615,7 @@ struct cm_drep_msg {
 	__be32 local_comm_id;
 	__be32 remote_comm_id;
 
-	u8 private_data[IB_CM_DREP_PRIVATE_DATA_SIZE];
+	u8 private_data[CM_DREP_PRIVATE_DATA_SIZE];
 
 } __packed;
 
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 77f4818aaf10..f1fccc8f387f 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -65,7 +65,6 @@ enum ib_cm_event_type {
 };
 
 enum ib_cm_data_size {
-	IB_CM_DREP_PRIVATE_DATA_SIZE	 = 224,
 	IB_CM_LAP_PRIVATE_DATA_SIZE	 = 168,
 	IB_CM_APR_PRIVATE_DATA_SIZE	 = 148,
 	IB_CM_APR_INFO_LENGTH		 = 72,
diff --git a/include/rdma/ibta_vol1_c12.h b/include/rdma/ibta_vol1_c12.h
index e3116b62d7ba..8d57e24534aa 100644
--- a/include/rdma/ibta_vol1_c12.h
+++ b/include/rdma/ibta_vol1_c12.h
@@ -139,4 +139,10 @@
 #define CM_DREQ_PRIVATE_DATA CM_FIELD_MLOC(struct cm_dreq_msg, 12, 1760)
 #define CM_DREQ_PRIVATE_DATA_SIZE 220
 
+/* Table 113 DREP Message Contents */
+#define CM_DREP_LOCAL_COMM_ID CM_FIELD32_LOC(struct cm_drep_msg, 0, 32)
+#define CM_DREP_REMOTE_COMM_ID CM_FIELD32_LOC(struct cm_drep_msg, 4, 32)
+#define CM_DREP_PRIVATE_DATA CM_FIELD_MLOC(struct cm_drep_msg, 8, 1792)
+#define CM_DREP_PRIVATE_DATA_SIZE 224
+
 #endif /* _IBTA_VOL1_C12_H_ */
-- 
2.20.1

