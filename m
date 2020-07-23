Return-Path: <SRS0=2hsX=BC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E62C43457
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jul 2020 22:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6051A20792
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jul 2020 22:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="E3+/KAUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGWWbB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 23 Jul 2020 18:31:01 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13898 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgGWWaw (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 23 Jul 2020 18:30:52 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f1a0f5b0000>; Thu, 23 Jul 2020 15:29:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 23 Jul 2020 15:30:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 23 Jul 2020 15:30:50 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Jul
 2020 22:30:41 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 23 Jul 2020 22:30:40 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f1a0f900000>; Thu, 23 Jul 2020 15:30:40 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-rdma@vger.kernel.org>, <linux-mm@kvack.org>,
        <nouveau@lists.freedesktop.org>, <kvm-ppc@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        "Ben Skeggs" <bskeggs@redhat.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        "Ralph Campbell" <rcampbell@nvidia.com>
Subject: [PATCH v4 1/6] nouveau: fix storing invalid ptes
Date:   Thu, 23 Jul 2020 15:29:59 -0700
Message-ID: <20200723223004.9586-2-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200723223004.9586-1-rcampbell@nvidia.com>
References: <20200723223004.9586-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595543388; bh=rz9ii3/rSLaotraZODv9PDOOFrnasJhkv9z9XY7GWhs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=E3+/KAUUqwLXLfwvdT+lj/P9kOToRLPz0UK75f70li06/p9lJdiPkbhtDmlv4gQjs
         ti6s6fgiX2LRqmQgf/03a4snWnkf0qBpsNXnxIUiqPGgf7gFl2EDegk9ceNBbcz3Wn
         KsDYf4gPKfuCFPIRc++kdUK7kWQWvirXBbrsJtJ5MON8nVXPKQnio9sYYOlbFFvdEe
         R8s0IatMhkVom7f3Hx3lPBLIJwLqpGN6jUEPXhHqySKWoaxFhDLmNhkqytuD0KlctL
         zAaKcWE5GGFzHyBKFlfhERPiWPOUWUsjcSk90ptH6VBrMLqT5WG4BzoW5Za5NeYACA
         VtOx3M32JqeBw==
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

When migrating a range of system memory to device private memory, some
of the pages in the address range may not be migrating. In this case,
the non migrating pages won't have a new GPU MMU entry to store but
the nvif_object_ioctl() NVIF_VMM_V0_PFNMAP method doesn't check the input
and stores a bad valid GPU page table entry.
Fix this by skipping the invalid input PTEs when updating the GPU page
tables.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c b/drivers/g=
pu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
index ed37fddd063f..7eabe9fe0d2b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
@@ -79,8 +79,12 @@ gp100_vmm_pgt_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu_=
pt *pt,
 	dma_addr_t addr;
=20
 	nvkm_kmap(pt->memory);
-	while (ptes--) {
+	for (; ptes; ptes--, map->pfn++) {
 		u64 data =3D 0;
+
+		if (!(*map->pfn & NVKM_VMM_PFN_V))
+			continue;
+
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |=3D BIT_ULL(6); /* RO. */
=20
@@ -100,7 +104,6 @@ gp100_vmm_pgt_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu=
_pt *pt,
 		}
=20
 		VMM_WO064(pt, vmm, ptei++ * 8, data);
-		map->pfn++;
 	}
 	nvkm_done(pt->memory);
 }
@@ -310,9 +313,12 @@ gp100_vmm_pd0_pfn(struct nvkm_vmm *vmm, struct nvkm_mm=
u_pt *pt,
 	dma_addr_t addr;
=20
 	nvkm_kmap(pt->memory);
-	while (ptes--) {
+	for (; ptes; ptes--, map->pfn++) {
 		u64 data =3D 0;
=20
+		if (!(*map->pfn & NVKM_VMM_PFN_V))
+			continue;
+
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |=3D BIT_ULL(6); /* RO. */
=20
@@ -332,7 +338,6 @@ gp100_vmm_pd0_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu=
_pt *pt,
 		}
=20
 		VMM_WO064(pt, vmm, ptei++ * 16, data);
-		map->pfn++;
 	}
 	nvkm_done(pt->memory);
 }
--=20
2.20.1

