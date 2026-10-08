Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8433547075
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 05:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791436320; cv=none; b=ZxADiJ9iN+KGtQCNz1lOQPxTOr+wdQNDeQHeMGtnQ94ryXyRN8Vm2PSDFYAM7tjS29Bx2g/iwfCJA4qnJc/tDH8/xRl9dpFngfF6S6Iod0AVigX8ev7ZQ5fmxiiXI91hZtJx6y3omDtzFeoHfJIfxAh43KtmhKVx5oq8xXYN9mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791436320; c=relaxed/simple;
	bh=jG37zkBz2HSNpBhDVRfndsnFK94v+WIgfq7WvDuu+dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QjTuYE3J7hM+zwnh2f9oJ+KIHPS/+HrrGYqN13BOya7wu0W9SAo2aNXUqXjANJaIuvodVTWLLP4hbsreDvn5SgEf1/uqBycfn4D1/8i+T103M1S+wMgtoTtfxTXGM1g7Q+88L2jh6am+az1Y43mJyWZWvAcvyWQYTlbnRpNjOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hrrCH1Vv; arc=none smtp.client-ip=95.215.58.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hrrCH1Vv"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jG37zkBz2HSNpBhDVRfndsnFK94v+WIgfq7WvDuu+dg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791436315; v=1; x=1792041115;
 b=hrrCH1VvG4d7gMC0Eikrozsp4Lx86Ov9Ajhfm8NU7p64xQAa41j3kD4PUH3jorc6/zcO65Cl
 bF2AVArRgFc7q1V9yqA76huVzSdYGYMF9E9QmPvPFhmNH7IMYTY08rml3j2AZXshKJ0bFPfM1nb
 asIXklQkEACvipr/x5SWEyeE=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 60bc3e42b0677a58;
	Thu, 08 Oct 2026 05:11:55 +0000
X-Mizu-Trace-ID: 60bc3e42b0677a58
X-Migadu-Flow: FLOW_OUT
Message-ID: <714b1a9e-560d-4fbb-9dfa-6f1fee5cb13f@linux.dev>
Date: Wed, 7 Oct 2026 22:11:50 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
To: Tristan Madani <tristmd@gmail.com>, linux-rdma@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com, bob.pearson@hpe.com,
 Tristan Madani <tristan@talencesecurity.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261007223222.2342804-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/7 15:32, Tristan Madani 写道:
> From: Tristan Madani <tristan@talencesecurity.com>
> 
> The SoftRoCE driver maps its send work queue into userspace for direct
> posting. The kernel reads WQE fields directly from this shared mapping,
> which allows a concurrent userspace thread to modify fields between
> kernel reads -- classic TOCTOU.
> 
> This series copies each send WQE to a kernel-private buffer before
> processing, in both the requester (patch 1) and completer (patch 2)
> paths.
> 
> Changes since v3:
>    - Copy the full queue element (max_sge SGEs) instead of computing a
>      per-WQE copy size from num_sge. This ensures inline data (which
>      shares the flex array with SGEs) is always captured, and eliminates
>      a TOCTOU on the copy size itself.
>    - Clamp dma.num_sge against qp->sq.max_sge after copy (patch 2)
>      instead of against the global RXE_MAX_SGE constant.
>    - Invalidate the cached copy on QP reset (rxe_qp_reset), on the
>      ERR flush path, and on the RESET state check in the requester.
>      This prevents stale-cache reuse after state transitions.
>    - Each patch now also touches rxe_qp.c for the reset invalidation.
> 
> Changes since v2:
>    - Addressed review comments on naming and ordering.
>    - Writeback status using WRITE_ONCE() instead of plain store.
>    - Added smp_store_release() in requester for state transitions.
> 
> Changes since v1:
>    - Split into per-path patches (requester, completer).
>    - Cache the local copy across retransmits and multi-packet operations.
>    - Added writeback of completion status and rd_atomic state.
> 
> Tristan Madani (2):

Hi,

Please check the feedback from Sashiko.

Thanks a lot.
Yanjun Zhu

>    RDMA/rxe: copy send WQE to kernel buffer before processing
>    RDMA/rxe: copy send WQE to kernel buffer in completer path
> 
>   drivers/infiniband/sw/rxe/rxe_comp.c  | 53 +++++++++++++++++++++++++-
>   drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
>   drivers/infiniband/sw/rxe/rxe_req.c   | 55 +++++++++++++++++++++++++--
>   drivers/infiniband/sw/rxe/rxe_verbs.h | 12 ++++++
>   4 files changed, 116 insertions(+), 6 deletions(-)
> 

