Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E6541DEDD
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948392; cv=none; b=M1UtI2McwuUH3gDzd6MPga/f2xccCpEG/5Hmvy6w6RBtDS4b3+mB23RGnO34yenNiJz8CZSW8qXiJtWNqT4izpxbMpb9Zz2SH6f2GHX+FMnbff/NrOREwBc61iXnfFUDw2sdJgG4I+w2Y0WLA0eW2EZzOq3iB8z+GIULzq5BSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948392; c=relaxed/simple;
	bh=4oU5vwBqC2s/OF/BgDvlhZIxT9V5eYNC6nP5Ld7hIpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpYrXMlj9kJMSQDdfcEaZHak90vIb+eFqRoHDgLnKcrCrRsxH0HQWqx+StQP2NECdefsbGb3ivbNbevBh3wirg5wWolgQhJXKlnuB8/I1DFgFzE7jveyCavq/Rp1q0QqvL6KWZcsI34HkVk/k9wYF+CnZcRuRrd9t+Y/s7ldB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kPLpl8ST; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kPLpl8ST"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783948389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0mFihgDhXIZEpH6Gz5fyyFppsNsRX070ZVmoxYxoXc=;
	b=kPLpl8ST14cpQM7/xvabVO301L57dUGlUm983QBLU1u6wp3X2YD+ddU5ekGzzwxggSXjXP
	fsd6GwN0WQxRWQFHZdF7/nL5m18drfwh2N5zzvVLCrdA3JKdh1T+sy5N0C0grWxPckhYSr
	pbKDJStVm8uDEvuAJE1N84bpkvBz8Hw=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH iproute2-next v6 2/2] rdma: display resource limits in curr/max format
Date: Mon, 13 Jul 2026 21:12:38 +0800
Message-ID: <20260713131238.955962-3-cui.tao@linux.dev>
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

Parse the new RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX netlink attribute
to show resource limits alongside current counts in curr/max format:

  Before: 0: mlx5_0: qp 123  cq 45  mr 200  pd 10
  After:  0: mlx5_0: qp 123/131072  cq 45/65536  mr 200/1000000  pd 10/32768

JSON output provides both current and max fields per resource type
(e.g. "qp": 123, "qp-max": 131072). Backward compatible: no output
change when kernel lacks the new attribute.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Link: https://lore.kernel.org/all/20260615003646.168704-1-cui.tao@linux.dev/
---
 rdma/res.c   | 21 ++++++++++++++++++++-
 rdma/utils.c |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index 062f0007..046935e2 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -55,7 +55,26 @@ static int res_print_summary(struct nlattr **tb)
 
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
+			if (!is_json_context()) {
+				char buf[64];
+
+				snprintf(buf, sizeof(buf), "%s %" PRIu64 "/%" PRIu64 " ",
+					 name, curr, max);
+				pr_out("%s", buf);
+			}
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

