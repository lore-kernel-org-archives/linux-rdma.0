Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241CA4F30FD
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891970; cv=none; b=QrfPQIk/SwLkyM6EB3mEmQWWAH14cRwmxR0eynUcMt35T7GfsWpVHkzMmoCSgKaoK7KH9OYAhXblV8L5luo+rhJ1BY3e6QMXYiirwXbJflDVik/ckGfWq6X/OkzKeomK7nnCD7XyzQXJp1BmI6Qvpi8de2MXkka7nc0TA7scpZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891970; c=relaxed/simple;
	bh=fd9+VNi36CZ3udysCe7gwuvkAI2rlzf3hXNdyphx+0Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DbZN0bvxvzWUQvMPOmqjSLMHUlH/sWhCXSW1QXtmhQND7fevkg8peyl5fyj5vxZxfSrcIsFgjQAFSkmiu3CCwJLl2DKpi3UVibed55RisUasK6nFv5us/n3lNXGSQLXb/gkZ9XCvmIiN+4ezZX+Mcj7IxyDBFbRGsOqXwi5kYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPQklYEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPQklYEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D011F00899;
	Tue, 13 Oct 2026 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891968;
	bh=fd9+VNi36CZ3udysCe7gwuvkAI2rlzf3hXNdyphx+0Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DPQklYExjd3j89hphIQMuJQ/na5dqzGfuZj4Szmo9w5QiKNWrUeW2bQYz9QkVWGxL
	 banvWsE6VVk/ALd8dmTeTSv7AHbdl++S/Q6z3LBq4h+jq7K6sRqWIFvVHDE4yQ98P8
	 vF5ifC18+qCofQWdvGL0IpEShnfEN74HRKrLU9SpeUk0aElTT4BPPCX/5jCoUDI/kL
	 GyhkXRFm8wrtzq6hh5wC9Un6JmAJ/0Q0W7/TjVl6YeMhlqSaGv01z/3r+MCM477Ms3
	 Qoa/qo8cLsnhCysHUF8/RhDPc/p2VUc9FTLLgoTnFQSTElQOKSVhWRsVzmrvaimuAc
	 2jqlwsStvrHJQ==
Message-ID: <sashiko-outbox-169641@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/15] yunsilicon: add ethernet RX path and statistics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114410.2471317-9-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114410.2471317-9-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:08 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 16 potential issue=
(s) to consider:
- [High] net: memory and resource leak in xsc_eth_open_rss_qp_rqs error path
- [High] net: out-of-bounds access in xsc_alloc_rx_wqes error path
- [High] net: page pool leak due to missing skb_mark_for_recycle
- [High] net: xsc_handle_csum reads out-of-bounds garbage due to missing he=
adroom and PPH flag checks
- [High] net: missing napi_disable() in xsc_eth_open_channels error path
- [High] net: soft lockup in xsc_eth_napi_poll on RX buffer allocation fail=
ure
- [High] net: xsc: off-by-one in xsc_poll_tx_cq causes TX queue stalls
- [High] net: missing DMA sync for PPH header in non-linear RX path
- [High] net: xsc_handle_csum treats MAC header as PPH when PPH is absent
- [High] net: memory and resource leak in xsc_eth_open_rss_qp_rqs error path
- [Medium] net: missing u64_stats_sync for 64-bit network statistics
- [Medium] net: memory leak in xsc_eth_close_qp_rq if hardware destruction =
fails
- [Medium] net: page leak in xsc_alloc_rx_wqes error path for multi-fragmen=
t pages
- [Medium] net: missing DMA sync for PPH header in xsc_handle_csum
- [Medium] net: uninitialized rx headroom causes skb reallocation
- [Medium] net: missing u64_stats_sync protection for 64-bit RX/TX statisti=
cs
--

commit 4d5a3a720a692e412128ddb17b3a9264e7943e11
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add ethernet RX path and statistics

