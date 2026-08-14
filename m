Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF2A477E27
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717995; cv=none; b=rOl5+9VO8oMWQ62EzUSeS3ZFb+ts88LF/qKYIIRPAgOy4MbP2EkYL6N3O6ehiJmELYh0XvSCLnZ9GXLEhwuD5M3hpWbSVrJhWJB3ZXc2xmmbrvq7ILYUk3zhiMP7eXGTZmgMYz5nGIpK0Z2beWyubNfXaXHR+VVCw7ud6fD5/fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717995; c=relaxed/simple;
	bh=iznWeDCf/xVMjXe2dlj/pF4NEFalcZlXzwz9e4tzuwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qMJjx44rOBWhKRgr3rG1O0j6hs7Iw9LFBWw9wq/zNNbtXjXGRWeHlts2JR/2JqO6iEob+y8jFvd5WuAKcE1hmpWFkt05ypdJI+i4AN1FvilEj1239IKUq+K8WMaU7CwBjALeBcHUNGb8UzXR3Kz46PpO9g1qIb/N8+a4zVdW6u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+JFzrRJ; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+JFzrRJ"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb48f41343aso1567681a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 07:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786717989; x=1787322789; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dgzo1tF03PdbXxJfwkTkV/zmue9zVVPZETKq5+mYuVg=;
        b=J+JFzrRJTgvYfIImJMx4kIo38OqTdn+S4tEc5CUekyyvyTezCdT254LY9rdmhUxt71
         vBPIVS//Fg0PSG2P5ChqymvRU+bRg/N53YjtdTEWB6MnFvCJn2i09cn/GPM8ExGrbkrb
         XcL9p/rDKmAkxd2psyJqiSHWruz2xTFOL2A/kLMTp4deotLl42HnnMMfdQQW2s853hje
         EEI+BIUKXwoK1Td8cNCnRgIDnL9BTd+ekbjg82EOaFryAicg0VUS4ebYxu6Xa9rGB3G4
         p/gLTZnhsNpPk1GIQ1NWO52wZlqNNtxkNju6KMS2Me7pxg/01pcBCO2TkuuTqNTkg3sY
         Mzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786717989; x=1787322789;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dgzo1tF03PdbXxJfwkTkV/zmue9zVVPZETKq5+mYuVg=;
        b=QIM1/0HtPyK7lNy9ICmZ5V+5yhREWlEbviX8kU4MJMi6aCyDTUONCSY7tm1UT3D/RU
         ZQBu6KUOGdPsBbAlYjfQ+Vbvycs2Y2WaZmmm9Y6L06qa+dMB6gq/diqbG9XFNWfDeQCe
         9gWoCJvJRQ2dLh4zLHHtwy06fanPjpo+sRR0nbTaKdLgDWlmIA7rv9ooHBkNN8SPcArU
         /030hXW9qutYOZpCUiHsux5V4LoCFumQrz/Lfn36C0VaMSzS1K5ulDHoOWAq+rnBCdrB
         XRSku3aovLLvDQ8L4KzQMpVkXm8Gafdj5pADedYnbDTjTbxkqyX7pYEiHk4qCZMBtS3V
         UjQA==
X-Forwarded-Encrypted: i=1; AHgh+Rru1Hy+23quHRaRCuo+q2tKAVUPLv2EauBHyrPKH1XFJEqRURmQHXX5DtGSztxOBtH+Yqrydv+AzLri@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4rYfEujr8rZmDNLPcMZjRyf2m6KAPDSDnAdZurqWW6noHtpr6
	kWnFESgl1/6mxj2YzJPDMB03Ku4zJ7dPofZWlIEQOsqmjhuBQlKGNfpZXdZ4+hIydM1ReDE3Gro
	UJw==
X-Received: from pjkx5.prod.google.com ([2002:a17:90a:7885:b0:38e:a556:bb27])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d407:b0:38e:4f42:d0d6
 with SMTP id 98e67ed59e1d1-3933b09f4f3mr4912072a91.12.1786717988724; Fri, 14
 Aug 2026 07:33:08 -0700 (PDT)
Date: Fri, 14 Aug 2026 14:32:53 +0000
In-Reply-To: <20260814143255.861084-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260814143255.861084-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260814143255.861084-4-praan@google.com>
Subject: [PATCH v6 3/5] nfs: introduce nfs_release_request_list helper
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a centralized helper, nfs_release_request_list, to handle
the bulk release of nfs_page requests from a list.

This serves as a preparatory step for two upcoming improvements:

   1. Pin-Aware Cleanup: As we migrate to iov_iter_extract_* API,
      requests will hold pins (GUP) instead of standard references. The
      helper ensures that the correct unpinning logic gets applied
      consistently across all requests in a list.

   2. Folio Support: In subsequent patches where nfs_page structures
      will cover multi-page folios, this helper provides a clean
      infrastructure to unlock these larger units of I/O in bulk during
      completion, similar to the pattern in bio_release_pages.

Additionally, refactor nfs_read_sync_pgio_error() to utilize this new
helper.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Shivaji Kant <shivajikant@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/direct.c          |  8 +-------
 fs/nfs/pagelist.c        | 17 +++++++++++++++++
 include/linux/nfs_page.h |  4 ++--
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 19792a38c924..96995736fac2 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -314,13 +314,7 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
 
 static void nfs_read_sync_pgio_error(struct list_head *head, int error)
 {
-	struct nfs_page *req;
-
-	while (!list_empty(head)) {
-		req = nfs_list_entry(head->next);
-		nfs_list_remove_request(req);
-		nfs_release_request(req);
-	}
+	nfs_release_request_list(head);
 }
 
 static void nfs_direct_pgio_init(struct nfs_pgio_header *hdr)
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index b9ccf2a87e3c..71f0ce2bc4ea 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -628,6 +628,23 @@ void nfs_release_request(struct nfs_page *req)
 }
 EXPORT_SYMBOL_GPL(nfs_release_request);
 
+/*
+ * nfs_release_request_list - Release a list of NFS read/write requests
+ * @head: list of requests to release
+ *
+ * Removes each request from the list and drops it's refcount.
+ */
+void nfs_release_request_list(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct nfs_page *req = nfs_list_entry(head->next);
+
+		nfs_list_remove_request(req);
+		nfs_release_request(req);
+	}
+}
+EXPORT_SYMBOL_GPL(nfs_release_request_list);
+
 /*
  * nfs_generic_pg_test - determine if requests can be coalesced
  * @desc: pointer to descriptor
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index 080fa3e23580..c38e4b380be5 100644
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -136,8 +136,8 @@ extern struct nfs_page *nfs_page_create_from_folio(struct nfs_open_context *ctx,
 						   bool pinned,
 						   unsigned int offset,
 						   unsigned int count);
-extern	void nfs_release_request(struct nfs_page *);
-
+void nfs_release_request(struct nfs_page *req);
+void nfs_release_request_list(struct list_head *head);
 
 extern	void nfs_pageio_init(struct nfs_pageio_descriptor *desc,
 			     struct inode *inode,
-- 
2.55.0.691.gc56d675ccc-goog

