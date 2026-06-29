Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184A2AD16;
	Mon, 29 Jun 2026 02:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782700346; cv=none; b=jxAFlhtr00tTOPQhThq9Qmy3VuX4BbUKxQwM1lVnAh+P88epVsNbOWhst78JeJzXtgekypBQ8uhr/pXhvamBylE/UCetBMIb1wYJiz/GVRhbAVINIoOviNcBibb6EZWGmE1d5L6dn3MK/FlUUbv9OHYLs8zht8GYzFiuaTIMeOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782700346; c=relaxed/simple;
	bh=bm87nrqKX2FCApAE4c8gmeMbZP7jGy6nUeJFIFpu2mU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c0Bf8cHZOkGOU1sdAlI+Xn9SaI7JMCGABpeFVCYLUDTzBsZRuIGpQn07UJw+zEICgEUGjCjAMNWx7IZKvOd1Dv/ZhEDYIOvRG9aVH9kuA3hEYU9zuJVQZzS8ZiQt87F0HApLv696s8nG/gG4fqDMTcrFq3BNRUymAPIWvPwEN10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XSL8UeHE; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XSL8UeHE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=6p
	1iZeodkfjEI8pl/gMI2tdT7NFX9+ctbmApzqqhgL8=; b=XSL8UeHEi6+zGVJZf0
	6hL7mKnC6DsLEZGrkPhrgmJaem1NKXGB6iiKQ92v7DBOesppBzf130N8km1HllFo
	iIXjMkCoDYb0oqZH9hn4Bc0Vw5K9rhdaebaGocIvoecE01sWU9HtsTW1HUUniHLF
	P3ik0Y+v2+ldbjwlQ7bw1jIvs=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDHzhga2UFqr6_RGQ--.50461S2;
	Mon, 29 Jun 2026 10:31:56 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: jgg@ziepe.ca
Cc: leon@kernel.org,
	kees@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] IB/iwpm: Fix spelling errors in comments
Date: Mon, 29 Jun 2026 10:31:53 +0800
Message-Id: <20260629023153.357709-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHzhga2UFqr6_RGQ--.50461S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1fuFy5Wr1UGw1fuF1UGFg_yoWfAFg_ur
	1agrn7Cr15CF1a9r47uFZ7Zr4qqw1jqw1a9rsrtw15J34DCrnrC3yIyFyruw47Gw1UCFs8
	Ka1xG34kCFs5CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8aNt7UUUUU==
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3RxorGpB2Rx7+AAA3o

From: luoqing <luoqing@kylinos.cn>

Fix spelling errors in iwpm_msg.c, changing 'quite' to 'quiet'.

Signed-off-by: luoqing <luoqing@kylinos.cn>
---
 drivers/infiniband/core/iwpm_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 4625abd29ac0..1b10f2973ad9 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -268,7 +268,7 @@ int iwpm_add_and_query_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 	if (ret)
 		goto query_mapping_error;
 
-	/* If flags are required and we're not V4, then return a quite error */
+	/* If flags are required and we're not V4, then return a quiet error */
 	if (pm_msg->flags && iwpm_ulib_version == IWPM_UABI_VERSION_MIN) {
 		ret = -EINVAL;
 		goto query_mapping_error_nowarn;
-- 
2.25.1

