Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05884F30E5
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891969; cv=none; b=dSbdTD8SgBO/9HFsijcfbCjPbA8iVT51iu0rv2O8yiuT+nDSPQ9mH+8f+NLjuRKODStInWX+Fw456GctytEIZ+gfXAWva6fJriJTB4kLDydgJKBq93UF9P5ZjJecv+IYZW2oxu5b0SJWvK/NBB4ZlZ02QrMlQJ6n5yHOYB/t2fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891969; c=relaxed/simple;
	bh=GstaRhF4xHedbsTuk725VmTvdBXcpYlnQOo4QFeNsNg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=E0g+McZD5m0+fSeu4W0ldmpU5aELD1sdz8EWpsLX5MDArSKU+PxAnPg8R1jTWWnobOgaGZU8rq2mB1JFMO2/TtziXtU7a1R3GwYO3jpWCFaUjztEXDP9lGnNPZyNTLCVwlTbll2re4fuHi30AwYhJpR8SGTvnAvdwDE47ZflxS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6tiA4qm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6tiA4qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D32C1F00898;
	Tue, 13 Oct 2026 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891968;
	bh=GstaRhF4xHedbsTuk725VmTvdBXcpYlnQOo4QFeNsNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b6tiA4qm9hcAeaRITosXUg+nYaaxAItDPcCEo9hA+m9HzwuwSBoveaP2xnswe1ucs
	 wpKMbwYGp/qArTWS3lutB87qnJHhs4kiGJrP1RYBaicfsVCq04oSzS+W6s6nMix+ue
	 kBicj4cXvS50p99WhrCqKsS/9C/GchrTMs9gFSpX8drigAU1oBd/Ebkqev8U13rhWi
	 iEhph9KK78fOoy6Rf9Yxd2gCZRJTtGZptAIrOfguucOcZkn0OORb5lcHXTPxA35BAL
	 4lC5NIVa4qqUh3gvTd+EpO1OQ0lm16z8QupniXAsYrdkr6FFtrdefn3SYA1j0ewuhv
	 48GoI4qWSWnwQ==
Message-ID: <sashiko-outbox-169640@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/15] yunsilicon: add ethernet TX path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114408.2471317-8-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114408.2471317-8-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 12 potential issue=
(s) to consider:
- [Critical] net: stale wi->skb pointer causes infinite loop and double-fre=
e on spurious CQE
- [High] net: unpopped error CQE causes infinite NAPI polling loop
- [High] net: inverted return logic in xsc_poll_tx_cq causes NAPI interrupt=
 storms
- [High] net: TX queue can permanently stall due to missing smp_mb() after =
netif_tx_stop_queue
- [High] net: NAPI instances are deleted without being disabled in xsc_eth_=
open_channels error path
- [High] net: NULL pointer dereference of aff_mask in xsc_channel_no_affini=
ty_change
- [High] yunsilicon: memory and DMA leak on TX queue teardown
- [Medium] net: unconditional memory leak of mailbox buffer in xsc_eth_set_=
cq
- [Medium] net: SQ DB arrays leaked on error path in xsc_eth_open_qp_sq
- [Medium] net: firmware teardown failures cause software memory leaks
- [Medium] net: TX packets are double-counted on retry and miscounted on dr=
op
- [Medium] net: missing u64_stats_sync for 64-bit per-queue network statist=
ics
--

commit 68f71bfadd8545a6a72866ea79110d42b134cfcb
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add ethernet TX path

This commit adds the transmit path for the yunsilicon ethernet driver.
It introduces WQE construction, completion handling, and ndo_start_xmit.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c, inside the
xsc_poll_tx_cq function around line 62, the code detects an error CQE
and returns false without calling xsc_cqwq_pop. Will this cause the NAPI
polling loop to wedge permanently as subsequent polls re-fetch the exact
same CQE? Additionally, the CQEs fetched inside the do-while loop around
line 99 bypass the error check entirely, which might result in error
CQEs being processed as successful completions.

