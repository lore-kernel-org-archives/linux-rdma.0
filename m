Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FAB301474
	for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 01:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783646307; cv=none; b=Ak+ybdbeUmpOHUiEUvfRA6MHEp4kkgSRgDMI3o146qHBc+QUgz4IMUGgl/wYfOnxE9gngXyVHC0Kc5JR4yCc90NH90XTtx7gEmPObvEcjsBLoeQBK/302mAPryXPrZgiOYMMYVN3YrCx8ODPFLpWNjUaJTPdxd6HXmiA5w2Dylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783646307; c=relaxed/simple;
	bh=/ZQRq+x++QiN9kaduBMnI94LLLUyWqkM2zTVzpzMjNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpwBS/l7M2i/8lGVZQQCbxzbk0leTYE3aksC6mnKpnt4/EApJtPvR7fB49xJxgSVZAOYkEjI7QOgZQoXtxzqW2Ehb/Rc3NZsjUSYy6xf6jvjVMdpDtaiJlE6vil3DOqBSoGdt08fJZXFo4xuZVsQB6ZaSwgbkenFL4tLhtjrp9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JZxKhbxu; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JZxKhbxu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783646302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VTzx79yJrpdjUI5F4Orcx1DnIXf0Xz9TTn9PFIfcoJQ=;
	b=JZxKhbxuwyttM1lcQT/up2le1nIQWOqs44xEkrWq7fqxdE3igbLSWP6ajDuvxC6gmxaug8
	pc7TV/zezOwZeOATgCQg8hGGXgLqvmevMvV16+Hf7tS1MnmLuPLgFR3uBePTmG0LoJcWsv
	kdZCQfClEAOqFRGaO5Mtuo0OZKLynsQ=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH iproute2-next v5 1/2] rdma: update uapi headers
Date: Fri, 10 Jul 2026 09:17:58 +0800
Message-ID: <20260710011759.378893-2-cui.tao@linux.dev>
In-Reply-To: <20260710011759.378893-1-cui.tao@linux.dev>
References: <20260710011759.378893-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

Update rdma_netlink.h file upto kernel commit 5911f6d6e7ce
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