This commit adds the receive path for the yunsilicon driver, including page
pool backed RX queues, NAPI polling, CQ processing, and RSS/checksum
handling. It also introduces software statistics reporting via ndo_get_stat=
s64.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.c around line 31 in
xsc_eth_fold_sw_stats64, and in drivers/net/ethernet/yunsilicon/xsc/net/xsc=
_eth_rx.c
around line 158 in xsc_complete_rx_cqe, is it safe to update and read the
raw 64-bit counters without u64_stats_update_begin/end?

The driver tracks RX/TX packets and bytes using 64-bit counters (struct
xsc_rq_stats and struct xsc_sq_stats). These are updated in NAPI softirq
context without sequence locks, and read concurrently from process context
by ndo_get_stats64. On 32-bit systems, a 64-bit load/store is not atomic,
which can cause readers to observe torn values. Can we wrap these 64-bit
statistic updates and reads with the u64_stats_sync API to ensure correctne=
ss
across architectures?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c around line 956 in
xsc_eth_open_rss_qp_rqs, does the direct return of 'err' cause a memory
and resource leak?

The driver allocates software receive queues and their backing memory inside
a loop. If the firmware command xsc_core_create_resource_common() fails for
any queue, the code sets 'err =3D ret', continues the loop, and later execu=
tes
a direct 'return err;'. This direct return bypasses the err_create_rss_rqs
and err_alloc_rqs cleanup labels entirely, permanently leaking all previous=
ly
allocated WQ controls, fragment arrays, DMA pages, and page pools across all
channels.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c around line 943 in
xsc_eth_close_qp_rq, will a hardware destruction failure result in a
permanent software resource leak?

The driver issues the firmware command xsc_core_eth_destroy_qp() to destroy
the hardware queue. If this command fails, the function returns early,
skipping the vital software cleanup routines xsc_eth_free_rx_wqe() and
xsc_free_qp_rq(). Since the caller xsc_eth_close_channel() around line 1046
ignores this return value and unconditionally zeroes out the queue structure
pointers with memset, the dynamically allocated page pools, fragment arrays,
and DMA lists are permanently orphaned.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c around line 454 in
the xsc_alloc_rx_wqes error path, does passing the unmasked index 'ix + i'
cause an out-of-bounds array access?

When allocating WQEs successfully, the driver correctly calculates the
wrapped index using xsc_wq_cyc_ctr2ix(wq, ix + i). However, if an allocation
fails, the err_free_wqes recovery path passes the raw, unmasked 'ix + i'
directly to xsc_eth_dealloc_rx_wqe(). This function then passes the out-of-
bounds index to get_frag() around line 313, which blindly shifts the
unmasked value and accesses rq->wqe.frags, resulting in out-of-bounds
kernel memory reads/writes.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c around line 224 in
xsc_skb_from_cqe_linear, is there a page pool leak due to the missing
skb_mark_for_recycle() call?

In both the linear and nonlinear RX paths, the driver allocates pages from a
page_pool and attaches them to an SKB, but fails to call
skb_mark_for_recycle(skb). Without setting the recycling flag, when the
networking stack eventually frees the SKB, it will drop the page reference
via the standard put_page() path instead of routing it to
page_pool_recycle_direct(). This leaks the page pool's inflight counter and
prevents proper page recycling.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c around line 82 in
xsc_handle_csum, does the code read uninitialized out-of-bounds memory and
incorrectly parse the MAC header?

The function computes the hardware Packet Processing Header (PPH) address
using page_address(dma_info->page) + offset_from. This calculation omits
rq->buff.headroom, causing the pointer to reference uninitialized memory
before the packet payload. Additionally, the function unconditionally casts
the first bytes of this buffer to a PPH structure to read the error bitmap
without checking if the CQE indicates a PPH is present (via
XSC_CQE_HAS_PPH). If a packet lacks a PPH, this will read the Ethernet MAC
header as if it were a PPH, which can trigger random drops or misinterpret
the checksum offload status.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c around line 305 in
xsc_put_rx_frag, can a partial allocation failure leak multi-fragment pages?

