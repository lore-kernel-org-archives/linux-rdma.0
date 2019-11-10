Return-Path: <SRS0=OUpm=ZC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12A0C43331
	for <linux-rdma@archiver.kernel.org>; Sun, 10 Nov 2019 11:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9267520B7C
	for <linux-rdma@archiver.kernel.org>; Sun, 10 Nov 2019 11:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVydsCsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfKJLhD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 10 Nov 2019 06:37:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36706 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfKJLhD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 10 Nov 2019 06:37:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id r10so11667565wrx.3
        for <linux-rdma@vger.kernel.org>; Sun, 10 Nov 2019 03:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AKk56TTlgKrczePFtE7kRn5qc6KhXI0DGLCRMu02StI=;
        b=jVydsCsuDpgVZ7Y5QpO/5jYPxNCg5VpWVlHqA37Dhl9JQXHTTJhKkrEfUq2EyoBs4E
         xA1xDriqUoDU25HsphUgJrMQwufX/KFcmeJzKj1yViZjaPmiDL59SMXEiA3vb6fk2PF8
         tW6UQdaEWQgoDL4+czlJjQn45MljFWVSdj7LnZqpuUGXOMho+uBycxuuQ9edgsvLm5gA
         UfHnZtK8cvaqyMXQaGJ5uCZO/72fNieN2grJEEmLNI7aryLqseosxA3DuQZpi/bvJ8l1
         Erh3D2kigqOzyeCPHrgW4rxF0O9JAN9/REZ2gtxBTVqYyYmr8ZHopAhUB5aRubdGWVyR
         VB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AKk56TTlgKrczePFtE7kRn5qc6KhXI0DGLCRMu02StI=;
        b=LjXmt4NzfE1Q0j+umECzrwh3nBRs9/2Yq1QiUE7JI2mIhrzLSF17lVn807Oj5y9LjK
         xv1M2zFK4mPh2yyN5DiWGBxL4G60naOLfXUhaii9vTeCja1QA+jPcYYb5Z1eqvN9hMAV
         dUh05Wj08QYIECSQzaG2YZ5uq9vnn2V7p0HCsG/3pKOr/DMgw+Q5KrxEr/rVAiYhrphw
         PVm2x306MNFc2UhgYvCjvQVrJ++Xfq4JZAKhPAzuzyuPAlBQHgCCGFr5NkaXcBHC3Aig
         Ze6YILCKmebq/5Kw569iYkW23zs6G6SM7/hQM3CEz/4Ruqqg3NGvrh4CT+hSOQA6USdU
         rWfQ==
X-Gm-Message-State: APjAAAXfH7QZxdttNBd+HbeqHuHse9Bah1RKzlUcl6zQZ7Y68wb8yW4N
        LtqzvlQusrAgzhIUHqKuCTmph+gMI+4=
X-Google-Smtp-Source: APXvYqyp+1IjGunYh2HYLEdjVlL/0TAyA0/AmZeE1zITHY7b4SESPG/PCbmYnJNR45fC6aR/ara6iQ==
X-Received: by 2002:adf:f203:: with SMTP id p3mr17147909wro.2.1573385821355;
        Sun, 10 Nov 2019 03:37:01 -0800 (PST)
Received: from kheib-workstation.redhat.com (bzq-79-178-35-92.red.bezeqint.net. [79.178.35.92])
        by smtp.gmail.com with ESMTPSA id l4sm10798718wme.4.2019.11.10.03.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 03:37:00 -0800 (PST)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Michal Kalderon <mkalderon@marvell.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-next] RDMA/qedr: Make qedr_iw_load_qp() static
Date:   Sun, 10 Nov 2019 13:36:45 +0200
Message-Id: <20191110113645.20058-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The function qedr_iw_load_qp() is only used in qedr_iw_cm.c

Fixes: 82af6d19d8d9 ("RDMA/qedr: Fix synchronization methods and memory leaks in qedr")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 5e9732990be5..a98002018f0c 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -506,7 +506,7 @@ qedr_addr6_resolve(struct qedr_dev *dev,
 	return rc;
 }
 
-struct qedr_qp *qedr_iw_load_qp(struct qedr_dev *dev, u32 qpn)
+static struct qedr_qp *qedr_iw_load_qp(struct qedr_dev *dev, u32 qpn)
 {
 	struct qedr_qp *qp;
 
-- 
2.21.0

