Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA87E382385;
	Thu, 30 Jul 2026 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785384994; cv=none; b=mqoixz8caJJrIHBskENzDkEsy5pqCjDPkOVclwE7IoZBIzLfMEspzfNTg7TX3641d46xXqkp34KszNHh8i6+4+chvnavNTj2N5St1mEb2dTLy17bXUzg5MglevaZNuve4xwPXgOeo+MV4K3KEw4IZpvuSbFjn9oFlZUZb01DN34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785384994; c=relaxed/simple;
	bh=NqpmA/XwIJGwWD7dKPRGxXsLNy04EcyA5OFuRZaAnkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R6iIqa1M96dRobdl0skK97Xlmz4drLHqo/04AcjtuBFlS+1YMC/vs2JgmiLCzs5JJmgkEZ3cg23gy9vUN8hjtZ1PdEeonsIDwxRdbbyNMnf9lSX2QdGibihyxdk9hZy9Llp7LHI1ML8WoEabJQ4dl9XP4BECm6WGc4a07t7HUbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhW8R9Yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhW8R9Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567BC1F00A3D;
	Thu, 30 Jul 2026 04:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785384992;
	bh=i1yRXwysVQVtaKCv8mjXDbuWP09atvlSpBDHH7+4BpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhW8R9Yj4LM2HDxdo7I/czbmo0ERPiOUwpcW1Ne0m4c7/uKK/lppVwMC1hexf4XPN
	 wv3HYo74rV3udxhfYzDbZyvLlChPyVC2E53f8rQxjnBAO0hSZBP6UGrIQvkJh/QV/p
	 FTWK+886gnG84gnl7qzZ4I/Jg3LoTKin1BhP0PNAazP+/86xN405ZwttAAf9s0Mks0
	 hmhUqjmNm4W1EezB7dXWBwfX5npcajz5LF0BeXClvtCoaT2m6VnZ4hjmzinEuuQ/Oi
	 ZMS8Db7JjI0bV3Z7mrr56+i6WcxfHnMcSiheP0TG7IQKGfJOZ1XWtXfgMX6Vjm5+t1
	 LMGbnEsTO5BEA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net v4 4/4] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
Date: Wed, 29 Jul 2026 21:16:29 -0700
Message-Id: <20260730041629.3512480-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730041629.3512480-1-achender@kernel.org>
References: <20260730041629.3512480-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pages backing an RDS memory region are pinned in __rds_rdma_map()
with rds_pin_pages(), which uses pin_user_pages_fast(): each page's
refcount is biased by GUP_PIN_COUNTING_BIAS to account the pin.  The
scatterlist is then handed to the IB transport, and the transport
releases the pages in __rds_ib_teardown_mr() with

	set_page_dirty(page);
	put_page(page);

put_page() drops a single reference instead of removing the pin bias,
so every MR teardown permanently strands the remaining references and
the pages are never freed - a userspace-triggerable memory leak of up
to RDS_MAX_MSG_SIZE per RDS_GET_MR/RDS_GET_MR_FOR_DEST call.

The conversion to the pin API updated the unpin sites in rdma.c but
missed this one on the transport side.  Release the pages with
unpin_user_pages_dirty_lock(), which removes the pin bias and also
dirties the page under the folio lock, closing the truncation race
that a bare set_page_dirty() leaves open.

Dirtying under the folio lock can sleep, which is safe in every path
that reaches __rds_ib_teardown_mr(): the registration-reuse path
(rds_ib_map_frmr()) runs in syscall context, and the pool flush
(rds_ib_unreg_frmr()) runs under pool->flush_lock, a mutex, and
already sleeps in rds_ib_post_inv().  The WARN_ON that guarded the
old irq-context set_page_dirty() case is dropped along with it.

Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_rdma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 9594ea245f7fe..db7e92e7bd29f 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -251,9 +251,7 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
 
 			/* FIXME we need a way to tell a r/w MR
 			 * from a r/o MR */
-			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
-			put_page(page);
+			unpin_user_pages_dirty_lock(&page, 1, true);
 		}
 		kfree(ibmr->sg);
 
-- 
2.25.1

