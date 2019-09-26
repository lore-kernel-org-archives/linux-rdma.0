Return-Path: <SRS0=E0T5=XV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F97EC432C2
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 09:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E36D9222C3
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 09:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569490981;
	bh=4I4/GYrFb1MsFYPCB4F+lZOP/OqkwrQcSWql4or8S1Y=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XMBhGy+e5VKXmA7gRBdjY1Oce7W573n2tRHFYagkZfgmy9cXrzLge4BQL25Oq8zWv
	 wysFOGweq0Ig8z5k4628vzmUcS1hsqZ/JHBmi843i82rqKIvpnUH76qdBsNtJKwyku
	 Tv286ZUASA//wuwyYDMQ4UVw7FwkZm9fwQ1JoZtw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfIZJnA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbfIZJnA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 26 Sep 2019 05:43:00 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC0E222BE;
        Thu, 26 Sep 2019 09:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569490979;
        bh=4I4/GYrFb1MsFYPCB4F+lZOP/OqkwrQcSWql4or8S1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=CJpd20P7cMB9fIL7jHu6pI9q99C4yGzrKkf1iFRE2EkFGM6CMNtEOsi/82uPsXrDT
         vVrq2t1rh4EK0qgWB+xmPC+IDXxRNYQWmKUL8ODnz3t056q0iKxumJSLiWczWBU98H
         U9hPBvII1hWD2uA50LAI3p9+t9bkujO4wzyNwoQI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH rdma-core] kernel-boot: Tighten check if device is virtual
Date:   Thu, 26 Sep 2019 12:42:53 +0300
Message-Id: <20190926094253.31145-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Virtual devices like SIW or RXE don't set FW version because
they don't have one, use that fact to rely on having empty
fw_ver file to sense such virtual devices.

Such change is needed to ensure that virtual devices which are
attached to real hardware won't be renamed, because during
device attachment, user already supplied desired name.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 kernel-boot/rdma_rename.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel-boot/rdma_rename.c b/kernel-boot/rdma_rename.c
index 41649d7d0..1588a0f45 100644
--- a/kernel-boot/rdma_rename.c
+++ b/kernel-boot/rdma_rename.c
@@ -356,9 +356,12 @@ err_free:
 
 static int by_pci(struct data *d)
 {
+	bool is_virtual = false;
 	struct pci_info p = {};
 	char *subsystem;
 	char buf[256] = {};
+	FILE *fw_ver_p;
+	char *fw_ver;
 	char *subs;
 	int ret;
 
@@ -373,9 +376,41 @@ static int by_pci(struct data *d)
 		goto out;
 	}
 	buf[ret] = 0;
-
 	subs = basename(buf);
-	if (strcmp(subs, "pci")) {
+
+	ret =  asprintf(&fw_ver, "/sys/class/infiniband/%s/fw_ver", d->curr);
+	if (ret < 0) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = 0;
+	fw_ver_p = fopen(fw_ver, "r");
+	if (fw_ver_p) {
+		char *s = fgets(buf, 3, fw_ver_p);
+
+		fclose(fw_ver_p);
+
+		if (!s)
+			/* Signal that we can't read fw_ver file */
+			ret = -EINVAL;
+		/*
+		 * Virtual devices like SIW and RXE
+		 * don't set their FW version
+		 */
+		if (strlen(s) < 2)
+			is_virtual = true;
+	} else {
+		ret = -EINVAL;
+	}
+
+	if (ret) {
+		/* Something very wrong, all IB devices have fw_ver file */
+		pr_err("%s: Can't open/read fw_ver file\n", d->curr);
+		goto out;
+	}
+
+	if (strcmp(subs, "pci") || is_virtual) {
 		/* Ball out virtual devices */
 		pr_dbg("%s: Non-PCI device (%s) was detected\n", d->curr, subs);
 		ret = -EINVAL;
-- 
2.20.1

