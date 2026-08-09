Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9616C381B0F
	for <linux-rdma@vger.kernel.org>; Sun,  9 Aug 2026 03:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786246099; cv=none; b=XCGHx6h/Y/+nlbnJ48o3KmoCdE7TLRrNW1PLhXGVfrtGvaMDQVc1VUXYH7f9+Jsc0oFYE7B3CLz9T2NScL5M9W/sg835xyiuNwShXPi+6VKiIaVa5HqFZfW5AreIw9zO5eNXOfcW2Ol3Uv9OrctCj3xJrNL5u4Yd5BBt50tWJ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786246099; c=relaxed/simple;
	bh=EUTWRYIkv/eb/Z386B6IxzwAsVtI3sCcs16queTkXnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeLBKS4/3MiwgzJpWe+ol2FJ46fWw2FbchwWd1a445MX5SEH+ZDt1vVgIdbjIifKqrpVy59Q4j4oL4THR1GZ1Ee2i6NtDP8kqaCVxasOX6hKoS/gICo1h2DhZ6NrBhavbFOigxax78MO+w3o8OPWkajhzOOQl69t0OPovdCjETk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbHWXW4c; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbHWXW4c"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso842714a91.3
        for <linux-rdma@vger.kernel.org>; Sat, 08 Aug 2026 20:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786246097; x=1786850897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=htQ3Nh4NK5zZ2RbZHHLwjMu5TBvqvLaS/zwT9S8pras=;
        b=GbHWXW4cTdlH2njj7u9Tb3WW8C+pb4FRQC8QmMTUxgtuj7gaIXBKrnAKn63gMe0VYU
         0JMnUmXmpJCZiu71/Nj1flwexmGsZ6itwDXVIqcUgAuSM4GGHjc1vkKo5fHQLIGhWzlF
         qLQtE5cBso1qJAbmuUs4M9mF7GhElH1fZVdEHQpZmUrAdVcePXvvLq+LlDM66SpEiViC
         x8PzPWe1Z2Bm0WzgOomLJXoURsgUCJhY9lOiH6TxF/eYwrU1ZyTcCNJbJ8HIGSvGXp4X
         eYzFjtdD2SIsMdFXQxKomzisonq+Zckty/rpwBkmY/0SDEPWU76VnK0rR4L8KskA+yD7
         BT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786246097; x=1786850897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=htQ3Nh4NK5zZ2RbZHHLwjMu5TBvqvLaS/zwT9S8pras=;
        b=Rwa+GZ+wYR3YjC0gIcGVNakY2D61yGpsB6jb1HqWXbLzpJzTfzPUSmMYt+5EezV0Di
         +aH/1sydTwK2sP6ATuEmO6RMD60XxLXLp1I/+lXDTFhYzd1nQviNZVavoNQnMlpSZLcc
         SHVq9J95nj8F5eU8jEl4K0ezNvGVcWz3Qoqqqg7ozJ9NCDB6gFj2KzaYZDVH1yV8zlzE
         B8O0T7LUjCVKsDuicqesjpAWojL7y/4JzZQ7AwfaEBPC2jGVJRETTR6jySXxDgUfgV5A
         Mmy2Z/TvSkQjaMCGKy1nhYxaog+Wx0G5zPZRob6ZTIVyiN37sC1YU57xbcdQwowefbmn
         6Fdg==
X-Gm-Message-State: AOJu0YzZeQ6u0BQ48lfp3CZar+mLzTdTRmucYseWeqLqFmccdwPAjVWd
	PB+Wi6THIp/pCrbmEHmj1pOjlpJ8H0PfuAmFgMz9quyov6aAH0aJU7bU
