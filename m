Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB3041D62D
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784202789; cv=none; b=JdvN2aRLUshStQti9oynuSkaAEAlqTP+NP1qKmMxnYEGvNuWECTSKN/TQWOfbvdpiKUBGqGLAbg00itd5vHhEklMF9Gy5ywrd3wj6brQJ+OUg/0GRJbut5CAaoYI0OJ/B9C3GJw5fGUMQWltyFNtluI/MWnsj/a8cFFuN/oVCRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784202789; c=relaxed/simple;
	bh=wiNBOpF9mBCvlKgVoZNmib1ytCoepz6XQr/TxoD7bVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/cY9pyYdtOHNEGjWXJNRyGYH6J3AHKKgFXz82UiWr8EkJKjksM8TdS/WeFy/plWwUF0o+wLK0BmUCnXx+6dJ6jGPKLwYZbth+e1opgZEQvGHNT41cZoATWRNgtSh/rnmOZHo7zIRJ8/60qvhiGTYWWgJKZUWvq2jP9YkFRQaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dous64v8; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dous64v8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784202786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bWgeMwa2DqsCaJo9mzWXEgnkWChcVu8T9yh5w+OyZ3w=;
	b=dous64v8bKUyNoU6tEw1FHDQ3C/ZnLr9le7l19zUvjbpx4/z1pMDEaO+sTMrnbH2kvn8rP
	P0hPCfOXQceH8WPevHRI98UOjZ5l27+tZFBTs1mry36YmmSEKd774iTopUunMa7lv1c8Bk
	z6datw3MHMD6ODk0aLwOivIM5qGhk6g=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH iproute2-next v7 2/2] rdma: display resource limits in curr/max format
Date: Thu, 16 Jul 2026 19:52:37 +0800
Message-ID: <20260716115237.1859633-3-cui.tao@linux.dev>
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

Parse the new RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX netlink attribute
to show resource limits alongside current counts in curr/max format:

  Before: 0: mlx5_0: qp 123  cq 45  mr 200  pd 10
  After:  0: mlx5_0: qp 123/131072  cq 45/65536  mr 200/1000000  pd 10/32768

JSON output provides separate <name> and <name>-max fields per resource
type, so scripts can compute usage against the device limit; resources
without an upper bound (e.g. cm_id, ctx) are reported without a -max
field:

  $ rdma resource show -j
  [{
      "ifindex": 0,
      "ifname": "mlx5_0",
      "qp": 123, "qp-max": 131072,
      "cq": 45, "cq-max": 65536,
      "mr": 200, "mr-max": 1000000,
      "pd": 10, "pd-max": 32768,
      "cm_id": 0, "ctx": 0
  }]

Backward compatible: no output change when the kernel lacks the new
attribute.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Link: https://lore.kernel.org/all/20260615003646.168704-1-cui.tao@linux.dev/
---
 rdma/res.c   | 16 +++++++++++++++-
 rdma/utils.c |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index 062f0007..7efced8d 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -55,7 +55,21 @@ static int res_print_summary(struct nlattr **tb)
 
 		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
 		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
-		res_print_u64(name, curr, nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]) {
+			uint64_t max;
+			char max_name[64];
+
+			max = mnl_attr_get_u64(
+				nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]);
+			snprintf(max_name, sizeof(max_name), "%s-max", name);
+			print_u64(PRINT_JSON, name, NULL, curr);
+			print_u64(PRINT_JSON, max_name, NULL, max);
+			if (!is_json_context())
+				pr_out("%s %" PRIu64 "/%" PRIu64 " ", name, curr, max);
+		} else {
+			res_print_u64(name, curr,
+				      nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
+		}
 	}
 	return 0;
 }
diff --git a/rdma/utils.c b/rdma/utils.c
index 87003b2c..90ea1c55 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -480,6 +480,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_EVENT_TYPE] = MNL_TYPE_U8,
 	[RDMA_NLDEV_SYS_ATTR_MONITOR_MODE] = MNL_TYPE_U8,
 	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENABLED] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX] = MNL_TYPE_U64,
 };
 
 static int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.43.0

