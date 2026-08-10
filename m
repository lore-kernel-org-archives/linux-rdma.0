Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EE7442FD2
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 19:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786391449; cv=none; b=ntKXK9caVG1fr6N+cCzBZBN/Ns9ihdLWhX+5EaVU7rWxbAPyyIzA3LHiEQkAmSsMfHkmkVDPGnCOB/uaELkt7LHpKh+KXILjRKpCTXlPN/0gnkSxaTSMfP1DTmmSRRN3LR+kFszz4Fco4Ld1gUF2+U5P/03u+/zGup9f7gL0mD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786391449; c=relaxed/simple;
	bh=9RX6Aq76qJMqf8LtuacV4nuPpbTB3rALE9qg6WfOqT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e8ApS3hWO01iCe0+ttX8yXLxWSHlw0iKaszy6+BjMw4pfUWMIvLyOq5Y1jCclo/8FG0DaH93SbD7bfQ6VRP59c8JANo7l0IGUtAMNKz/u+z8aclvogiT6+4cPegUPrIUlhN7dxeahMqvJLgPmOE8UQ46ZgcHD/KBDFqZJd5MRjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t1eLhBsi; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t1eLhBsi"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so53337885ad.2
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 12:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786391447; x=1786996247; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C2ERQlktAlPM+wEaWp5zzj9NSzqVJxPOg25/iwvVmrE=;
        b=t1eLhBsice/7Rq2BEYzwD/hzwue7gAKa/9gc7ggUeTr++cHbmPf4gYkyanoxjM9ggs
         trgscCxV+UvS7Pjv/Rfg/Lx8ljTz91gIiQjX1mm5WxRyKOY3oasRTZ4hD5gyWMG0kqIA
         5Yukfq17QTRupSNfZJ4X0r0QH3tt/fS4z4y5TffEVz9vDwBZNOPvunEnTqM83oWkhJT5
         v+SdDzzsBtxr2ZeDYVjz4x2tTh53aKGaqqHxhBQSrn1huogOtaH5dpv0yEFLeL+laBk1
         gTxiRiCE2Z1nCEFDikUPjgSKq8hVl21tIJubRencliRm0uyNaVCk/2JsxLBIIxr62ZUI
         16Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786391447; x=1786996247;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C2ERQlktAlPM+wEaWp5zzj9NSzqVJxPOg25/iwvVmrE=;
        b=tM6NWUEdg5piYE60RQYj2Jz7spTZoUj7X8IMDPWOkmpRlhvNwxHrT5r9+h9q0jnRh9
         Q0QDAeB0rqccTS50DCsBf/DnTXvq4KzBY1TiQewAugpmjiepJlYZIOAsJcLowBd0B6/b
         b9kRrxRUNJx6iOQphxkDOTlgEhCRY6H85np5g9trezypiayw5xScBFjTfmnM/NtUgxEf
         6hi33BSI+2sFqU9TV9R6Qafdreeqlj+m6SSg+/6bv6+XvNls8639EJpX454fP0rEZEiW
         ve9G4Q5FamFolG+P3qx6idRHacX/6bnhsX6EdYWUpglwY11TbBE9NCi5Py0kG+3k3D3a
         tJdA==
X-Forwarded-Encrypted: i=1; AHgh+RqS66zpfQxvP+Q1vvSptN0lF8igmuzZf3yci3+gv/Y76loxa10MLIyhfLcFEKEVoB5bV4yaTKCz96eH@vger.kernel.org
X-Gm-Message-State: AOJu0YzxVjvxL9DOEVyJSb9cunAuqnYhjAy94POwXcuwTuMQgt/GiY+4
	HEfRbSM52gJLcH0exPMsGoT4U/+JRXXh9ySjE4aIxq2IJWP4GqgITN47blLhNUrR1CNlEr+4cKk
	fCA==
X-Received: from plhw6.prod.google.com ([2002:a17:903:2f46:b0:2ca:bb31:40b9])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:13c7:b0:2ce:9c48:22d3
 with SMTP id d9443c01a7336-2d30033718fmr51730635ad.11.1786391447250; Mon, 10
 Aug 2026 12:50:47 -0700 (PDT)
Date: Mon, 10 Aug 2026 19:50:36 +0000
In-Reply-To: <20260810195040.2877784-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260810195040.2877784-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260810195040.2877784-3-praan@google.com>
Subject: [PATCH v5 2/5] nfs: track number of pinned pages in nfs_page
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

Track the number of pinned pages in nfs_page to handle unpinning
correctly, ensuring that only primary requests perform the final
unpinning operation, preventing subrequests from incorrectly
performing unpinning on behalf of their parent requests.

Add wb_nr_pinned to struct nfs_page to store the count of pinned pages
owned by the request. Update request creation and cleanup helpers to
initialize and use wb_nr_pinned for primary requests. Use the
nfs_page_array_len() helper to calculate the number of pages spanned
by a request's offset and length.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 fs/nfs/pagelist.c        | 9 +++++++--
 include/linux/nfs_page.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 606b518fa204..c307daf5f68d 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -457,6 +457,8 @@ struct nfs_page *nfs_page_create_from_page(struct nfs_open_context *ctx,
 			      offset_in_page(offset), count);
 	if (!IS_ERR(ret)) {
 		nfs_page_assign_page(ret, page, pinned);
+		if (pinned)
+			ret->wb_nr_pinned = 1;
 		nfs_page_group_init(ret, NULL);
 	}
 	nfs_put_lock_context(l_ctx);
@@ -489,6 +491,9 @@ struct nfs_page *nfs_page_create_from_folio(struct nfs_open_context *ctx,
 	ret = nfs_page_create(l_ctx, offset, folio->index, offset, count);
 	if (!IS_ERR(ret)) {
 		nfs_page_assign_folio(ret, folio, pinned);
+		if (pinned)
+			ret->wb_nr_pinned = nfs_page_array_len(offset_in_page(offset),
+							      count);
 		nfs_page_group_init(ret, NULL);
 	}
 	nfs_put_lock_context(l_ctx);
@@ -567,14 +572,14 @@ static void nfs_clear_request(struct nfs_page *req)
 
 	if (folio != NULL) {
 		if (test_and_clear_bit(PG_PINNED, &req->wb_flags))
-			unpin_user_folio(folio, 1);
+			unpin_user_folio(folio, req->wb_nr_pinned);
 		else
 			folio_put(folio);
 		req->wb_folio = NULL;
 		clear_bit(PG_FOLIO, &req->wb_flags);
 	} else if (page != NULL) {
 		if (test_and_clear_bit(PG_PINNED, &req->wb_flags))
-			unpin_user_page(page);
+			unpin_user_pages(&page, req->wb_nr_pinned);
 		else
 			put_page(page);
 		req->wb_page = NULL;
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index fd7aafe7cb54..080fa3e23580 100644
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -59,6 +59,7 @@ struct nfs_page {
 	struct nfs_page		*wb_this_page;  /* list of reqs for this page */
 	struct nfs_page		*wb_head;       /* head pointer for req list */
 	unsigned short		wb_nio;		/* Number of I/O attempts */
+	unsigned int		wb_nr_pinned;	/* Number of pinned pages */
 };
 
 struct nfs_pgio_mirror;
-- 
2.55.0.679.g6767b8d81c-goog

