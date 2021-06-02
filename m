Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D1DC47092
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Jun 2021 10:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C96EE6138C
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Jun 2021 10:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhFBK3Y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Jun 2021 06:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFBK3C (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Jun 2021 06:29:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56395613AA;
        Wed,  2 Jun 2021 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622629640;
        bh=9BZAAzBXUsFnxzBksVs8V35KTMzLRNT1T8uiN0llGBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APVWCaPNqPYFuvnaiLSO4MEo2ggO5eY7cRI9LO3xjbQu5v0QfahOanNecVTexkstS
         u8PXwyixPpYYArhanbV7UWM9zFHeb8WjR8DJwwPA8Q52wQRejSE4BG3d7yQBTOc2cs
         hQns2QyjtOxHKz2F+n/N0rN3kY+pCUedX6CV1l3v7krV6bFemU6RfdRYHUCyM2ELYS
         4mmmnk/WJzwiTmIvmw/qt1lO33QSuNyPKMKgNxozck28ZK08FD01cw+p8rOo0CcIyj
         ZMrvhuWLqwQ3kVJnILErBCld/XN7VOMXMqr/XxUnDsWG16C+jRrstl5USWyUBo43wK
         XQh5kJxgo/7yA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>,
        Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH rdma-next v4 3/8] IB/cm: Call the correct message free functions in cm_send_handler()
Date:   Wed,  2 Jun 2021 13:27:03 +0300
Message-Id: <62a507195b8db85bb11228d0c6e7fa944204bf12.1622629024.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622629024.git.leonro@nvidia.com>
References: <cover.1622629024.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

There are now three destroy functions for the cm_msg, and all places
except the general send completion handler use the correct function.

Fix cm_send_handler() to detect which kind of message is being completed
and destroy it using the correct function with the correct locking.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/cm.c | 52 +++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 94613275edcc..8dbc39ea4612 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3795,22 +3795,26 @@ static int cm_sidr_rep_handler(struct cm_work *work)
 	return -EINVAL;
 }
 
-static void cm_process_send_error(struct ib_mad_send_buf *msg,
+static void cm_process_send_error(struct cm_id_private *cm_id_priv,
+				  struct ib_mad_send_buf *msg,
+				  enum ib_cm_state state,
 				  enum ib_wc_status wc_status)
 {
-	struct cm_id_private *cm_id_priv;
-	struct ib_cm_event cm_event;
-	enum ib_cm_state state;
+	struct ib_cm_event cm_event = {};
 	int ret;
 
-	memset(&cm_event, 0, sizeof cm_event);
-	cm_id_priv = msg->context[0];
-
 	/* Discard old sends or ones without a response. */
 	spin_lock_irq(&cm_id_priv->lock);
-	state = (enum ib_cm_state) (unsigned long) msg->context[1];
-	if (msg != cm_id_priv->msg || state != cm_id_priv->id.state)
-		goto discard;
+	if (msg != cm_id_priv->msg) {
+		spin_unlock_irq(&cm_id_priv->lock);
+		cm_free_msg(msg);
+		return;
+	}
+	cm_free_priv_msg(msg);
+
+	if (state != cm_id_priv->id.state || wc_status == IB_WC_SUCCESS ||
+	    wc_status == IB_WC_WR_FLUSH_ERR)
+		goto out_unlock;
 
 	trace_icm_mad_send_err(state, wc_status);
 	switch (state) {
@@ -3833,26 +3837,27 @@ static void cm_process_send_error(struct ib_mad_send_buf *msg,
 		cm_event.event = IB_CM_SIDR_REQ_ERROR;
 		break;
 	default:
-		goto discard;
+		goto out_unlock;
 	}
 	spin_unlock_irq(&cm_id_priv->lock);
 	cm_event.param.send_status = wc_status;
 
 	/* No other events can occur on the cm_id at this point. */
 	ret = cm_id_priv->id.cm_handler(&cm_id_priv->id, &cm_event);
-	cm_free_msg(msg);
 	if (ret)
 		ib_destroy_cm_id(&cm_id_priv->id);
 	return;
-discard:
+out_unlock:
 	spin_unlock_irq(&cm_id_priv->lock);
-	cm_free_msg(msg);
 }
 
 static void cm_send_handler(struct ib_mad_agent *mad_agent,
 			    struct ib_mad_send_wc *mad_send_wc)
 {
 	struct ib_mad_send_buf *msg = mad_send_wc->send_buf;
+	struct cm_id_private *cm_id_priv = msg->context[0];
+	enum ib_cm_state state =
+		(enum ib_cm_state)(unsigned long)msg->context[1];
 	struct cm_port *port;
 	u16 attr_index;
 
@@ -3865,7 +3870,7 @@ static void cm_send_handler(struct ib_mad_agent *mad_agent,
 	 * set to a cm_id), and is not a REJ, then it is a send that was
 	 * manually retried.
 	 */
-	if (!msg->context[0] && (attr_index != CM_REJ_COUNTER))
+	if (!cm_id_priv && (attr_index != CM_REJ_COUNTER))
 		msg->retries = 1;
 
 	atomic_long_add(1 + msg->retries,
@@ -3875,18 +3880,11 @@ static void cm_send_handler(struct ib_mad_agent *mad_agent,
 				&port->counter_group[CM_XMIT_RETRIES].
 				counter[attr_index]);
 
-	switch (mad_send_wc->status) {
-	case IB_WC_SUCCESS:
-	case IB_WC_WR_FLUSH_ERR:
-		cm_free_msg(msg);
-		break;
-	default:
-		if (msg->context[0] && msg->context[1])
-			cm_process_send_error(msg, mad_send_wc->status);
-		else
-			cm_free_msg(msg);
-		break;
-	}
+	if (cm_id_priv)
+		cm_process_send_error(cm_id_priv, msg, state,
+				      mad_send_wc->status);
+	else
+		cm_free_response_msg(msg);
 }
 
 static void cm_work_handler(struct work_struct *_work)
-- 
2.31.1

