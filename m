Return-Path: <SRS0=lmFq=XG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54098ECDE20
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Sep 2019 08:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2267B21A4C
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Sep 2019 08:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568189570;
	bh=TuGFTo4yDgBKVIjgEc0gL99p9EO6rgqJJ/wUOuDpG9M=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=kEFUiMhC/VYhv8yND/MERvp0jk5qMKZySDY0D+Ti9JPLlMuhync5P4gLIVlrUKWH9
	 IuMXcdYroLX/wjRknDFQkRAKb8flkFOlLfYsva5KmOfFTZA7JhU6H+1C9UFZX26PNp
	 00hGkEtTBpLs5VpOYKgSnBeNHu1SY9vpKM0EK/KU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfIKIMt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfIKIMt (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 11 Sep 2019 04:12:49 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADD721479;
        Wed, 11 Sep 2019 08:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568189568;
        bh=TuGFTo4yDgBKVIjgEc0gL99p9EO6rgqJJ/wUOuDpG9M=;
        h=From:To:Cc:Subject:Date:From;
        b=jhSvXh0i97MUQYOtPmukf75XuHBMTkEEI/i01keIXAJ7NIKrwDZyrDL/rijgFqT6p
         PsgsBXIkwipBpf2/NXq2dW88KpsdSMU6KsUDJv2/H+dOCd6QYvDqwAFMWUSPzcEV48
         tPQs9EaQ+aTRV1o3EU+pqS3a2Ecd8ce5uXuMMqdE=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH iproute2-next] rdma: Check comm string before print in print_comm()
Date:   Wed, 11 Sep 2019 11:12:43 +0300
Message-Id: <20190911081243.28917-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Broken kernels (not-upstream) can provide wrong empty "comm" field.
It causes to segfault while printing in JSON format.

Fixes: 8ecac46a60ff ("rdma: Add QP resource tracking information")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rdma/res.c b/rdma/res.c
index 97a7b964..6003006e 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -161,6 +161,9 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 {
 	char tmp[18];
 
+	if (!str)
+		return;
+
 	if (rd->json_output) {
 		/* Don't beatify output in JSON format */
 		jsonw_string_field(rd->jw, "comm", str);
-- 
2.20.1

