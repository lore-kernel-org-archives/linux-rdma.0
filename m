Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE67367F4A;
	Wed, 11 Mar 2026 19:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773256152; cv=none; b=nHuJT53rvHVs59M6uKodj9JeKYvvf8Nndy6Clh7jPM7yr//DelLeBVBdQOblCeF+OF0n739x7UPrnHQALClH1u8CI5BTFuscUtx9ieMOURLRIcH9JQtKqSV51E1PKDYeC1yXqG93IJIM8dKrbim6Ef1lFDPU2HLSogMJl5o9aFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773256152; c=relaxed/simple;
	bh=Y7IxYgFPwpNVvKXeK9nR1uoDv1sEB/976av/0RuDIXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qj4q6m8AqqxCoH2+uuPhxKlo9+xeV1skU0SboWNRogxtdaoYpzQv1TLfD+YONCUlL/CjjUe4NEsX6L1gH5wvMRwq5dbq73uSkNbdvDLDKIESZ7ZmhIr+1CTgvNZN94Bcl3jdMFl9SPQknl1y0fO7B6RwUApZM2PNOlPNLHkWf5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZjly+FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZjly+FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAC1C116C6;
	Wed, 11 Mar 2026 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256151;
	bh=Y7IxYgFPwpNVvKXeK9nR1uoDv1sEB/976av/0RuDIXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZjly+FD7RhrJxb1JD1VgY4spyEehNCANCCnx9mVnO9J4cWhenNclePe/JK1Iy/Zy
	 +lffzBEJ96sc2SLnsy9exQHyisEszVRb6oOq7EVzSXq8W0Yh6WxIr+2XUnyKA/cLf1
	 m/pz6fl6AezPbzmXIBszDFIE6tSwhBG826fO3jBsXgikveu0HxOOIIzjIiVCwod0no
	 h8cuXF1gV1UO9KAr6ZbxDb+aFehyKFej3C2cqyHB/TvpuI/c+GbC7iBQIckvCaERVV
	 LBj5kuI7vjP92AtWxD4vuJJ7/CW8N+ksu9l1OeuVKXABVX+04P7FuPyblNDEpBBNcp
	 5RSfo2p/vb5sg==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/8] dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
Date: Wed, 11 Mar 2026 21:08:45 +0200
Message-ID: <20260311-dma-debug-overlap-v2-2-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Tracing prints decoded DMA attribute flags, but it does not yet
include the recently added DMA_ATTR_CPU_CACHE_CLEAN. Add support
for decoding and displaying this attribute in the trace output.

Fixes: 61868dc55a11 ("dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/trace/events/dma.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 33e99e792f1aa..69cb3805ee81c 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -32,7 +32,8 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_ALLOC_SINGLE_PAGES, "ALLOC_SINGLE_PAGES" }, \
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
 		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
-		{ DMA_ATTR_MMIO, "MMIO" })
+		{ DMA_ATTR_MMIO, "MMIO" }, \
+		{ DMA_ATTR_CPU_CACHE_CLEAN, "CACHE_CLEAN" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,

-- 
2.53.0

