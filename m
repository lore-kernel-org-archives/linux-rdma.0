Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B20217F33;
	Thu, 16 Jul 2026 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784202785; cv=none; b=UO6Ei0XNXE7fGXFCHARczSYLpzQsOisvKNFxTV47sLLepuXc8cj1q/+t5gOJJ0Iw+rehdw9Mk+CzDHss+yJZb9ephQGiBtR8/++ieNi2lEcmm3HKLmOzJh6EBbcOFUhXs7x7hQQZSGMzJ1seEPfYWKE21gQcBCP9b1co1s62/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784202785; c=relaxed/simple;
	bh=gUqY2J/2Z99oCXM582wMkHz9KpMEQm+mmtjeZICeiLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/LZsID6VVLediaEuAR+5xR1tW8rGJx86ABAbKa7Dfg4Zji81pwmmpRq1xBOaPUlSb7oOlyfNcjAOkXMI6m32VABa4ZCx+Qm8Wvq17qYIvhscTjtoMFxCvnSjbbdNIPgnIPnom//pODnho+tMxwIEZkeL0rTrap6uXiAUTxe3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ioHDJ6wE; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ioHDJ6wE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784202781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bNJsg0VqHEw3GFNXXV9HS9+bUgIhLCEH3caEAVN8dUM=;
	b=ioHDJ6wEbQ6vI9bAd40+rNTsR8f4bVbsUGBxtW/hpb448bO4YZIWplxXcIbDXmWnZajIjv
	smqSZsylEnDYRTukdwG6/6xzayKH9SW4ur3I1jVj43vlh5EZT04NoiHCsqnBIiAKgdRhzH
	GV8j1moC5KKg9WDA3hf+xT01NUgK3Nc=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH iproute2-next v7 1/2] rdma: update uapi headers
Date: Thu, 16 Jul 2026 19:52:36 +0800
Message-ID: <20260716115237.1859633-2-cui.tao@linux.dev>
In-Reply-To: <20260716115237.1859633-1-cui.tao@linux.dev>
References: <20260716115237.1859633-1-cui.tao@linux.dev>
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

