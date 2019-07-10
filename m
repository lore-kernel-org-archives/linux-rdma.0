Return-Path: <SRS0=nSk8=VH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133E8C73C76
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 07:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4C32064A
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 07:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562743519;
	bh=JkZplVn3xt35Y2dfqpZF1VmyrYiv+s/b60YHeHwbZsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0T2udEV/gelfh/vbCDhdKX/i/WKCtFt6W4Q53DU+wrtsTCYTQMzWuWQ8EXoEJBHcx
	 T1bUIUJdB6uQXahzbstUJmZz+iZJheTB2AbZXxBDzD2r2kDFUI88r/+VDKUmqFo1qQ
	 SqQ53U0xXUb0AnYTb2/Bmf8V4moJJAAksKEIxkLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfGJHZS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Jul 2019 03:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHZS (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Jul 2019 03:25:18 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E5842083D;
        Wed, 10 Jul 2019 07:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562743517;
        bh=JkZplVn3xt35Y2dfqpZF1VmyrYiv+s/b60YHeHwbZsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlCA5NBz+2jAxDn+PiKI1YYSCgYJ8d+FKlCY43hAZpQKu1i/zOKG49nPiqnsUDPEm
         4w8HeZhG01Acj4NXyXbT0KpnkWQf8maFWpsKE2YRXmU6/pYK9Ohjq0n+JfU9IiK2LE
         v1Ifi49foPAuMHwvXFMP4qOloVBJE8q/CS+huG0k=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc 5/8] rdma: Make get_port_from_argv() returns valid port in strict port mode
Date:   Wed, 10 Jul 2019 10:24:52 +0300
Message-Id: <20190710072455.9125-6-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710072455.9125-1-leon@kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When strict_port is set, make get_port_from_argv() returns failure if
no valid port is specified.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/utils.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/rdma/utils.c b/rdma/utils.c
index aed1a3d0..95b669f3 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -56,7 +56,7 @@ bool rd_no_arg(struct rd *rd)
  * mlx5_1/1    | 1          | false
  * mlx5_1/-    | 0          | false
  *
- * In strict mode, /- will return error.
+ * In strict port mode, a non-0 port must be provided
  */
 static int get_port_from_argv(struct rd *rd, uint32_t *port,
 			      bool *is_dump_all, bool strict_port)
@@ -64,7 +64,7 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 	char *slash;
 
 	*port = 0;
-	*is_dump_all = true;
+	*is_dump_all = strict_port ? false : true;
 
 	slash = strchr(rd_argv(rd), '/');
 	/* if no port found, return 0 */
@@ -83,6 +83,9 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 		if (!*port && strlen(slash))
 			return -EINVAL;
 	}
+	if (strict_port && (*port == 0))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.20.1

