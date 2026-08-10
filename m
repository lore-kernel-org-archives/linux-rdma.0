Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734FD442B04
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 19:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786391455; cv=none; b=J1tYHiyw52ffRbHj8UBrj6s9w9HMIYXOhmktDef+ajhn2ZCNWftG1ryg6hG+X6Us0zFCGQOF5Y/GlRhKzbMPQPbyi41OOEgZ9zuEjNMgYq0z03sErJd8pWv33m6X9AMuvmJlfDy0QkBdjojDK2PczoTp4LMIign/UMU/H+CQdvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786391455; c=relaxed/simple;
	bh=DpoLih1PcP1k7ATY/YpwCBeYW+iX+D+/PGns6KtbHsg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SN7GNhSqFn0jvPsF0jkvrdAKWSJgBhIjrWjmfnBus3QH84YzAa8CLqytTA9qIRl+ro99I8gWlT5mca9or4q5rJhzMyce6PU5DG6mD6mZ5bE1A98P+yBU0X0u8K4TMzmmokxNPvwf7zzjxVNsEkCsG/IhDuAKDcgq9FrxljYTr+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dbc59f1P; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dbc59f1P"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso2761775a91.3
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 12:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786391452; x=1786996252; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VcYKmOJeHZ340ymkvpq1SUtt9jjLj7DE6k/D4ssp5QU=;
        b=dbc59f1P4KzBA4hLzz0lEZa6t6X47EK1J5yXcYG+NCVB5Y8oSdjjzShOEcz5QKk0Et
         kxrmSzCoPs9e6QJhoPIXgWF9T+7Gu34NFVoUiZJTpZClKbGlatN2vsxybtoeBGyAtEoE
         2p3IKfnusvhvgkRnnjrHAr1zA94V+PE1sFpwiDNrD6ovLHEqtcnbgpq9gl5WYJK06zk3
         Cpm1o2RYleWSq4mwzqnE9Eue91QGFeRNK/9S48vvCvRqItRhzMtvWfEjc7BrozEu95ni
         k9bcZXW6r9YHsHpK3gi0/vJrwZNM1yjoSY4teDfd6NaURy1v4Ja287fNAN74drGnsYjC
         RtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786391452; x=1786996252;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VcYKmOJeHZ340ymkvpq1SUtt9jjLj7DE6k/D4ssp5QU=;
        b=MRkKKyEKAbbpV4W3bdiINXt5JvwhDi2+IgWfo1y+YnZilg+OB9ZZFSTucRbkayj5BP
         0iZNOd4J2ddqy2Yd0KIGpllg1dMAxGXw1Uk3vhCXq3oorL+Wm802yGi++WOWINKLvYMm
         nVd0E6bG9QbClD86swLIy0LumWVpsyr6SXKigQzfOOBcurIu3R/BL2MOESDogI4s9hSq
         fVyeR5G75WQs3gmrcWp+raBwqgPFsM99NCqsV4mGxbbAAqr8GBoo1DM6nxpNTSZ0AQng
         R2Yfux1w8CDvh44I1yr1DB6EyQ0xHqtFFzMgxKPLX2UNNhGssq9nUv3ir2n2pk8YOo6e
         0UsA==
X-Forwarded-Encrypted: i=1; AHgh+RonPff3TncaQPkqNV6HJIFjmDJz8fDYc8hTN3blPudM4Llf3IJTfkc2HcHufisy4R8vnr9Etct1dWXu@vger.kernel.org
X-Gm-Message-State: AOJu0YwBYWxU/4ERkKQczSiWb3OgN5Ov8MZ1o11lc/41OYyg7pfPGelc
	MmgZHn9rpvC9AbUkXyiV2dX9IGI3d5XqVDKj68wlDsAHvYFhb52PfzazoX7LI8p7d1O7dxfTwmX
	Sfw==
