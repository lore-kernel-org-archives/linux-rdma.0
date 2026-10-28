Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.2.5.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793180081;
	b=O/kZM5kwKDkmEG7FTY624FrgDz2080e8MpATmhLy2NElG3V8yTkpnlDCnELAMHOsG75E
	 NPahnT2GUPnP634s6sfBOYtSuMQi0zsIP4j6Dw9B23Giz9RxvQP/tdJ67Bu//5EghaRwC
	 it7wM8SQdbNmNDbwKe/EB5p0LlmJRZ/KpgBzZhsJukBGj3yB6VflFqoTF/cSkyDIUA1SY
	 DCElOVsqohwSkC+YtM9dnZedktV5q2gvnWy7ZsutmH5uFUVUkNEYTx+MC/bQGDzN9eiTw
	 6xPbjbR5MuLOEu+5IfbCX92LIr+sRA146Gz8l/cvaR/95IBNm9o2gkB/gC617tv7YTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793180081;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Date:Message-ID:From:To:Subject:User-Agent:Content-Type:MIME-Version:
	 Content-Disposition;
	bh=q/FwirQ62h3N9wDup/kyWh23/nD/hSNuyDOwC8zj5vk=;
	b=nMeeh+eI5sKHLqyAIPy/pxAAfHKgaQYvxsKzlP4pI41mYlhSwPvxqLjNQXoqMvAsA7Lr
	 SO9VuLvyjo1BCXFbpwl1JpOllPQMcP6xL2Eaip1M7jC8wfemkZm9w9QTrLkeMpR1tyJjX
	 0FVGY+DihZkcwo7fYuCweyXwkhG1rVzbw91MrBD99OqCZiTIHlE/hJKXONk99ajJbBhkJ
	 RW81EUkLtIV1dif6KJmuBw6dWtrLuZSPi+X2A/Tf1G3F56wLEdjkxSUEqlcj1pbkUQ4eM
	 a6JcWKAlBIl5l7gFQHCX1zJjsg9WKwck3C+5FdW8BdGDsk8QoaX+ovunkmFEg8Px2QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=student.uni-tuebingen.de;
	spf=pass smtp.mailfrom=student.uni-tuebingen.de;
	dkim=pass header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b="R7S2d/Wi";
	arc=none smtp.remote-ip=134.2.5.213
