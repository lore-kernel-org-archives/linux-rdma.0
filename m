Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA3F7080D
	for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2026 00:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781484812; cv=none; b=cb5dTZNtIlP886Bjn2VSfOe7A+Upi4M8AVDd9Hh7Ji+OY1U6cIZUSeRM3/6YZDXrLgPEgSvaRYAExCiMy7gL6MaKi3KwTU8G+hRHYHr3B4m3pryRspCKz7CVCQwRcWpnA4qSl7948HnTTSX135x6sjMhQSkmLEi8rHmqhf0IZOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781484812; c=relaxed/simple;
	bh=r+mwMuUqgLXvrizPZU3Vde8otUicXL2hjubspvzLv5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HHb2Yt+xXZras6/Y8yX1CcgOHayP0qULM/KG85HsW0zoF1+18sLzGCnfuif8GX9WVXMtJa2f/UQXe/dziu8vVfRNMq73tpaMwr1ncvvTYzVizkWhxvrVad0+LKjREpiQRb5pQmxN0JoCWfne2JclAU6vyOzoTSTXfSJnphY7/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cWU6WxFr; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cWU6WxFr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781484808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KFGGgGvx+Xz4hzLLgdlnm604TPHKvdtjxWVXaJtUp1Y=;
	b=cWU6WxFrCQmG72kAxiFGwPk88lKrTbgx8kscwWBvu8zkrSoqYsSFivfMzolmnxF5mue+oj
	ZsQYvDXljedwmLYyTMgv4xmWOshIFuLAq+VNWDRRf9+x5Axm9ARJ5ljBd3NOjx386Kjzbc
	DEE155ZIqix7qDnu8OVzElJ8Uj3AVss=
From: Tao Cui <cui.tao@linux.dev>
To: dsahern@kernel.org,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH iproute2-next v3] rdma: display resource limits in curr/max format
Date: Mon, 15 Jun 2026 08:53:15 +0800
Message-ID: <20260615005315.169582-1-cui.tao@linux.dev>
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
---
 rdma/include/uapi/rdma/rdma_netlink.h |  5 +++++
 rdma/res.c                            | 21 ++++++++++++++++++++-
 rdma/utils.c                          |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

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

