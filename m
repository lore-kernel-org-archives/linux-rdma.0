Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633912D1303
	for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783646314; cv=none; b=bfUZrmGHbfybrcIVeb2M5xzwrQKjfxgiLUNlFbu/7zD/XWY6PMiKoNzN+6fw8fYH2nRnXrwLSIFbbffXMmdW1H97/u/J/i63vScBg8zNnSj29Fef0KnNNZuOsHIR8CQroZrCJr/ryV8E39GWWggUhLe1wsOCvbX0sFWhoxbNAHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783646314; c=relaxed/simple;
	bh=KcZ7kb032dm7LsVMPNALHhb3NlGbqCd1EM6xN7A7q1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pmanjTzSFFCVz3DQ/smYEBeRPhZ6tfjjGhCQ+3L29mSxiqqMAka+QXXraHFVJOpSJ13ahsqlJefaCybMGOrAZYtk2RFJ5IscNa7oRkFMjjaGvgf4rxA6sawliiwFD407vtDXISZw+7NscLJxokQevQ8XwPby630AMujZ0Q3W7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kq7kcw7K; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kq7kcw7K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783646298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r5pSf5Af22QGyjixoYkd7KHTq4uqLa/w2mYECvbCsV8=;
	b=kq7kcw7K6EMK7bdAHmTVu6GpxCTxAlg+1FffswiQ+cWGk7YhFANBSKlLxztnoGuELQSMca
	mFHejeREZo7xknDEcf+8++MoPXQ5VKDcDbqg1ZCa+jktfWkv1u4nfWnCCa5YfK3/T/OMfo
	XOGfjdbVWnGWJRe8zhfSVOi/NfeLcds=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH iproute2-next v5 0/2] rdma: display resource limits in curr/max format
Date: Fri, 10 Jul 2026 09:17:57 +0800
Message-ID: <20260710011759.378893-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

This series adds support for displaying RDMA device resource limits in
curr/max format in the rdma tool, building on the kernel uapi attribute
RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX which has landed in linux-next
(kernel commit 5911f6d6e7ce [1]).

Patch 1 syncs the rdma_netlink.h uapi header from the kernel.
Patch 2 updates the rdma tool to parse the new attribute and display
resource usage in curr/max format:

  $ rdma resource show
  0: mlx5_0: qp 123/131072  cq 45/65536  mr 200/1000000  pd 10/32768

[1]: 
Link: https://lore.kernel.org/all/20260615003646.168704-1-cui.tao@linux.dev/

Tao Cui (2):
  rdma: update uapi headers
  rdma: display resource limits in curr/max format

 rdma/include/uapi/rdma/rdma_netlink.h |  5 +++++
 rdma/res.c                            | 21 ++++++++++++++++++++-
 rdma/utils.c                          |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

---
Changes in v5:
- Split the rdma_netlink.h update into its own commit following the
  uapi headers sync format ("rdma: update uapi headers").
Changes in v4:
- Add a Link: reference to the kernel patch; re-send now that the
  kernel side has landed in linux-next.
-- 
2.43.0

