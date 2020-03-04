Return-Path: <SRS0=Cuj6=4V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F32C3F2D7
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Mar 2020 00:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8695320716
	for <linux-rdma@archiver.kernel.org>; Wed,  4 Mar 2020 00:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="CDsrTTQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgCDAOH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 3 Mar 2020 19:14:07 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8634 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgCDAOH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 3 Mar 2020 19:14:07 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e5ef27a0000>; Tue, 03 Mar 2020 16:12:42 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 03 Mar 2020 16:14:06 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 03 Mar 2020 16:14:06 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Mar
 2020 00:14:05 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 4 Mar 2020 00:14:04 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e5ef2cc0000>; Tue, 03 Mar 2020 16:14:04 -0800
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <dri-devel@lists.freedesktop.org>, <linux-rdma@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>
CC:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Ralph Campbell" <rcampbell@nvidia.com>
Subject: [PATCH v3 3/4] nouveau: remove useless SVM range check
Date:   Tue, 3 Mar 2020 16:13:38 -0800
Message-ID: <20200304001339.8248-4-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304001339.8248-1-rcampbell@nvidia.com>
References: <20200304001339.8248-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583280763; bh=vB+trDSuLSZgp1ZOL55I9rZDa5MX61pMtV0fQU5N0qM=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=CDsrTTQ8pY5pG33TP6l7tXy7WdVnY2xVi29qfeq5B5HqKDb0hWDZhUJJ7TY5HFBTJ
         9WHIq82JD/948lrbYaa4gLs+kAX2ns+b1CWLwDhOtonoNWsTi7oyhkjHxsZQzZwcDD
         iSohE4/HBhMVKuLHbYmG0NagA/pxYYrJtpb1V4XhVDwTqJ3nDNzSh8WffyFm0srqmy
         8TtZN6MUA2bAgyxwnsOGddf+j5UeWGQvRrZiO6S9r+SuHtH+E0W9fZGR2rsVfw8SN1
         ZVNou5ztQYlIJfPYbuCUSWMmFFJAE7kNZqGPyCzjypAZb9WL1wsZHioNldhKe7XxXx
         xe1jYvS50nTwg==
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When nouveau processes GPU faults, it checks to see if the fault address
falls within the "unmanaged" range which is reserved for fixed allocations
instead of addresses chosen by the core mm code. If start is greater than
or equal to svmm->unmanaged.limit, then limit will also be greater than
svmm->unmanaged.limit which is greater than svmm->unmanaged.start and the
start =3D max_t(u64, start, svmm->unmanaged.limit) will change nothing.
Just remove the useless lines of code.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouvea=
u/nouveau_svm.c
index c567526b75b8..8dfa5cb74826 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -663,9 +663,6 @@ nouveau_svm_fault(struct nvif_notify *notify)
 		limit =3D start + (ARRAY_SIZE(args.phys) << PAGE_SHIFT);
 		if (start < svmm->unmanaged.limit)
 			limit =3D min_t(u64, limit, svmm->unmanaged.start);
-		else
-		if (limit > svmm->unmanaged.start)
-			start =3D max_t(u64, start, svmm->unmanaged.limit);
 		SVMM_DBG(svmm, "wndw %016llx-%016llx", start, limit);
=20
 		mm =3D svmm->notifier.mm;
--=20
2.20.1

