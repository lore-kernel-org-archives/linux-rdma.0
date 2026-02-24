Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7334DCD6
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 22:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771973798; cv=none; b=bVUN+hpeGTf7VB7swIQCklPwqIc1mqDYQ1oN99WA1ZhjriqkQEYzoHiMBXHSWkUHmR8A160y8cV8QSb8erAATp3EEM7PSCLrVI5ckXMXKS78xLKuRPUfFDfURTu+S89zh1m02GLKf+xOjV2DYZ5AVnD2decLXLp0riaLvM/+oCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771973798; c=relaxed/simple;
	bh=+sPU0sWeB873fkSV8ymeYKNTpTtvf1z7mItjgCyjOdI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V7fx8biIrGggtKemqwzszxkRvL/DL5NNXKBt1EAffILk9tcBa3HR0P7jbtm732cR9WFSqqRMTtFMS0L+9OSBjiA2jGvQxN1/zughAbxyJyvWA3YSWQ9kuxuJ+NuGZMoHExPCmwAM7c17SoCNH1Ps/1MKtY7uPVHYoFIlnyg8fEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nv8l/qOa; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nv8l/qOa"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-794b240c0d3so10482847b3.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 14:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771973796; x=1772578596; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r7y3QYR1ItYXiyFEEfrqhqC4QfmhjpSjvn1j6963B6E=;
        b=Nv8l/qOa6JlNcCTtw83/JhYc4N9Sz8ZosEU5wr89PCUUk5FmaXvs8rTMtHb118xw90
         shQpCadoPaUeP+VN3kaJflWx4LoliUOPYgV8QcoPorb7tnYrTD/LPdx+G5FP/SqvpZCc
         nsgSTt3xBYotojewHKUq5bHS/f8lxj60kzorcCwY2IwHeIsLq9vgI8ltA3VGVem8/w9v
         zbpKeNi8Fk2qCW1lbpoMoBJTtgXgDIaox93r/VnaEzF85nh2jNXQan/eTnjGq5PcojH7
         tobprcZDKNMzABRwB2bMeA9Rq1jq+CyRs3IBXlUTfvudcVnLmMyeqNfOT0uSAkyXvUfL
         soUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771973796; x=1772578596;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r7y3QYR1ItYXiyFEEfrqhqC4QfmhjpSjvn1j6963B6E=;
        b=BlIdXPPVCOJkwHobXFMqVn7UpazHi1pgzdD+mndWyo0iNPfEwUtWavCJMI5IS7eJvP
         ANCdlCsE+J6gx1gNyfUDIUIaq7B0m7lelO43kNd9Xia8hxFZqWND7tsBERISkghWXSeZ
         xjP/cZf1d9Eu+Z/deVCF62hmGwVNAYHbi1z+WKmRKqjWEw48ovp5hCvzaWl1sKp1fsWp
         TSRVxjGgVVE6X4yuf68dFpnDnWgzYJHExH5/3w2ewDgRogmL5YzAWBrM1PLYHfvGDIzx
         oTP9pKfVgCFTTqQCTWmGA7/0VofICTAfwBH8xDXRxbff8TY/PT2C3s1qyZ1KoKU9ZB5A
         CCMg==
X-Gm-Message-State: AOJu0Yyngv5AzIymVuhBClOQViPKhZFGAsnTijWUVFtvm5SziS6zwtiw
	S8fENVm5Tms6715VeGXU1g6B3mFJiTYotWC5IPYNnvu8CIKAn2lwM28DxuBE79OK+LLYAxOHZCh
	38lVoqolmRg==
X-Received: from ywbnv26-n2.prod.google.com ([2002:a05:690c:931a:20b0:796:3d28:c2e0])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:9:b0:798:5cab:cb7d
 with SMTP id 00721157ae682-7986501c3f5mr16012797b3.22.1771973795984; Tue, 24
 Feb 2026 14:56:35 -0800 (PST)
Date: Tue, 24 Feb 2026 22:56:33 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224225633.1197895-1-jmoroni@google.com>
Subject: [PATCH] RDMA/umem: Fix double dma_buf_unpin in failure path
From: Jacob Moroni <jmoroni@google.com>
To: galpress@amazon.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

In ib_umem_dmabuf_get_pinned_with_dma_device(), the call to
ib_umem_dmabuf_map_pages() can fail. If this occurs, the dmabuf
is immediately unpinned but the umem_dmabuf->pinned flag is still
set. Then, when ib_umem_release() is called, it calls
ib_umem_dmabuf_revoke() which will call dma_buf_unpin() again.

Fix this by removing the immediate unpin upon failure and just let
the ib_umem_release/revoke path handle it. This also ensures the
proper unmap-unpin unwind ordering if the dmabuf_map_pages call
happened to fail due to dma_resv_wait_timeout (and therefore has
a non-NULL umem_dmabuf->sgt).

Fixes: 1e4df4a21c5a ("RDMA/umem: Allow pinned dmabuf umem usage")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/core/umem_dmabuf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index f5298c33e..3a3e36efa 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -214,17 +214,16 @@ ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 	err = dma_buf_pin(umem_dmabuf->attach);
 	if (err)
 		goto err_release;
+
 	umem_dmabuf->pinned = 1;
 
 	err = ib_umem_dmabuf_map_pages(umem_dmabuf);
 	if (err)
-		goto err_unpin;
+		goto err_release;
 	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
 
 	return umem_dmabuf;
 
-err_unpin:
-	dma_buf_unpin(umem_dmabuf->attach);
 err_release:
 	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
 	ib_umem_release(&umem_dmabuf->umem);
-- 
2.53.0.414.gf7e9f6c205-goog

