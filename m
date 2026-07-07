Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04FF33066D;
	Tue,  7 Jul 2026 09:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783416557; cv=none; b=ANfwTCPXLR7ae+f9BPVMcvZ9Y7bpTTNwUbYrMcOvhigF/FadaJqG4on24G0hMIY/mgbktDlkQBgqrjKLHN2vIRS6GKdUU2iOdM4IpxIKs7eVJIvUGg2osGVQZGkgW1hNGl7AWaDzpG5+S+v/lJkwwMmGtqVoqm86v1GWbCoVtt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783416557; c=relaxed/simple;
	bh=hZkT2Dsk6x1Rc8lxbgya9SVeGD89lnwkYlre0tYxc2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EaVvxV+8a4S0AsvCSDgff+Br7NDj2ibq+noCp08D1uYw4MrslasZBdeWyNyWbLUP8RjDwOdjiDLziKmQQlLhpJh/ajwYxsuIVDpB0rhTs6diKX1reZjO9F2MangL33mt27S+XwWUc0kVvix+xF0gZjqYidJqMR8wEmi3Nt0EDDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pHBhzdAI; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pHBhzdAI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783416546; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=x/JBmUH0AmD4h3bq2fvjuR02nLqqtA1dtweQcgT9r2k=;
	b=pHBhzdAIaNpia0nJojGu+fKNii3HdKyNGNztCwxn8bFH7pDMawwPbLLOPG9JcPTWuQGz7YHS1VB/BGRNuEmhDfIEtoRuo+lS0/rKyM4FkwzudoUKAKVeRkLc+slZ/TSjhNizhZx5dxUdrZVPDGzPx1QYXNEVoax9hB07b6XcRx8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X6cl3KV_1783416545;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X6cl3KV_1783416545 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 17:29:05 +0800
Date: Tue, 7 Jul 2026 17:29:04 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: hexlabsecurity@proton.me, "David S. Miller" <davem@davemloft.net>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Eric Dumazet <edumazet@google.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Ursula Braun <ubraun@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Message-ID: <akzG4Hfeom6fNzFX@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>

On 2026-07-05 02:54:04, Bryam Vargas via B4 Relay wrote:
>A peer's CDC producer/consumer cursors are copied from the wire and used,
>without an upper bound against the local buffers, as (a) a raw index into the
>RMB on the urgent path, (b) the receive length in smc_rx_recvmsg(), and (c) the
>send length in smc_tx_sendmsg() on the SMC-D DMB-merge path. A malicious or
>buggy peer can forge a cursor so each runs past the relevant buffer: an
>out-of-bounds read of adjacent kernel memory (disclosed to the peer) on the
>receive/urgent side, and, on the send side, an out-of-bounds write whose
>length the peer controls and whose overflowing bytes are the local sender's
>own outbound data.
>
>This series bounds each length where it is consumed. The clamp is synchronous
>and race-free against the tasklet that advances the cursor, so it is the minimal
>fix for stable. A separate net-next series adds the wire-boundary validation and
>connection abort that Dust Li suggested; those do not replace these clamps.
>
>The clamp is not subsumed by validating cursors at the input boundary. A peer
>that only increments prod.wrap with count == 0 hits the differing-wrap branch of
>smc_curs_diff(), which returns (len - 0) + 0 == len every CDC, so bytes_to_rcv
>(and sndbuf_space on the send side) accumulates past the buffer while every
>per-cursor bound sees count == 0 and accepts the message. The overflow lives in
>the accumulator, not the cursor; only the consumer-side clamp bounds it. And
>because a queued abort runs asynchronously (queue_work -> smc_conn_kill) while
>smc_rx_recvmsg() reads the accumulator under lock_sock, only the synchronous
>clamp closes that window. So the clamp goes to stable; the abort is net-next.
>
>The nearby readable >= rmb_desc->len / len > sndbuf_desc->len tests only feed
>statistics counters (SMC_STAT_RMB_RX_FULL / SMC_STAT_RMB_TX_SIZE_SMALL) on an
>earlier, separate read; they do not bound the copy.
>
>A/B (in-kernel KASAN replaying the sink arithmetic over a real rmb_desc->len /
>sndbuf_desc->len slab; kasan.fault=report kasan_multi_shot, 2026-07-05):
>  - urgent index (1/3):  count = len+1        -> slab-out-of-bounds Read;  clamped -> clean
>  - recv length  (2/3):  bytes_to_rcv = 5*len via wrap++/count=0 -> OOB Read; clamped -> clean
>  - send length  (3/3):  sndbuf_space inflated -> slab-out-of-bounds Write; clamped -> clean
>  - signed overflow:     readable = -1 -> v1 ">len" misses -> OOB; "<0 || >len" -> clean
>  - concurrent TOCTOU race: a producer-side clamp is racy (OOB in a racing consumer
>    kthread on another CPU); the consumer-side clamp is race-free (0 hits / 5,000,000 reads).
>  - every in-bounds / honest-peer arm: clean.
>
>Changes since v3:
>  - split into this stable-bound clamp series and a separate net-next
>    validate/abort series, per Dust Li's review;
>  - tightened the commit messages; noted that the nearby SMC_STAT_* tests are not
>    bounds; no functional change to the three clamps.
>  v3: https://lore.kernel.org/all/20260614-b4-disp-edd64be9-v3-0-551fa514257e@proton.me/

Hi Bryam,

Are you planning to land these clamps first, and then follow up with a
separate validate/abort series?

Looking at your earlier A/B test, it simulates this logic in userspace to
demonstrate the bug, but it doesn't actually trigger the bug in our
current kernel. If that's the case, the security risk here doesn't seem
high to me, since SMC is only meant to be deployed in trusted environments.

On the other hand, once this is actually triggered, it means the data
we've been handing to userspace is already wrong, which is already a
serious problem, and the connection should be terminated. So I don't
really see much value in merging the bound-clamp patches first.

So, I'd expected to see the real bug and validation/abort patch.

Best regards,
Dust

