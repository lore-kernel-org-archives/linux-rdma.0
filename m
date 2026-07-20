Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE97432E91
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784559996; cv=none; b=I2FxmL789ilcKYF9Olo6Ou4tLGtEAkPx3+8VyW5v81g+RX+xvFQcXEDsC8IUsnxZmESLHFuxF99Qx5x/BQYZy3vv5Oc/2VQiorohAmBlYsaI5VubYfVYmww+kVblUnaa67oSEnsbbTQMBM42xAJcUcAJevXVRShdpQV34lwVpG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784559996; c=relaxed/simple;
	bh=uHl1U9uqrn0K6pJWxrCywcw/LqoTgBI8N0t/dHCfA0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YAlDaJJQOfpNT288ASBRyLx/rg93yoxlG7fAtdEaR+EBVuFZdvODL0nondWMI8vurgj8S4tz8BbAtlkTpAqpeT8YkLRc6BRv5AYzTq59sjU09BDkdWu0Uprn74yztUfQBbFJqEndSgUQ/YukWcoy30lFx6PVT6e+yTfttq+Oyok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IOxUjVPo; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IOxUjVPo"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cacd6d37edso138420565ad.0
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 08:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784559994; x=1785164794; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iEr3VNvmBkqEprXTi3pXlF49HoF9BORq25oSTaK+MZQ=;
        b=IOxUjVPoR4z3ZzWeLtENBcF3FDNb21BqoZg/JjOW32uWsKIC4avYISG1sRgvhDN5BB
         QaGinyrmzOUg3oc2/1kzkEbzNWn4q2RYlnz7A2b62tYXURn5/Xb+3VGVY0QdZYtM0574
         QuybZtx+9t57FCGCVjwRWKELNS8nsf2D5LxyFPJdRZ7zWkK4Yxf1ZcYsXVVe5KX5TYg8
         XQ2AyIUosZKeD6HT7LOTdVSfQru+5Dmdk9v9aX87DfBECtyRA4eCR7YDcKhZOhpHBh8f
         cZWc9ujpPMXzHua2iwx1q5mOmFAkuUz2aux2DlT1SNMwbU8YnS8+AQ1KU5hvfauIEWE4
         TGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784559994; x=1785164794;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iEr3VNvmBkqEprXTi3pXlF49HoF9BORq25oSTaK+MZQ=;
        b=br1v+huFpl29dtmHVZO5ZB+TaWIP7R1lVhzFXyx5j0wSdNW46rGJFXs+6Svs71FCza
         le1Y9IRsUOB7TECpfupOoZIb2Alr6gI/3ymQNO7/AZ7I0kmIvhLk0QUy5QVbwc2+iPjD
         mkBBPp7HMhyicT1zmiItlKsv5tkjYoSCcInAlmXx5ut/d/lSowduKs4S9bYxOynjd88X
         UmZYyw3a34ezB4WOLN6ZZcJncNwQ9LhuCkaJE9mDEg4UR8yBd8/4r5XpTmhBxmsWtjNf
         hRUJMcg6hz6aHn6803EwL0XCCslWc2Ckw+RkP1A8Yj7KsaYnA/CXIyWgeBaROnu2gFHQ
         7QRA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+bmYIQhMfqrEJEfcyhA+TY6n5rUAoW2qcNF5iwJBpSJve6FhsYt7lonNz4ODqtjoj/KYU7b3w87Gv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw94x4dUc1wpGvojb7t6FYVaZ/STYyyiaIjDRDd1fUGoQQq90vC
	2/4Y0VA00TUA0B5hY715Iq6B0tL4j6oz5w6QoWSZ+EwLI9G150jAD+lUxF8hVYLylFYRykg2glu
	yAQ==
X-Received: from plot12.prod.google.com ([2002:a17:902:8c8c:b0:2ce:9c0d:171f])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dad0:b0:2c9:97a8:afe5
 with SMTP id d9443c01a7336-2cf349eee08mr154630795ad.40.1784559993879; Mon, 20
 Jul 2026 08:06:33 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:05:59 +0000
In-Reply-To: <20260720150601.2702700-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260720150601.2702700-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720150601.2702700-4-praan@google.com>
Subject: [PATCH v4 3/5] nfs: introduce nfs_release_request_list helper
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
index c307daf5f68d..80fb553528d9 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -624,6 +624,23 @@ void nfs_release_request(struct nfs_page *req)
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
2.55.0.229.g6434b31f56-goog

