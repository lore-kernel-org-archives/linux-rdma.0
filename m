Return-Path: <SRS0=O4aQ=6U=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC638C28CBC
	for <linux-rdma@archiver.kernel.org>; Wed,  6 May 2020 07:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D075720714
	for <linux-rdma@archiver.kernel.org>; Wed,  6 May 2020 07:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588750868;
	bh=fX7kiplsxEpr8vxP6dZQIZRX9eGAtCxrwGV/KYy0JwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QlF+CtVNVGGSn4NA7BXHBHDrzyK3656e/oL2cQ9EuLwohm53qEkg/lrHyUtWa5kze
	 ot8liVmOzmcF2st6YI1BorqfeTb6x8sHd/z3y+ffJL/AB2/FUFBgbsIA4bg9e8PnTt
	 eKzOKIWqMqWyKTM/NFOCvXSML+5iVMhYBo2Zdr4s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgEFHlI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 6 May 2020 03:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgEFHlI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 6 May 2020 03:41:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4034206E6;
        Wed,  6 May 2020 07:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588750867;
        bh=fX7kiplsxEpr8vxP6dZQIZRX9eGAtCxrwGV/KYy0JwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpEewg44xSeS7iXtEVPLBbILqugrTiHHIZAQkUAeg5YS9F6lFjrkXqXV9CiOca2qH
         R2TdJztyaCPDVbkTgVTmiirc3CMSk2IEJ296kBquEm0i5KNbn317QciMjXiKBE/J5m
         Fl/W4S0r6l2fQ4RZh/od6JHlxO7K498Ax9RxoXY4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 3/9] IB/uverbs: Extend CQ to get its own asynchronous event FD
Date:   Wed,  6 May 2020 10:40:43 +0300
Message-Id: <20200506074049.8347-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506074049.8347-1-leon@kernel.org>
References: <20200506074049.8347-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Extend CQ to get its own asynchronous event FD.
The event FD is an optional attribute, in case wasn't given the ufile
event FD will be used.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs.h              | 18 ++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_cq.c |  9 ++++++---
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 55b47f110183..7241009045a5 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -293,6 +293,24 @@ static inline u32 make_port_cap_flags(const struct ib_port_attr *attr)
 	return res;
 }
 
+static inline struct ib_uverbs_async_event_file *
+ib_uverbs_get_async_event(struct uverbs_attr_bundle *attrs,
+			  u16 id)
+{
+	struct ib_uobject *async_ev_file_uobj;
+	struct ib_uverbs_async_event_file *async_ev_file;
+
+	async_ev_file_uobj = uverbs_attr_get_uobject(attrs, id);
+	if (IS_ERR(async_ev_file_uobj))
+		async_ev_file = attrs->ufile->default_async_file;
+	else
+		async_ev_file = container_of(async_ev_file_uobj,
+				       struct ib_uverbs_async_event_file,
+				       uobj);
+	if (async_ev_file)
+		uverbs_uobject_get(&async_ev_file->uobj);
+	return async_ev_file;
+}
 
 void copy_port_attr_to_resp(struct ib_port_attr *attr,
 			    struct ib_uverbs_query_port_resp *resp,
diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c b/drivers/infiniband/core/uverbs_std_types_cq.c
index 59617c8b88ea..5d9b43a8904f 100644
--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -100,9 +100,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE)(
 		uverbs_uobject_get(ev_file_uobj);
 	}
 
-	obj->uevent.event_file = attrs->ufile->default_async_file;
-	if (obj->uevent.event_file)
-		uverbs_uobject_get(&obj->uevent.event_file->uobj);
+	obj->uevent.event_file = ib_uverbs_get_async_event(
+		attrs, UVERBS_ATTR_CREATE_CQ_EVENT_FD);
 
 	if (attr.comp_vector >= attrs->ufile->device->num_comp_vectors) {
 		ret = -EINVAL;
@@ -173,6 +172,10 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_CREATE_CQ_RESP_CQE,
 			    UVERBS_ATTR_TYPE(u32),
 			    UA_MANDATORY),
+	UVERBS_ATTR_FD(UVERBS_ATTR_CREATE_CQ_EVENT_FD,
+		       UVERBS_OBJECT_ASYNC_EVENT,
+		       UVERBS_ACCESS_READ,
+		       UA_OPTIONAL),
 	UVERBS_ATTR_UHW());
 
 static int UVERBS_HANDLER(UVERBS_METHOD_CQ_DESTROY)(
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index d4ddbe4e696c..286fdc1929e0 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -95,6 +95,7 @@ enum uverbs_attrs_create_cq_cmd_attr_ids {
 	UVERBS_ATTR_CREATE_CQ_COMP_VECTOR,
 	UVERBS_ATTR_CREATE_CQ_FLAGS,
 	UVERBS_ATTR_CREATE_CQ_RESP_CQE,
+	UVERBS_ATTR_CREATE_CQ_EVENT_FD,
 };
 
 enum uverbs_attrs_destroy_cq_cmd_attr_ids {
-- 
2.26.2

