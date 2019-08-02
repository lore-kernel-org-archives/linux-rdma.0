Return-Path: <SRS0=RN5a=V6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C46BC433FF
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Aug 2019 17:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F802087E
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Aug 2019 17:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vgMnPdHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404861AbfHBRYI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Aug 2019 13:24:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45608 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404689AbfHBRYI (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Aug 2019 13:24:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so36354371pfq.12;
        Fri, 02 Aug 2019 10:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dBxG4FOJ9DD9Cx5lh35bmxbfWydS0WqQT7U1r29fUWs=;
        b=vgMnPdHoG1WIYaruke02wqrS0r4/U9zqrhxe/iiFo0VgztLQnbn8dz7uHyoAn8EfRm
         XxW0NNiUByZxrwPNTe4HOmUDqjKFuusccUZYtMlxz96iohqnCY1mMoDCnLLUBgtR3rwI
         wXdWGGeKqL2VnqDGTArVv5acnIko+ofrTrtrJ7TarojxISXpf44RxuJwsvu+HQjcDPTa
         Y6bMb0eUvasz15+wKb7dv+xpxv0fNzvn0kF41KLo26K9UNIH380G879M9SauvCqyJL8z
         XxGYAvV4Up/avkHHbYN4AIJrXty/iDAx3xblGDj8m/frf/XRpZzFvwYKYwueWeoKwVQN
         TLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dBxG4FOJ9DD9Cx5lh35bmxbfWydS0WqQT7U1r29fUWs=;
        b=s3iU7VO9bJV+hgVGUeJ2gV3gLz43eRjwCCclJKhhkv804Y1WuibDFOqsZR+hoa2rcf
         LZskoL6nx2e7epAaOetTIR1RoL3Xc1KmjjZcEpeOJkpnj1sOLS3QP90jJnIfM7uUOcJJ
         md6F2uJcTS+FtQ156+6EXfu4Q274xPEvZstrixtoF6hs8k5+f/Oe7Re9yeCKy7OMU7ai
         XbbgARTH3JE2J5E28F8an+uxmFh2EzLMA5EOENkV4B65bWE1vjQSkXPq6sWDJF5Ucv8T
         UCTArCdvat0oTrEnQ/KEz2MjAd2ucl0tHXTKPhM3n4nhYgt0AUbI+DgxwFnEMh+UI8EB
         ld1g==
X-Gm-Message-State: APjAAAUZPXX6T6RqZuof9xALZw/rJc3QBbIR8NMRZOVuLWqFvgwGtAla
        Yw2FX8nvCU5OdzMIWQjQbSYbMIVwldRpdA==
X-Google-Smtp-Source: APXvYqwQZDLwwx0ZrrAMn5vp2BriVz7Cw1YOAr1yZuhAJUmKk1TlqoGrkUmMdPF7rhLeObNo1vOtZw==
X-Received: by 2002:a17:90a:bb0c:: with SMTP id u12mr5437710pjr.132.1564766648222;
        Fri, 02 Aug 2019 10:24:08 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id e189sm62275681pgc.15.2019.08.02.10.24.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:24:07 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 3/3] IB/mlx5: Use refcount_() APIs
Date:   Sat,  3 Aug 2019 01:24:01 +0800
Message-Id: <20190802172401.8467-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This patch depends on PATCH 1/3.

After converting refcount to refcount_t, use
refcount_() APIs to operate it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/infiniband/hw/mlx5/srq_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index b0d0687c7a68..8fc3630a9d4c 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -86,7 +86,7 @@ struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn)
 	xa_lock(&table->array);
 	srq = xa_load(&table->array, srqn);
 	if (srq)
-		atomic_inc(&srq->common.refcount);
+		refcount_inc(&srq->common.refcount);
 	xa_unlock(&table->array);
 
 	return srq;
@@ -592,7 +592,7 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	if (err)
 		return err;
 
-	atomic_set(&srq->common.refcount, 1);
+	refcount_set(&srq->common.refcount, 1);
 	init_completion(&srq->common.free);
 
 	err = xa_err(xa_store_irq(&table->array, srq->srqn, srq, GFP_KERNEL));
@@ -675,7 +675,7 @@ static int srq_event_notifier(struct notifier_block *nb,
 	xa_lock(&table->array);
 	srq = xa_load(&table->array, srqn);
 	if (srq)
-		atomic_inc(&srq->common.refcount);
+		refcount_inc(&srq->common.refcount);
 	xa_unlock(&table->array);
 
 	if (!srq)
-- 
2.20.1

