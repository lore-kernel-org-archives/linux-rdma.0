Return-Path: <SRS0=MKZB=ZE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C2BC43331
	for <linux-rdma@archiver.kernel.org>; Tue, 12 Nov 2019 15:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA3721872
	for <linux-rdma@archiver.kernel.org>; Tue, 12 Nov 2019 15:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKLPTA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 12 Nov 2019 10:19:00 -0500
Received: from verein.lst.de ([213.95.11.211]:56369 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbfKLPTA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 12 Nov 2019 10:19:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 02B8368BE1; Tue, 12 Nov 2019 16:18:57 +0100 (CET)
Date:   Tue, 12 Nov 2019 16:18:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Shuah Khan <shuah@kernel.org>, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm/hmm: make full use of walk_page_range()
Message-ID: <20191112151856.GB12550@lst.de>
References: <20191104222141.5173-1-rcampbell@nvidia.com> <20191104222141.5173-2-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104222141.5173-2-rcampbell@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although we could clean this up a tidbit more by removing the start
variable:

diff --git a/mm/hmm.c b/mm/hmm.c
index d4984a08ed9b..b5b1ed646c2f 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -667,10 +667,9 @@ static const struct mm_walk_ops hmm_walk_ops = {
  */
 long hmm_range_fault(struct hmm_range *range, unsigned int flags)
 {
-	unsigned long start = range->start;
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
-		.last = start,
+		.last = range->start,
 		.flags = flags,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -682,9 +681,8 @@ long hmm_range_fault(struct hmm_range *range, unsigned int flags)
 		/* If range is no longer valid force retry. */
 		if (mmu_range_check_retry(range->notifier, range->notifier_seq))
 			return -EBUSY;
-		ret = walk_page_range(mm, start, range->end, &hmm_walk_ops,
-				      &hmm_vma_walk);
-		start = hmm_vma_walk.last;
+		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
+				      &hmm_walk_ops, &hmm_vma_walk);
 	} while (ret == -EBUSY);
 
 	if (ret)
