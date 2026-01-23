Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD53A34D91C;
	Fri, 23 Jan 2026 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769156647; cv=none; b=u19h5ZMFBLZW/ma0SUWGjmjxeO3iYvpnM2MGdaTHLrDBUaWjrZiEzoFTEya1pob0IDle3ZdcDkIaJROdeb0EU0yvVZ6oS8S0yJZMJ3MnYhNNDhI2uY8+6Z3jcwkM36kZC+3VUFoNpuZV/KYb8dlbZf8gcl6C2BLYdXGs1kPRasw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769156647; c=relaxed/simple;
	bh=wM3JU/EQZGQCUY9DL/ap27lW5FHLzpGbQXdM7W26KpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NChZWOWQ1YoWpIyz2vY3MhWgaPwBgsEv9jIvecD76Qsm0C7MSEPwPMqtdXw0QH5ziLhDvEiWkkbwRNWByWsP5EgwNNtXeA/f7+jBH4Z0IndUj+iINB+Gd8MPNYy3o2hRLY/Ajgy1P49v8U63r5aRhuWOjwaqPPQnsYtvfSlih5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N8UOb1xg; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N8UOb1xg"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156635; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=l4ux9tDlFdT94Vxn27fx7SeIZf5wjhCyTIcjZvfwWJQ=;
	b=N8UOb1xgztH32QrTnJLQ0HErMKTEVypillYb5NrAbLG8ndcOQhHNa5GUXp/tWaUXBbOfNbs+VD1vFb5i1Y0P+GybToMmiESnuDDiAbyqHpWzV/RypwVcPh2RbmnhuKjZRNxA0AGfDLYQtSrrLl6WwPx+fEgjmwlXaCH9gy6mxtI=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8ov-_1769156634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:54 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: [PATCH net-next 1/3] net/smc: cap allocation order for SMC-R physically contiguous buffers
Date: Fri, 23 Jan 2026 16:23:47 +0800
Message-ID: <20260123082349.42663-2-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260123082349.42663-1-alibuda@linux.alibaba.com>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The alloc_page() cannot satisfy requests exceeding MAX_PAGE_ORDER,
and attempting such allocations will lead to guaranteed failures
and potential kernel warnings.

For SMCR_PHYS_CONT_BUFS, the allocation order is now capped to
MAX_PAGE_ORDER, ensures the attempts to allocate the largest possible
physically contiguous chunk instead of failing with an invalid order,
which also avoid redundant "try-fail-degrade" cycles in __smc_buf_create().

For SMCR_MIXED_BUFS, If it's order exceeds MAX_PAGE_ORDER, skips the
doomed physical allocation attempt and fallback to virtual memory
immediately.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_core.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e4eabc83719e..6219db498976 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2324,26 +2324,30 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 	if (!buf_desc)
 		return ERR_PTR(-ENOMEM);
 
+	buf_desc->order = get_order(bufsize);
+
 	switch (lgr->buf_type) {
 	case SMCR_PHYS_CONT_BUFS:
+		buf_desc->order = min(buf_desc->order, MAX_PAGE_ORDER);
+		fallthrough;
 	case SMCR_MIXED_BUFS:
-		buf_desc->order = get_order(bufsize);
-		buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
-					      __GFP_NOMEMALLOC | __GFP_COMP |
-					      __GFP_NORETRY | __GFP_ZERO,
-					      buf_desc->order);
-		if (buf_desc->pages) {
-			buf_desc->cpu_addr =
-				(void *)page_address(buf_desc->pages);
-			buf_desc->len = bufsize;
-			buf_desc->is_vm = false;
-			break;
+		if (buf_desc->order <= MAX_PAGE_ORDER) {
+			buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
+						      __GFP_NOMEMALLOC | __GFP_COMP |
+						      __GFP_NORETRY | __GFP_ZERO,
+						      buf_desc->order);
+			if (buf_desc->pages) {
+				buf_desc->cpu_addr =
+					(void *)page_address(buf_desc->pages);
+				buf_desc->len = bufsize;
+				buf_desc->is_vm = false;
+				break;
+			}
 		}
 		if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
 			goto out;
 		fallthrough;	// try virtually contiguous buf
 	case SMCR_VIRT_CONT_BUFS:
-		buf_desc->order = get_order(bufsize);
 		buf_desc->cpu_addr = vzalloc(PAGE_SIZE << buf_desc->order);
 		if (!buf_desc->cpu_addr)
 			goto out;
-- 
2.45.0

