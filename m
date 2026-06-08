Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461682E1C4E
	for <linux-rdma@vger.kernel.org>; Mon,  8 Jun 2026 04:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780894659; cv=none; b=fUqErGiwtZ4rLNtxF2y4mshS7mPtDEckcObGvv4jPuMbroh1+RrtJRG7Ln0p/wfzD/oHzyq21SmCHdHToD7PbFrtvu1DQt9B9N/AZDQILfvUKTm9gOOG2nLohZ6NidmjQeISTzlhCtAKNpUREQQKrVfW3k3WW29+MqQbd/Ilhfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780894659; c=relaxed/simple;
	bh=0A3KHx2mKPHlSf40g8+U+xz+PqAjs3NFoDAZ6XUZO/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ET3IvGGrAzlbN1mEFJEIsJ0r/dQYjbh66Ile5NPn+SWt3j5W8QV4pZFAJheq5tVnxmUc52PgWhGzRZkwYZEulEOC1zKpha5R1ijT3rD+aP5IefwKHTkPCf6cK6BWhIhSafXmCkEip3AuQcWK1Dc6vbzTmR9uY/4gwzzrB634DoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X5wuAm8T; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X5wuAm8T"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780894656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s+jscFRq0B8T5sj9vG4rO0OZX02mZxthqE09ofHdnO4=;
	b=X5wuAm8Tq8B5RpCjRyWcqusbA9JRQPUOxCr2D86zPMlS4IdEG7P39c1yXmMtOnszFBym8r
	uJ//XZzo5ec2X6vNkF7DiASviN44yEXc9RhuWgLDgd/zVeTcuYzNDxpC38GJ0mrKra7nRs
	+sbzOwHy845kj8jrNvf7Co+z7nWObTM=
From: Tao Cui <cui.tao@linux.dev>
To: leon@kernel.org,
	jgg@ziepe.ca,
	linux-rdma@vger.kernel.org
Cc: Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH rdma-next] RDMA/core: Fix FRMR handle leak on push_handle_to_queue_locked failure
Date: Mon,  8 Jun 2026 12:56:57 +0800
Message-ID: <20260608045657.2715472-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

In ib_frmr_pools_set_pinned(), after create_frmrs() successfully
allocates handles, the push loop may fail partway through due to
-ENOMEM from kzalloc in push_handle_to_queue_locked(). The remaining
created-but-unpushed handles are silently leaked as they are never
destroyed.

Call destroy_frmrs() for the remaining unpushed handles before returning
the error.

Fixes: ce5df0b891ed ("IB/core: Introduce FRMR pools")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/infiniband/core/frmr_pools.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index 5e992ff3d7cf..d7906fab033f 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -443,6 +443,9 @@ int ib_frmr_pools_set_pinned(struct ib_device *device, struct ib_frmr_key *key,
 
 end:
 	spin_unlock(&pool->lock);
+	if (ret && i < needed_handles)
+		pools->pool_ops->destroy_frmrs(device, &handles[i],
+					       needed_handles - i);
 	kfree(handles);
 
 schedule_aging:
-- 
2.43.0

