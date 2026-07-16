Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77AB41D62E
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784202792; cv=none; b=GAcASZgUzjarsf08hSlVoBbBtTDEcIOFliP5cTKhkzKENvEQSVB+dkzl4jP3pmPUFcCjV9VuHM+r8kZBQshpqxZMiwU6aiNE0cp4qCwHNnU6SR4uLAawfc0VGDWk0w+KmSbLImhjXx8gHKx4vdwX7VTXZ9pMe8lIuzARJ97ja9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784202792; c=relaxed/simple;
	bh=23b6QQa0Ou8KC7v4rHoQvLjVNL2vEKHUZp2D+gqGy4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pwQx211WlGZokKCKSZgmDyLsHnB8RhA8QuohVIU+Qf1lSBRHKBdpudBrcAwl1u4ZfImLFVQB0c0lpmTvtuQDR5giusGU+WgNjZqLL/7evuvmy+oo4c5DvC4Hr7yVTJCK6Yx0si3FhbE3PnnpqjGL9qQVt5m1+xNuA+5X6y+R4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pTVeHAem; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pTVeHAem"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784202778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qhH/oi4ZISJC7YukKZdXTrOAwxiYJS8ZYpQuQA6zZrQ=;
	b=pTVeHAemgtWgbXs8iO/EqdMy3seW2wxIq2omFAT17NxBSh+K0qTzmGY1bfBCuShHdFLsn7
	nae8WY1C/4llrPIPBKfOzc3eejxqiAbYHyXwjpw3gn462lprDkdN1OlWxW8A7nw66HUvT5
	YZCNjLPDjmoJfuxiBTCB08BN4MCyppU=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH iproute2-next v7 0/2] rdma: display resource limits in curr/max format
Date: Thu, 16 Jul 2026 19:52:35 +0800
Message-ID: <20260716115237.1859633-1-cui.tao@linux.dev>
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
(kernel commit 5911f6d6e7cc [1]).

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
 rdma/res.c                            | 16 +++++++++++++++-
 rdma/utils.c                          |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

---
Changes in v7:
- Drop the unnecessary intermediate buffer in res_print_summary() and
  pass the format string to pr_out() directly (claude review).
- Add a JSON output example to the tool commit message.
Changes in v6:
- Fix the incorrect kernel commit SHA referenced in the uapi headers
  sync message (5911f6d6e7cc, not 5911f6d6e7ce).
Changes in v5:
- Split the rdma_netlink.h update into its own commit following the
  uapi headers sync format ("rdma: update uapi headers").
Changes in v4:
- Add a Link: reference to the kernel patch; re-send now that the
  kernel side has landed in linux-next.
-- 
2.43.0

