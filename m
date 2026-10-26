Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031340;
	b=qUGorbm3ADWXWlwcaf0HMgs0eM3wyPIqhd/zEtyF7Tj33LMwReWWktDszEbPLQ2xy3RV
	 764Vpnb+t+Hm1hzGMCekFM9bYF2QUlfcDVaFqyBzqcduU4JeHjcUFJpZRYtQCYGtR97js
	 HZV/iWFKghmzz3K3JFB6WijyieVeL4rPvGeh7DcCUWfzYJUQ3ySbwcqSmYMlltw1u59wH
	 sc38AVV0mh79m3IjlZoy5r5g81KQVjM2n8SPMCbZ8Yn81Pc89V+7Qlo7hZiL34yRVKv45
	 bN3tAF83TniPttaDRGQj8PqlipdwgF9mO6BZteR3mfMuQUcwXcCx9/6I2F5BNfLnATg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031340;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=mRh/ong/rylw6B0mhNzZ9ejxk6w+lMJz4x7A5WsGPF4=;
	b=SHla7VIPDhKg2FFtGIx25lC+11/bPrRjtT5Aq4zii9GXtxQtLUxQP4594NTxvbTdpBq+
	 MAbBdMOtdywgA3ozHbS8fs4iVrAiERO2oufRwQUJvZKGRSlnWRsaYdkgFpRrsvzdML6po
	 kgvjOr4fc8hgVmzI3ovq3UBbZ5W/UQqOFFO2QFHcFwblAV2tGFt8wA1TsipES+gqHc5wg
	 GaZ0OTr/9fBMEVjkf2jjAukJwHeBZJPdJcvPnR5cx7Ioed6AXxAHx4CtnM1K4/iGI+NUL
	 0vVjf5oWsc4kknpCN45NVTXSk67jGgRYHOEhZWh0pS1OIgDvo6LKiJpbmLutzxCcbfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FSla6zWU;
	arc=none smtp.remote-ip=91.218.175.216
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947E3606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 16:15:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 947E3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FSla6zWU
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CRWNODE6Y4CZb11tIQdIQQiohQPx5uWl6mY9NgXKl8s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793031336; v=1; x=1793636136;
 b=FSla6zWUAxUF+GfmjP5npv1DYeaNBnvk/WNIWow1GFff/XvVTiqXCGOYAem3Outgj8UbnK8A
 ioucaf7TiuINL0Vz3JIxTr7xrxokv5iapmB8dUdp2GCAHP9c2Bi4PqlXHs4WXjgFgzNIsu56SCJ
 x2O80OqgqqOoIhKbL1DFgUDw=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id da6db1eb53805c71;
	Mon, 26 Oct 2026 16:15:28 +0000
X-Mizu-Trace-ID: da6db1eb53805c71
X-Migadu-Flow: FLOW_OUT
Message-ID: <4bb4700c-7967-4d48-9c00-3314a04e2249@linux.dev>
Date: Mon, 26 Oct 2026 09:15:24 -0700
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
To: Tristan Madani <tristmd@gmail.com>, linux-rdma@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com, rpearsonhpe@gmail.com
References: <20261026001405.1698455-1-tristan@talencesecurity.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261026001405.1698455-1-tristan@talencesecurity.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/25 17:14, Tristan Madani 写道:
> The SoftRoCE driver maps its send work queue into userspace for direct
> posting. The kernel reads WQE fields directly from this shared mapping,
> which allows a concurrent userspace thread to modify fields between
> kernel reads -- classic TOCTOU.
> 
> This series copies each send WQE to a kernel-private buffer before
> processing, in both the requester (patch 1) and completer (patch 2)
> paths.
> 
> v6 adds post-copy sanitization of attacker-controlled fields to address
> the automated review findings from v4/v5:
> 
>    - wr_opcode_mask() OOB: both patches now reject opcodes >
>      IB_WR_ATOMIC_WRITE before the array access.
> 
>    - num_sge clamp: both patches now clamp dma.num_sge against
>      qp->sq.max_sge immediately after copy, before any SGE walk.
> 
>    - sge_offset / resid / cur_sge: the requester already had a
>      num_sge + cur_sge bounds check after req_next_wqe() (lines
>      754-760 of rxe_req.c). With the copy, these fields are now
>      frozen, so the existing check is sufficient.
> 
>    - FORTIFY_SOURCE: struct rxe_send_wqe ends with a flex array
>      (__DECLARE_FLEX_ARRAY in rxe_dma_info), so __builtin_object_size
>      returns (size_t)-1 for the memcpy. This is identical to the
>      merged receive-path fix (d6ab440240a04) and is a tooling
>      limitation, not a bug.
> 
>    - Flush/retry/posted-state paths: these write directly to shared
>      memory (flush, posted) or invalidate the cache and take a fresh
>      copy (retry), identical to pre-patch behavior. Not affected by
>      this series.
>

I’ve reviewed the feedback from Sashico, and some of the comments still 
make sense. Some of the more interesting points deserve a closer look so 
we can better understand the issues and address them.

Yanjun Zhu


> Changes since v5:
>    - Added opcode bounds check after copy in both requester and
>      completer to prevent OOB access via wr_opcode_mask().
>    - Added num_sge clamp in requester after copy (completer already
>      had it in v5).
>    - Resent as standalone patchset from the correct sender address.
> 
> Changes since v4:
>    - Resent from the correct sender address. No code changes vs v4.
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
>    RDMA/rxe: copy send WQE to kernel buffer before processing
>    RDMA/rxe: copy send WQE to kernel buffer in completer path
> 
>   drivers/infiniband/sw/rxe/rxe_comp.c  | 60 +++++++++++++++++++++++++-
>   drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
>   drivers/infiniband/sw/rxe/rxe_req.c   | 64 +++++++++++++++++++++++++--
>   drivers/infiniband/sw/rxe/rxe_verbs.h | 12 +++++
>   4 files changed, 132 insertions(+), 6 deletions(-)
> 

