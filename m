Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62538420E77
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948386; cv=none; b=tL72vQ/aOM2xD9qa1OA016t3uv+dvF5yZm0tHhVq2wVFVIVjQii+71Stzj6zQ/UEGGK7JCrn/zHJH4D/NONG1EbzzHvY4VeA9gkzP0PHgvB3z7lEvqOqiHG3mAUZ558hFhfxVp9VwtzTkrKrXQq0YZLOF5F4B8hAm5PXdpJAxHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948386; c=relaxed/simple;
	bh=gUqY2J/2Z99oCXM582wMkHz9KpMEQm+mmtjeZICeiLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uyzco3rQPBPHVXbh4+RkmPG7BksE6fDJRJ6i/dgXm5BZA5hyaoYECXkqkBp4EsGNPotSOU43GCw/XK1pZYCCF3SBolF6sK5bzPYPXzT21+yZ916SIYhEqZip8rhZPzwLNVe6M5He0Bf+i6Km4QtTtKqY6HgmG4hKKuAJu+AYhaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V3PXfH/H; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V3PXfH/H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783948382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bNJsg0VqHEw3GFNXXV9HS9+bUgIhLCEH3caEAVN8dUM=;
	b=V3PXfH/HyuZoxPayNYoruxU3x8QR1cCY5vHY2D6GqxZzyAy+sXvV5VXJuEymPv+VobZfYI
	ylG2RAH75OKejEhWYhClncsGCQH1QnUuKe8H2u6KldlqQ9rqrxaOJw4q946SAfc87eZfB4
	xv0cJoHIuYRFPEaf20wtAZcwoOUjkN0=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH iproute2-next v6 1/2] rdma: update uapi headers
Date: Mon, 13 Jul 2026 21:12:37 +0800
Message-ID: <20260713131238.955962-2-cui.tao@linux.dev>
In-Reply-To: <20260713131238.955962-1-cui.tao@linux.dev>
References: <20260713131238.955962-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

Update rdma_netlink.h file upto kernel commit 5911f6d6e7cc
("RDMA/nldev: Add resource summary max values for usage display")

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 4356ec4a..e5b8b065 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -604,6 +604,11 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_FRMR_POOL_PINNED_HANDLES,	/* u32 */
 	RDMA_NLDEV_ATTR_FRMR_POOL_KEY_KERNEL_VENDOR_KEY,	/* u64 */
 
+	/*
+	 * Resource summary entry maximum value.
+	 */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX,		/* u64 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.43.0