X-Received: from dybrq15.prod.google.com ([2002:a05:7301:468f:b0:313:d984:da01])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5444:b0:381:1f51:1ff0
 with SMTP id 98e67ed59e1d1-392821fc107mr22534242a91.2.1786391451507; Mon, 10
 Aug 2026 12:50:51 -0700 (PDT)
Date: Mon, 10 Aug 2026 19:50:38 +0000
In-Reply-To: <20260810195040.2877784-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260810195040.2877784-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260810195040.2877784-5-praan@google.com>
Subject: [PATCH v5 4/5] nfs: migrate direct I/O to iov_iter_extract_pages
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

Migrate the NFS Direct I/O path away from the legacy
iov_iter_get_pages_alloc2() API to the modern iov_iter_extract_pages API.
The transition aligns NFS with the modern VFS extraction model and serves
as a preparatory step for supporting requirements such as page pinning
via GUP for DMA.

The migration fixes a bug in the Direct I/O loop where pages were being
unpinned immediately after request creation. With the new extraction
model, pins are held until the I/O is complete. Manual release in the
loop is correspondingly updated to only clean up failed pages.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Shivaji Kant <shivajikant@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/direct.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 96995736fac2..a1caef90f2f1 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -168,14 +168,8 @@ int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter)
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages,
 				     bool pinned)
 {
-	unsigned int i;
-
-	if (pinned) {
+	if (pinned)
 		unpin_user_pages(pages, npages);
-	} else {
-		for (i = 0; i < npages; i++)
-			put_page(pages[i]);
-	}
 }
 
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
@@ -354,16 +348,17 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	inode_dio_begin(inode);
 
 	while (iov_iter_count(iter)) {
-		struct page **pagevec;
+		struct page **pagevec = NULL;
 		size_t bytes;
 		size_t pgbase;
 		unsigned npages, i;
+		bool pinned = iov_iter_extract_will_pin(iter);
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
-						  rsize, &pgbase);
+		result = iov_iter_extract_pages(iter, &pagevec,
+						rsize, ~0U, 0, &pgbase);
 		if (result < 0)
 			break;
-	
+
 		bytes = result;
 		npages = (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
 		for (i = 0; i < npages; i++) {
@@ -371,7 +366,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			unsigned int req_len = min_t(size_t, bytes, PAGE_SIZE - pgbase);
 			/* XXX do we need to do the eof zeroing found in async_filler? */
 			req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
-							false, pgbase, pos,
+							pinned, pgbase, pos,
 							req_len);
 			if (IS_ERR(req)) {
 				result = PTR_ERR(req);
@@ -387,7 +382,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			requested_bytes += req_len;
 			pos += req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages, false);
+		if (i < npages)
+			nfs_direct_release_pages(pagevec + i, npages - i, pinned);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
@@ -891,13 +887,14 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 
 	NFS_I(inode)->write_io += iov_iter_count(iter);
 	while (iov_iter_count(iter)) {
-		struct page **pagevec;
+		struct page **pagevec = NULL;
 		size_t bytes;
 		size_t pgbase;
 		unsigned npages, i;
+		bool pinned = iov_iter_extract_will_pin(iter);
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
-						  wsize, &pgbase);
+		result = iov_iter_extract_pages(iter, &pagevec,
+						wsize, ~0U, 0, &pgbase);
 		if (result < 0)
 			break;
 
@@ -908,7 +905,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			unsigned int req_len = min_t(size_t, bytes, PAGE_SIZE - pgbase);
 
 			req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
-							false, pgbase, pos,
+							pinned, pgbase, pos,
 							req_len);
 			if (IS_ERR(req)) {
 				result = PTR_ERR(req);
@@ -952,7 +949,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			desc.pg_error = 0;
 			defer = true;
 		}
-		nfs_direct_release_pages(pagevec, npages, false);
+		if (i < npages)
+			nfs_direct_release_pages(pagevec + i, npages - i, pinned);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
-- 
2.55.0.679.g6767b8d81c-goog

