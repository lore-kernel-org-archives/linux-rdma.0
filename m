Return-Path: <SRS0=7pIb=7X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0958FC433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jun 2020 17:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F33204EC
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jun 2020 17:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWMUrYot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgFJRsY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgFJRsY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 10 Jun 2020 13:48:24 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1294C03E96B
        for <linux-rdma@vger.kernel.org>; Wed, 10 Jun 2020 10:48:23 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id q188so668326ooq.4
        for <linux-rdma@vger.kernel.org>; Wed, 10 Jun 2020 10:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xTZvuygL72GYD2NFze3lnUkH1LUqM4KvqbiN+Y+Zwl8=;
        b=BWMUrYotkgCdb0jeZYWF/PtHy8vYj9+v+1sj5Nn7rBeHDsQhao0dYmKxEkfAm3zY7X
         4EDJOPukWjLaRd6KS6sINHDRsQJHt3AFPPYaHDYFcMATNh/DxV+zk3+mMsaGf9y8UyJ/
         P0jT3rVJ4MZ51SrjkU5F/lbhcKBt7K0quK7ft/M6Kr1YMIVhTRPSDW/LuEk9MgB8SiZ/
         UvhVu7CHTowg6bGqr4kl18rj6GIobcrVfHZsM0hW98xXSkVp26QQlqVoPTr5QgqC6pWJ
         J1PhiTykfYcKr/Q4xQv/5nfmCQJE5R3OterIkR+NhhXpVpqXMtjNmlxtK7rzshSaU/uN
         Ie5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xTZvuygL72GYD2NFze3lnUkH1LUqM4KvqbiN+Y+Zwl8=;
        b=G606tsbj3rd5ZRtF5ApureDobGiomKbRwAQOcMblI4qtHTjs5AMNKq/sMdSa7OPvPG
         TZQ8KWl8aQ7NEV4cWnlosd673LeSpuU0sNhU1rNDCGEDOxKSf028o7Qp1rJWredw6u3Y
         inhZjwNQqZrmur1hUGcyqAw90G+QVic0nT3tYeqYnirRpfjzOgE8G+n9mYZH/4qdOUQt
         LQSz1EuPLnlZGEWatPiXRPtxXawg90XFx9FROJ7OTfP140WtA4LJgyULT19DBRDRW0i3
         VwkJ+I8RUvonOOzLXbgt0oj38PpVuIIhoWzJgApZx8YPWnqUe1+iXP4tGnQLwsjhqRAS
         gIRA==
X-Gm-Message-State: AOAM531ug3ssP/46uYYhnq0Sgge3kTT5Mky6Z5hv8dyCX5bvoakdMAuM
        WkhyZ7vFSkbIWHXDhGluikB7NhSEneA=
X-Google-Smtp-Source: ABdhPJxOqSoMifpMf/jQHgbf4f1p7cgfPaaw2yhAQcwDGBm3MXyAGT0HCfkO+VJ2ccZmAsyJ+Zpmsw==
X-Received: by 2002:a4a:db4b:: with SMTP id 11mr3524072oot.11.1591811302713;
        Wed, 10 Jun 2020 10:48:22 -0700 (PDT)
Received: from proxmox.local.lan ([2605:6000:1b0c:4825:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id m13sm122386oou.25.2020.06.10.10.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 10:48:22 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     tseewald@gmail.com, Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH next] siw: Fix pointer-to-int-cast warning in siw_rx_pbl()
Date:   Wed, 10 Jun 2020 12:47:17 -0500
Message-Id: <20200610174717.15932-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The variable buf_addr is type dma_addr_t, which may not be the same size
as a pointer.  To ensure it is the correct size, cast to a uintptr_t.

Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 650520244ed0..7271d705f4b0 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -139,7 +139,8 @@ static int siw_rx_pbl(struct siw_rx_stream *srx, int *pbl_idx,
 			break;
 
 		bytes = min(bytes, len);
-		if (siw_rx_kva(srx, (void *)buf_addr, bytes) == bytes) {
+		if (siw_rx_kva(srx, (void *)(uintptr_t)buf_addr, bytes) ==
+		    bytes) {
 			copied += bytes;
 			offset += bytes;
 			len -= bytes;
-- 
2.20.1