The driver manually fragments a single allocated page across multiple WQEs,
setting frag->last_in_page =3D 1 only on the final fragment of the page. The
recycling function relies strictly on this flag to call
page_pool_recycle_direct(). If an allocation fails midway in
xsc_alloc_rx_wqes(), the rollback path deallocates the partially populated
WQEs. If the rollback includes fragments of a page but does not reach the
WQE containing last_in_page =3D=3D 1, the page is skipped and never recycle=
d,
permanently leaking the page reference.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c around line 240 in
xsc_skb_from_cqe_nonlinear, does advancing head_offset leave the PPH header
unsynchronized for the CPU?

When a packet has a PPH header, head_offset is advanced by XSC_PPH_HEAD_LEN
before copying the header to the linear SKB buffer. As a result, both
xsc_copy_skb_header() and xsc_add_skb_frag() entirely skip the first
XSC_PPH_HEAD_LEN bytes when calling dma_sync_single_for_cpu(). Later,
around line 81, xsc_handle_csum() reads the PPH from the very beginning of
the DMA buffer. Since this memory was never synced for the CPU, non-cache-
coherent architectures will read stale memory, potentially causing the PPH
error bitmap check to fail.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c around line 1051 in
xsc_eth_close_channel, is there a use-after-free risk due to a missing
napi_disable() in the error path?

During xsc_eth_open_channels() around line 1100, NAPI instances are enabled
for all channels. If a subsequent operation fails, the driver jumps to
err_close_channel. However, xsc_eth_close_channel() only calls
netif_napi_del() and entirely omits calling napi_disable(). Because
netif_napi_del() unlinks the struct but does not stop or wait for active
polling to complete, a concurrent xsc_eth_napi_poll() could run while the
underlying channel structures and memory are being freed.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c around line 142 in
xsc_eth_napi_poll, does an RX buffer allocation failure trigger an infinite
NAPI poll loop?

The driver attempts to replenish RX WQEs by calling rq->post_wqes(rq). If
memory allocation fails (e.g., page pool exhaustion), this function sets the
busy flag to true. Because busy is true, the NAPI poll routine
unconditionally returns the full budget rather than the actual work_done.
Returning the full budget signals to the networking core that the driver has
exhausted its quota and still has more work to do, causing the kernel to
immediately reschedule the NAPI poll, creating a 100 percent CPU soft lockup
until memory becomes available.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c around line 110 in
xsc_poll_tx_cq, does the loop condition cause premature NAPI termination and
TX queue stalls?

The do-while loop condition (++i <=3D napi_budget) allows the loop to execu=
te
napi_budget + 1 times when the TX queue has more completions than the
budget. After processing napi_budget + 1 CQEs, the loop terminates with i
equal to napi_budget + 1. The function then returns (i =3D=3D napi_budget),
which evaluates to false. This incorrectly indicates to the caller that the
TX budget was not exhausted. If RX polling also finishes within its budget,
NAPI polling stops. Because there are still pending unpolled TX CQEs that
will not trigger a new MSI-X interrupt, the TX queue can stall permanently.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c during xsc_eth_alloc_rq,
is rq->buff.headroom left uninitialized, causing SKB reallocation in the
RX hot path?

The driver defines rq->buff.headroom but never initializes it, leaving it
at 0. Later, in drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c around
line 207 in xsc_skb_from_cqe_linear, this results in skb_reserve(skb, 0).
Creating linear SKBs with 0 headroom forces the network stack's core
processing paths to reallocate the SKB header (via pskb_expand_head)
whenever headers need to be prepended, causing significant performance
degradation. The comment about the XDP frame data area suggests headroom
was intended to be reserved but was forgotten.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D8
