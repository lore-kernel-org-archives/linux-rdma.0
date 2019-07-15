Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BC6C76180
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 03:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B26520644
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 03:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LY3qzOeD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfGODSH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 14 Jul 2019 23:18:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42004 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfGODSG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 14 Jul 2019 23:18:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so6988775pgb.9;
        Sun, 14 Jul 2019 20:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=horPniHtCOrCbtjJGbMsBrLAEBAMYQ0ulMSC1EfYk9s=;
        b=LY3qzOeDUYPbiF4AyhlsbEs4s6BBEVwmbqLY9bEKLLzy9N5t7ZraQZ+3fB21PBZNnc
         FrnuiKjMC09Lf92j3wJ4J68NjtnkFMaBvoeg7eA+hPcF4k8+W6khrufTL8xutQ0515I0
         pKulzBIKJCQgOwXra6h5v9MX2MgF4q6ZisJKFKczhZ2P5/ZwVNnXGkR8cy4jTJhN/Dmq
         VzBI1fHBGLxVWQTR3zaZ8ugV14TIvPcQLVQ1YjRNPuN5wLFa3/DPxe0Sa8c4AWlGUD3v
         ttrnqWU/L8H7ecAUIfBCWFks1A536egHK6fvgbOGvrIIPOFvgYzFpoM/NchMgic7rj4i
         38fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=horPniHtCOrCbtjJGbMsBrLAEBAMYQ0ulMSC1EfYk9s=;
        b=P3KUXjLRPG0uaiGsGSgjwIfh39iJ+q9S7OYIIiesGn/7qJ5cAoYW1hgUJVKPUfjnfQ
         CNVi3sS0D+DBJNnP6R2d9RwC+im+GRtEnJttdzWqIx2j803cxSw+AvMR6g6JtP3hOlhk
         twlA0giSPK7c0E31o66vx4bgZk7DYzZXStV3ElZpAqhKI+TT6/E+EcFJ2Ly6W1kduABN
         Y2F5CmZ4VmT9MHt4TgGjsO6BDvYMV59e1kATfk7L6hSylhZKBUIbEaxAstjf/nu/aMsx
         DXpPAbWQ+Y3lkaadYdTZHVfZKs04ZX9uTDZQL++hfcZdvOznDB+KBG5Vvc72Cxs6IuBn
         bmbw==
X-Gm-Message-State: APjAAAXw1vY+4rDOSLxFGOU/AcvtDy/cXANm9hdbR/08UHtSKrfLBK6S
        B7yJqsrEYWW62a0OYyqi+Ak=
X-Google-Smtp-Source: APXvYqzehMyvaONwl35W3Ob/8vg38uINCvt4n5KPhjlioiGe9T3yfuphEMhRyGl1R0ct7N8ED2xa0g==
X-Received: by 2002:a17:90a:2008:: with SMTP id n8mr26354202pjc.4.1563160685849;
        Sun, 14 Jul 2019 20:18:05 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id v12sm14270842pjk.13.2019.07.14.20.18.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 20:18:05 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v3 09/24] rdma/hns: Remove call to memset after dma_alloc_coherent
Date:   Mon, 15 Jul 2019 11:17:59 +0800
Message-Id: <20190715031759.6606-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v3:
  - Use actual commit rather than the merge commit in the commit message

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 3afd3e9330e7..a43464e292b6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -4265,7 +4265,6 @@ static int hns_roce_v1_create_eq(struct hns_roce_dev *hr_dev,
 		}
 
 		eq->buf_list[i].map = tmp_dma_addr;
-		memset(eq->buf_list[i].buf, 0, HNS_ROCE_BA_SIZE);
 	}
 	eq->cons_index = 0;
 	roce_set_field(tmp, ROCEE_CAEP_AEQC_AEQE_SHIFT_CAEP_AEQC_STATE_M,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b5392cb5b20f..a4a7c5962916 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1774,7 +1774,6 @@ static int hns_roce_init_link_table(struct hns_roce_dev *hr_dev,
 			goto err_alloc_buf_failed;
 
 		link_tbl->pg_list[i].map = t;
-		memset(link_tbl->pg_list[i].buf, 0, buf_chk_sz);
 
 		entry[i].blk_ba0 = (t >> 12) & 0xffffffff;
 		roce_set_field(entry[i].blk_ba1_nxt_ptr,
@@ -5387,8 +5386,6 @@ static int hns_roce_mhop_alloc_eq(struct hns_roce_dev *hr_dev,
 		eq->cur_eqe_ba = eq->l0_dma;
 		eq->nxt_eqe_ba = 0;
 
-		memset(eq->bt_l0, 0, eq->entries * eq->eqe_size);
-
 		return 0;
 	}
 
-- 
2.11.0