[Severity: High]
Also in xsc_poll_tx_cq around line 99, the polling loop uses the condition
++i <=3D napi_budget. If the budget is fully exhausted, the loop breaks with
i equal to napi_budget + 1. The function then returns i =3D=3D napi_budget,
which evaluates to false. Can this inverted return logic cause NAPI to
prematurely end the polling cycle while the queue is still full, leading
to interrupt storms?

[Severity: Critical]
Further down in xsc_poll_tx_cq around lines 84 and 96, napi_consume_skb
frees the SKB but leaves the wi->skb pointer intact. If the cyclic buffer
wraps around and a spurious CQE is fetched, this dangling pointer will
falsely pass the !skb condition check, resulting in a double-free of the
SKB and double DMA unmap. Furthermore, the handling for spurious CQEs uses
continue to skip the rest of the loop without advancing sqcc and
dma_fifo_cc. Does this result in an infinite loop by re-processing the
same SW WQE?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c, within the
xsc_txwqe_complete function around line 185, netif_tx_stop_queue is
called if the queue lacks room. Should there be an smp_mb barrier and a
space re-check immediately after stopping the queue? Without an explicit
barrier, concurrent NAPI updates could race with the TX path, permanently
stalling the TX queue.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/net/main.c, inside the
xsc_eth_set_cq function around line 427, the mailbox buffer in is
allocated with kvzalloc. On successful completion of xsc_core_eth_create_cq,
the function returns 0 but skips freeing the buffer. Can we add a kvfree
for the buffer on the success path to avoid permanently leaking this memory?

[Severity: Medium]
Similarly, in xsc_eth_open_qp_sq around lines 560 and 586, if a setup step
like modify_in allocation fails, the error path jumps to
err_sq_common_destroy. This path destroys the WQ and QP but does not call
xsc_free_qp_sq_db. Does this leak the dma_fifo and wqe_info arrays
allocated earlier in the function?

[Severity: High]
When tearing down channels in xsc_eth_open_channels (error path around line
639) and xsc_eth_close_channel (around line 605), netif_napi_del is
called directly. Because napi_enable was already called, should
napi_disable be executed prior to deletion to prevent a use-after-free if
the NAPI instance is scheduled concurrently?

[Severity: Medium]
In xsc_eth_close_cq and xsc_eth_close_qp_sq around lines 349 and 492, the
functions return early if xsc_core_eth_destroy_cq or
xsc_core_eth_destroy_qp report a firmware error. Bypassing xsc_eth_free_cq
and xsc_free_qp_sq on these errors appears to indefinitely leak the OS
level queue memory if the firmware is unresponsive. Is it intentional to
skip freeing software memory on a firmware timeout?

[Severity: Medium]
In xsc_eth_xmit_frame around lines 234 and 262, stats->packets is
incremented preemptively. If the packet exceeds a single WQE and is passed
to skb_linearize, a successful linearization jumps back to retry_send,
causing the packet to be double-counted. If linearization fails and jumps
to err_drop, the counter is not reverted. Should the statistics update be
moved after we guarantee the packet will not be dropped or retried?

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c, the function
xsc_channel_no_affinity_change around line 23 directly dereferences
c->aff_mask in cpumask_test_cpu. Since c->aff_mask is only assigned when
xdev->caps.msix_enable is true, and irq_get_affinity_mask can return
NULL, will this cause a NULL pointer dereference during NAPI polling on
systems without MSI-X?

[Severity: Medium]
In xsc_eth_xmit_frame around line 290, 64-bit statistic counters like
stats->bytes and stats->packets are updated directly. To prevent torn
reads on 32-bit architectures, should these per-queue statistics be updated
using the u64_stats_update_begin and u64_stats_update_end macros?

[Severity: High]
In xsc_free_qp_sq_db around line 436, the tracking arrays sq->db.wqe_info
and sq->db.dma_fifo are freed. It appears the function does not drain and
unmap active elements between sq->cc and sq->pc first. Can this lead to
a silent leak of SKBs and DMA mappings when the interface is stopped or
reconfigured while traffic is active?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D7
