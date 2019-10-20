Return-Path: <SRS0=v0iq=YN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F35CA9EA0
	for <linux-rdma@archiver.kernel.org>; Sun, 20 Oct 2019 07:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88578222C3
	for <linux-rdma@archiver.kernel.org>; Sun, 20 Oct 2019 07:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571555769;
	bh=c8DkaVOwNHnbKep2BOZr3O+xhfOOzfhqoXkfjzWZXEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VaVjglSAvGOWOsFPDibjxfjHhWX+2L87DK5G23plx0QehDOdhSuaMpf8HKg8ZCQMc
	 wM/wqa0XGY4dosRoqxl9x0deGnqvKnXZuRP79XzBmBYSY4cucbN9AGRsl/ESqSF9on
	 IpdV2q7+PO4oeQLSCLtm5XT6KWmX3E7NOatfMuzY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfJTHQI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 20 Oct 2019 03:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfJTHQI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 20 Oct 2019 03:16:08 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646C321D80;
        Sun, 20 Oct 2019 07:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571555768;
        bh=c8DkaVOwNHnbKep2BOZr3O+xhfOOzfhqoXkfjzWZXEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQ3TAKBizZKLoCeZfnax8fO9xWJwzK7IF5ijXnMYYgtnPugMYbE+jnOq+1BuigWSZ
         w1VEUpKUBLrNhgRoRSmd+b33wzBJbWUD59E/31bSrIBiWFE/vcJAsirnsWRpZ2epxs
         a2OIJWrzyYubi/0FSSVKxm0zIN/eORggx2cyGdjM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH rdma-next 1/6] RDMA/cm: Delete unused cm_is_active_peer function
Date:   Sun, 20 Oct 2019 10:15:54 +0300
Message-Id: <20191020071559.9743-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191020071559.9743-1-leon@kernel.org>
References: <20191020071559.9743-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Function cm_is_active_peer is not used, delete it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c0aa3a4b4cfd..bc4abb05dbd4 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1525,14 +1525,6 @@ static int cm_issue_rej(struct cm_port *port,
 	return ret;
 }
 
-static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
-				    __be32 local_qpn, __be32 remote_qpn)
-{
-	return (be64_to_cpu(local_ca_guid) > be64_to_cpu(remote_ca_guid) ||
-		((local_ca_guid == remote_ca_guid) &&
-		 (be32_to_cpu(local_qpn) > be32_to_cpu(remote_qpn))));
-}
-
 static bool cm_req_has_alt_path(struct cm_req_msg *req_msg)
 {
 	return ((req_msg->alt_local_lid) ||
-- 
2.20.1

