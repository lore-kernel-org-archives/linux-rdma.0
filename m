Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B49DC433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 21:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B9C920675
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 21:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="PFMTomRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgEMVpf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 17:45:35 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16462 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbgEMVpf (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 13 May 2020 17:45:35 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebc6a720000>; Wed, 13 May 2020 14:45:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 May 2020 14:45:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 May 2020 14:45:34 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 May
 2020 21:45:32 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 May 2020 21:45:32 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ebc6a7c0001>; Wed, 13 May 2020 14:45:32 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-rdma@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        "Ralph Campbell" <rcampbell@nvidia.com>
Subject: [PATCH] mm/hmm/test: destroy xa_array instead of looping
Date:   Wed, 13 May 2020 14:45:07 -0700
Message-ID: <20200513214507.30592-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589406322; bh=mUTdF1AVMZd0iSCg3E8fEbaYihKH2WAzpFyYOhyV/OU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=PFMTomRMAVJQ+UmxKAlAwof1dFot0qpMAJ1vATc+rjN6uEFZzlhYJjSuMLTODsPgc
         K1PGvX4Bl+rKy4f/9/TuNUPRXrd8vGl4tU9aHkqJKDonNKUipJOOOgodwCMSd9YrMw
         0krWiaadjXUzTUkp7oLKOHZCjMyG14aKfhQeB8UVeMwu87bAoRYJuiF7RseMI3/pjg
         b9UQxFVFq45A+LHLKLIOTboyOgW1OKpwRmzNoQx6GCVok9yNkgqS9kavltRa4ARTUv
         cqFpoLFZXI0zCycLGP/OhkT0QgR3adaoJhqku3WXCke7DZF2GZD3THkRh8Gtdqf+Cn
         tifp6KhgVPa1g==
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The test driver uses an xa_array to store virtual to physical address
translations for a simulated hardware device. The MMU notifier
invalidation callback is used to keep the table consistent with the CPU
page table and is frequently called only for a page or two. However, if
the test process exits unexpectedly or is killed, the range can be
[0..ULONG_MAX] in which case calling xa_erase() for every possible PFN
results in CPU timeouts. Munmap() can result in a large range being
invalidated but in that case, the xa_array is likely to contain entries
that need to be invalidated.
Check for [0..ULONG_MAX] explicitly and just destroy the whole table.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---

This patch is based on Jason Gunthorpe's hmm tree and should be folded
into the ("mm/hmm/test: add selftest driver for HMM") patch once this
patch is reviewed, etc.

 lib/test_hmm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 8b36c26b717b..b89852ec3c29 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -201,7 +201,13 @@ static void dmirror_do_update(struct dmirror *dmirror,=
 unsigned long start,
 	 * The XArray doesn't hold references to pages since it relies on
 	 * the mmu notifier to clear page pointers when they become stale.
 	 * Therefore, it is OK to just clear the entry.
+	 * However, if the entire address space is being invalidated, it
+	 * takes too long to clear them one at a time so destroy the array.
 	 */
+	if (start =3D=3D 0 && end =3D=3D ULONG_MAX) {
+		xa_destroy(&dmirror->pt);
+		return;
+	}
 	for (pfn =3D start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++)
 		xa_erase(&dmirror->pt, pfn);
 }
--=20
2.20.1

