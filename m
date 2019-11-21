Return-Path: <SRS0=NZET=ZN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D770BC432C0
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 18:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE04206D7
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Nov 2019 18:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574360003;
	bh=7VSap/pDkZCJ2HaTTu0ygwqILaPsiLNK7bYS+hXyIiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NMwv2yGRs1Y519DZLYyyvhz68LJzH2zoslhZpIW62a09xvQpR3swWlbo1wMsGmIJY
	 P8eLneoJTd1Dar6XCghKEdV/g0SDB8s+K0bfBv0jEOGH43VackJLUWBCps8QPz+MUo
	 i5aVI2qzTyKDKQeH600JNQXML2RDMvJY/LmMSL3U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKUSNX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 21 Nov 2019 13:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKUSNX (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 21 Nov 2019 13:13:23 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D4D206CC;
        Thu, 21 Nov 2019 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574360001;
        bh=7VSap/pDkZCJ2HaTTu0ygwqILaPsiLNK7bYS+hXyIiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgPIprDI0SO+sVgBJJxJOPd5afQko66IugyQJ8UuBCw8WyamSC6HLihqsYJgmpphH
         GPLCLRGOnusQJx/G2QovAL1IIMDgz3KiO3xyF4etr+1uG8/9lLpuWE13WF90VQbaft
         k3Y+7yY3TGIBa784oDlqFVVE3RJOxQ0UpjdP4Odg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-next v1 01/48] RDMA/cm: Provide private data size to CM users
Date:   Thu, 21 Nov 2019 20:12:26 +0200
Message-Id: <20191121181313.129430-2-leon@kernel.org>
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

Prepare code to removal IB_CM_*_PRIVATE_DATA_SIZE enum so we will store
such size in adjacent to actual data.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 11 +++++++++++
 include/rdma/ib_cm.h         |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 455b3659d84b..c341a68b6f97 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1681,6 +1681,7 @@ static void cm_format_req_event(struct cm_work *work,
 	param->srq = cm_req_get_srq(req_msg);
 	param->ppath_sgid_attr = cm_id_priv->av.ah_attr.grh.sgid_attr;
 	work->cm_event.private_data = &req_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_REQ_PRIVATE_DATA_SIZE;
 }
 
 static void cm_process_work(struct cm_id_private *cm_id_priv,
@@ -2193,6 +2194,7 @@ static void cm_format_rep_event(struct cm_work *work, enum ib_qp_type qp_type)
 	param->rnr_retry_count = cm_rep_get_rnr_retry_count(rep_msg);
 	param->srq = cm_rep_get_srq(rep_msg);
 	work->cm_event.private_data = &rep_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_REP_PRIVATE_DATA_SIZE;
 }
 
 static void cm_dup_rep_handler(struct cm_work *work)
@@ -2395,6 +2397,7 @@ static int cm_rtu_handler(struct cm_work *work)
 		return -EINVAL;
 
 	work->cm_event.private_data = &rtu_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_RTU_PRIVATE_DATA_SIZE;
 
 	spin_lock_irq(&cm_id_priv->lock);
 	if (cm_id_priv->id.state != IB_CM_REP_SENT &&
@@ -2597,6 +2600,7 @@ static int cm_dreq_handler(struct cm_work *work)
 	}
 
 	work->cm_event.private_data = &dreq_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_DREQ_PRIVATE_DATA_SIZE;
 
 	spin_lock_irq(&cm_id_priv->lock);
 	if (cm_id_priv->local_qpn != cm_dreq_get_remote_qpn(dreq_msg))
@@ -2671,6 +2675,7 @@ static int cm_drep_handler(struct cm_work *work)
 		return -EINVAL;
 
 	work->cm_event.private_data = &drep_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_DREP_PRIVATE_DATA_SIZE;
 
 	spin_lock_irq(&cm_id_priv->lock);
 	if (cm_id_priv->id.state != IB_CM_DREQ_SENT &&
@@ -2770,6 +2775,7 @@ static void cm_format_rej_event(struct cm_work *work)
 	param->ari_length = cm_rej_get_reject_info_len(rej_msg);
 	param->reason = __be16_to_cpu(rej_msg->reason);
 	work->cm_event.private_data = &rej_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_REJ_PRIVATE_DATA_SIZE;
 }
 
 static struct cm_id_private * cm_acquire_rejected_id(struct cm_rej_msg *rej_msg)
@@ -2982,6 +2988,7 @@ static int cm_mra_handler(struct cm_work *work)
 		return -EINVAL;
 
 	work->cm_event.private_data = &mra_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_MRA_PRIVATE_DATA_SIZE;
 	work->cm_event.param.mra_rcvd.service_timeout =
 					cm_mra_get_service_timeout(mra_msg);
 	timeout = cm_convert_to_ms(cm_mra_get_service_timeout(mra_msg)) +
@@ -3214,6 +3221,7 @@ static int cm_lap_handler(struct cm_work *work)
 	param->alternate_path = &work->path[0];
 	cm_format_path_from_lap(cm_id_priv, param->alternate_path, lap_msg);
 	work->cm_event.private_data = &lap_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_LAP_PRIVATE_DATA_SIZE;
 
 	spin_lock_irq(&cm_id_priv->lock);
 	if (cm_id_priv->id.state != IB_CM_ESTABLISHED)
@@ -3367,6 +3375,7 @@ static int cm_apr_handler(struct cm_work *work)
 	work->cm_event.param.apr_rcvd.apr_info = &apr_msg->info;
 	work->cm_event.param.apr_rcvd.info_len = apr_msg->info_length;
 	work->cm_event.private_data = &apr_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_APR_PRIVATE_DATA_SIZE;
 
 	spin_lock_irq(&cm_id_priv->lock);
 	if (cm_id_priv->id.state != IB_CM_ESTABLISHED ||
@@ -3515,6 +3524,7 @@ static void cm_format_sidr_req_event(struct cm_work *work,
 	param->port = work->port->port_num;
 	param->sgid_attr = rx_cm_id->av.ah_attr.grh.sgid_attr;
 	work->cm_event.private_data = &sidr_req_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE;
 }
 
 static int cm_sidr_req_handler(struct cm_work *work)
@@ -3664,6 +3674,7 @@ static void cm_format_sidr_rep_event(struct cm_work *work,
 	param->info_len = sidr_rep_msg->info_length;
 	param->sgid_attr = cm_id_priv->av.ah_attr.grh.sgid_attr;
 	work->cm_event.private_data = &sidr_rep_msg->private_data;
+	work->cm_event.private_data_len = IB_CM_SIDR_REP_PRIVATE_DATA_SIZE;
 }
 
 static int cm_sidr_rep_handler(struct cm_work *work)
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index b01a8a8d4de9..b476e0e27ec9 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -254,6 +254,7 @@ struct ib_cm_event {
 	} param;
 
 	void			*private_data;
+	u8			private_data_len;
 };
 
 #define CM_REQ_ATTR_ID		cpu_to_be16(0x0010)
-- 
2.20.1

