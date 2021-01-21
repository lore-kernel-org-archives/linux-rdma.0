Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B68BC433E9
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Jan 2021 14:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1764238E3
	for <linux-rdma@archiver.kernel.org>; Thu, 21 Jan 2021 14:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbhAUOu6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 21 Jan 2021 09:50:58 -0500
Received: from gentwo.org ([3.19.106.255]:52858 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732416AbhAUNev (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 21 Jan 2021 08:34:51 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2021 08:34:50 EST
Received: by gentwo.org (Postfix, from userid 1002)
        id E7997413B6; Thu, 21 Jan 2021 13:24:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id E5C35413B5;
        Thu, 21 Jan 2021 13:24:43 +0000 (UTC)
Date:   Thu, 21 Jan 2021 13:24:43 +0000 (UTC)
From:   Christoph Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     Jason Gunthorpe <jgg@ziepe.ca>
cc:     linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] Fix sendonly join going away after Reregister event
Message-ID: <alpine.DEB.2.22.394.2101211318530.120233@www.lameter.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Christoph Lameter <cl@linux.com>
Subject: [PATCH] Fix sendonly join going away after Reregister event

When a server receives a REREG event then the SM information in
the kernel is marked as invalid and a request is sent to the SM to update
the information.

However, receiving a REREG also occurs in user space applications that
are now trying to rejoin the multicast groups.

If the SM information is invalid then ib_sa_sendonly_fullmem_support()
returns false. That is wrong because it just means that we do not know
yet if the potentially new SM supports sendonly joins. It does not mean
that the SM does not support Sendonly joins.

This patch simply attempts to waits until the SM information is updated
and the determination can be made.

The code has not been testet but compiles fine.
I am not sure if it is good to do an msleep here.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/infiniband/core/sa_query.c
===================================================================
--- linux.orig/drivers/infiniband/core/sa_query.c	2020-12-17 14:51:15.301206041 +0000
+++ linux/drivers/infiniband/core/sa_query.c	2021-01-21 12:52:53.577943481 +0000
@@ -1963,11 +1963,19 @@ bool ib_sa_sendonly_fullmem_support(stru
 	if (!sa_dev)
 		return ret;

+redo:
 	port  = &sa_dev->port[port_num - sa_dev->start_port];

+	while (!port->classport_info.valid)
+		msleep(100);
+
 	spin_lock_irqsave(&port->classport_lock, flags);
-	if ((port->classport_info.valid) &&
-	    (port->classport_info.data.type == RDMA_CLASS_PORT_INFO_IB))
+	if (!port->classport_info.valid) {
+		/* Need to wait until the SM data is available */
+		spin_unlock_irqrestore(&port->classport_lock, flags);
+		goto redo;
+	}
+	if ((port->classport_info.data.type == RDMA_CLASS_PORT_INFO_IB))
 		ret = ib_get_cpi_capmask2(&port->classport_info.data.ib)
 			& IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT;
 	spin_unlock_irqrestore(&port->classport_lock, flags);