Received: from mx03.uni-tuebingen.de (mx03.uni-tuebingen.de [134.2.5.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A11606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 09:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05A11606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=R7S2d/Wi
Received: from webmail2.uni-tuebingen.de (webmail2.uni-tuebingen.de [IPv6:2001:7c0:300c:3105::8602:5c3])
	by mx03.uni-tuebingen.de (Postfix) with ESMTPS id A5DB520C6E9F
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 10:34:30 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx03.uni-tuebingen.de A5DB520C6E9F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-tuebingen.de;
	s=20211202prod; t=1793180070;
	bh=q/FwirQ62h3N9wDup/kyWh23/nD/hSNuyDOwC8zj5vk=;
	h=Date:From:To:Subject:From;
	b=R7S2d/Wiq+cBjjrDGhoFyOTu+GQ63EzhwuKIJNA7iywEa6UY7WW40nCpcLDgjFX0m
	 Ezq6dMf+gyjUcLChGN0Ne4NqpOxOMIwYhu+qPhi/B/c/ZooFZ4Vffv7PbWye6TZKm8
	 MjeI8QcwRebaPTm0iHhtrpkBWuqypgGhVyAtHfG/+KqBmUXvGCFg7JU4KTQkxk7u0t
	 zv9TG2Va9hewRQxgawsnIWoCz6KeurUAo20OeKi3NDnSameQLSFVPJWKRdfgHLNA1T
	 mdQkffF3T/30b2Zzudu3ACLYgDXHI2lkIH0ff/HXJ+WnvaOEINMGnORWG8C0j36gdo
	 WB+d7rFyQG7fQ==
Received: from webmail2.uni-tuebingen.de (localhost [127.0.0.1])
	by webmail2.uni-tuebingen.de (Postfix) with ESMTPSA id A01AA60EC081
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 10:34:30 +0100 (CET)
Received: from u-251-c134.eap.uni-tuebingen.de
 (u-251-c134.eap.uni-tuebingen.de [134.2.251.134]) by
 webmail.uni-tuebingen.de (Horde Framework) with HTTPS; Wed, 28 Oct 2026
 10:34:30 +0100
Date: Wed, 28 Oct 2026 10:34:30 +0100
Message-ID: <20261028103430.Horde.FEW-mpmPqkkJwfVq8q5rABm@webmail.uni-tuebingen.de>
From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
To: linux-rdma@vger.kernel.org
Subject: mlx5: dma-buf MR on GH200 GPU memory wraps every 2^k bytes when the
 base is 2^k-aligned (k >= 32)
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Disposition: inline

Hi,

On Grace Hopper (GH200) with a ConnectX HCA, a memory region registered
through ibv_reg_dmabuf_mr() on GPU memory behaves as if its mapping wraps
every 2^k bytes when the region's base address is aligned to exactly 2^k,
with k >= 32. RDMA operations complete successfully with the full byte
count and no error, but they target the wrong location:

   - local side, base aligned to 2^32: a READ into offset X lands at
     X mod 4 GiB. Destination blocks at offsets >= 4 GiB stay untouched
     (zero), and blocks below 4 GiB get overwritten;
   - remote side, base aligned to 2^33: a READ from offset X >= 8 GiB
     returns the data at X - 8 GiB.

The same memory registered through nvidia_peermem (plain ibv_reg_mr) is
correct at the same alignments, and bases aligned to 2^31 or less are
correct with dma-buf.

Environment:
   - 2 nodes, 1x NVIDIA GH200 480GB each, aarch64
   - Ubuntu kernel 6.8.0-136-generic, inbox mlx5_core / mlx5_ib
   - Mellanox device MT41692 (mlx5_0), RC transport; firmware 32.38.3056 on
     one node and 32.43.1014 on the other (the wrap occurs on both)
   - NVIDIA driver 595.58.03, CUDA 13.x
   - dma-buf fd from cuMemGetHandleForAddressRange() on cudaMalloc memory

Evidence:

1. UCX (bundled with NIXL 1.5.0), 15.4 GiB region per side, 9216 scattered
    64 KiB READs per iteration. The region is carved out of a larger
    allocation so that its base has exactly the chosen alignment; UCX's
    debug log shows that exact range registered with dma-buf.

      initiator base 2^32, dma-buf      2/2 iterations bad (x2 runs); the
                                        all-zero blocks are exactly those
                                        at local offsets >= 4 GiB
      target base 2^33, dma-buf         2/2 bad (x2 runs); exactly the
                                        blocks at remote offsets >= 8 GiB
      same two, UCX_CUDA_COPY_DMABUF=no 0 bad (same zero-copy rc path and
                                        bandwidth)
      initiator base 2^31, dma-buf      0 bad

    Without forcing anything, 4 of 30 fresh process pairs were bad. Each had
    a base aligned to exactly 2^32 or 2^33 on the failing side. I checked
    the wrapped values byte-for-byte against the fill pattern. Re-reading
    gives the same wrong result.

2. Without UCX: plain ibv_reg_dmabuf_mr() vs ibv_reg_mr() (Mooncake
    transfer engine, RDMA loopback through mlx5_0 on the node with
    firmware 32.43.1014). 12 GiB MRs carved from cudaMalloc so the base is
    aligned to exactly 2^k; 1152 scattered 64 KiB READ+WRITE blocks plus
    transfers ending at the last byte of the MR, all checked byte by byte:

      dma-buf, remote base 2^31           clean
      dma-buf, remote base 2^32           offsets 0-4 GiB correct, 4-12 GiB
                                          all wrong (READ: 781/1152 bad,
                                          776 all-zero)
      dma-buf, remote base 2^33           0-8 GiB correct, 8-12 GiB wrong
      dma-buf, local base 2^32            local offsets >= 4 GiB wrong
      ibv_reg_mr (peermem), base 2^32/33  clean
      dma-buf, base 2^32, MR split into
        regions of <= 2 GiB               clean

    An earlier unforced 16 GiB dma-buf run whose base happened to be
    0xf1b700000000 (exactly 2^32) showed the same pattern; runs with
    bases aligned to 2^29/2^30 were clean.

3. End to end: vLLM P/D with NIXL returns garbage when the decode KV
    cache's registered base is 2^32-aligned. Per-layer checksums show only
    the layers below the 4 GiB offset arrive correctly.

My guess is that the page size chosen for the dma-buf umem
(ib_umem_find_best_pgsz() on the dma-buf scatterlist, then the mlx5 mkey
setup) can reach 4 GiB or more here. GH200 exports large physically
contiguous GPU segments, so a 2^k-aligned IOVA allows a 2^k "page", and
something in the mlx5 path then handles page sizes >= 2^32 incorrectly.
I haven't verified this in the kernel source.

Reproducers and raw data:
   - NIXL-only script: https://github.com/ai-dynamo/nixl/issues/2512
   - vLLM report: https://github.com/vllm-project/vllm/issues/64048
   - Mooncake report (raw verbs, item 2):  
https://github.com/kvcache-ai/Mooncake/issues/5015

I can run a patch or collect more data (e.g. the page size chosen at
registration) on these nodes.

Thanks,
<name>

