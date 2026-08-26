Received: from outbound.baidu.com (mx21.baidu.com [220.181.3.85])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 599353A1E8C
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 07:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730260; cv=none; b=fNKGzGvb9265KdWh1v8PJ48bK6O0lD42rUgDFiKJkyAA3ToIHaD9jNPePHXLB/Ae9THEC6fTGBygUUpV61QBhiFRj04zeNL4GF7WE3P8yK6dSo8YXb9Nhr0pCzQHJaLAOaAKfWOddzpUMsDU79gtKa1tRiMXyDN9QQOGLSu967A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730260; c=relaxed/simple;
	bh=7UeXtpGWKc5mkS57Y1hoM3KbGkeJMThgmpFczZk1L/w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BdKpIuZNQM16mSUq1HKDFZLyXvuSeIashAA6fJPjFPWsZ350kyNuZvt2N9FQ2RY7I1Mq1tet7ardSmPoFNNlu5VYHUk+fklv4deP5kp5aohr7oUl+CH8W6qTrk794tm/ZBPrcRKSemVgLCvNnFUg1kjsxmnCDCvUOqIR5uHknEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=nCHn/Uyk; arc=none smtp.client-ip=220.181.3.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="nCHn/Uyk"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, <linux-rdma@vger.kernel.org>
Subject: [PATCH] RDMA/uverbs: Fix potential leak of resources->collection in flow_resources_alloc()
Date: Wed, 26 Aug 2026 15:31:46 +0800
Message-ID: <20260826073146.2203-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc14.internal.baidu.com (172.31.4.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1787729516;
	bh=PIgclrQw2W7XxeIqb7GFgi64VsDG0idLWevAnTrLrJw=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=nCHn/UykoLR/VAdRQbAnt+/62xXXfZDOwp5XcBd0ARXE17flaBBCRiHVU7adamde4
	 MKSrF3siI0HBs0APTVh2nd6h0kQTYSNseenNyRVYDAjZm2pZgsl/LyD/wEXn1mxAJM
	 M7UEjs4si3FP1QIqUnvekXdvIaW4k0gaiexfdHRfsemUBoPMTScNaFiOaie09CaPqg
	 jZliaF1XWWkApZ4F9l92GQc65SCACwGJKeQmVKzsTihzZbvrY1eDWO52CAAB1GsJpZ
	 QdqYj0noScUr293TLeau0EaEZOYuArlUkhj73/Bwbur4e88a/7i9EugbzdcJWRJqUc
	 8SHK25bCkppdg==

From: Li RongQing <lirongqing@baidu.com>

The two array allocations are done unconditionally and only checked
afterwards, so if the counters allocation fails while the collection
allocation succeeds, the error path frees counters and the containing
struct but never frees resources->collection, losing the only pointer
to it.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/uverbs_flow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_flow.c b/drivers/infiniband/core/uverbs_flow.c
index 1528a29..de5a276 100644
--- a/drivers/infiniband/core/uverbs_flow.c
+++ b/drivers/infiniband/core/uverbs_flow.c
@@ -26,6 +26,7 @@ struct ib_uflow_resources *flow_resources_alloc(size_t num_specs)
 	return resources;
 
 err:
+	kfree(resources->collection);
 	kfree(resources->counters);
 	kfree(resources);
 
-- 
2.9.4