X-Gm-Gg: AR+sD106uuvALrfI78eNN19nr0wtSorLSnESSQ0iyPby/aO/tGbWWsx5ZyMZURK7x2x
	fRSWiB23fgOQSTVgJsCXr2QbN5F8LvZKphuYMU/1s9ah2XyQIqu34gdIhnxN5WwlYwiT7QRa3Gs
	P/N6exvcM90o/G7B8CqwyuPhf9bYWOK7axZ1tCruYp+0UxYOoLeY1+312O7DZEAo6kmb2IdspMV
	4ucEUNHUeZeHqAFDTu2DJ8tL1mqDuCQKDHvJzNE8c6Z8ow5MR8jO++5mRj15bMfI7+FLPoWljGk
	5HN8SOS8NaeZK7fvvppm1k5b0QzQa/8oigtNuuF/eDcjeglso1C/22C6uyNsVLFsrWwl5MA+H7h
	IkSHE10kPGkuKDVFCNEMlDwo2VuSycKcwoOqE0gHe9LA+5UdRetz8FNL6hRKYwPy++00/rnuZw9
	dKwwTEKsKKlVlilMBYFI9XOVU2m6Zk0AFHC8gs66zpC98mWo4pMX99AegIXOiy+uCsibDJrF/aN
	+eSexpI9CTiT5MTVUQhUGqzhfFF8CxmZFmSrObSeMevn3xLxCJrQGrgE+MAbTZxsmqsWAVDNQ==
X-Received: by 2002:a17:90b:2545:b0:38e:49c0:75a7 with SMTP id 98e67ed59e1d1-39261feb6a2mr16196173a91.8.1786246096980;
        Sat, 08 Aug 2026 20:28:16 -0700 (PDT)
Received: from homelab1-WRX80-Creator.localdomain (p790255fa.sitmnt01.ap.so-net.ne.jp. [121.2.85.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm7587626a91.2.2026.08.08.20.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 20:28:16 -0700 (PDT)
From: Shuhei Takeshita <jyohuku.alterego@gmail.com>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dean.luick@cornelisnetworks.com,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] IB/hfi1: Resolve the credit-return buffer through the send context's node
Date: Sun,  9 Aug 2026 12:27:42 +0900
Message-ID: <20260809032743.2671579-2-jyohuku.alterego@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260809032743.2671579-1-jyohuku.alterego@gmail.com>
References: <20260809032743.2671579-1-jyohuku.alterego@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hfi1_file_mmap()'s PIO_CRED case derives this context's credit-return
page offset, and the DMA handle for it, from dd->cr_base[uctxt->numa_id].
uctxt->numa_id is the node of whichever CPU the process happened to be
running on, but the entry itself lives in the credit-return allocation of
the send context's own node:

	sc->hw_free = &sc->dd->cr_base[sc->node].va[gc].cr[index];

and user send contexts are allocated with sc_alloc(dd, SC_USER, ...,
dd->node), the HFI-local node.  On a multi-socket host with the process
running off that node the two allocations differ, so the subtraction
produces an offset into an unrelated buffer and the DMA handle belongs to
the wrong allocation.

Use the send context's own node for all three references.  The
continuation lines are reindented at the same time; they mixed spaces and
tabs.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Signed-off-by: Shuhei Takeshita <jyohuku.alterego@gmail.com>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 56031becb..e05f3c255 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -382,10 +382,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * of enabled contexts > 64 and 128 respectively).
 		 */
 		cr_page_offset = ((u64)uctxt->sc->hw_free -
-			  	     (u64)dd->cr_base[uctxt->numa_id].va) &
-				   PAGE_MASK;
-		memvirt = dd->cr_base[uctxt->numa_id].va + cr_page_offset;
-		memdma = dd->cr_base[uctxt->numa_id].dma + cr_page_offset;
+				  (u64)dd->cr_base[uctxt->sc->node].va) &
+				 PAGE_MASK;
+		memvirt = dd->cr_base[uctxt->sc->node].va + cr_page_offset;
+		memdma = dd->cr_base[uctxt->sc->node].dma + cr_page_offset;
 		memlen = PAGE_SIZE;
 		flags &= ~VM_MAYWRITE;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
-- 
2.43.0

