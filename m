Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58A23394B;
	Mon, 27 Jul 2026 02:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785118520; cv=none; b=b0KwWMit//09N9wnk4VR3YQzFheSyp22pbFvk9VZAa567jNsfY/flme6t0DappjOhMGaNGqrPaRoiUYrWmefTYNybOrpgpux7+JgJ7v5P2LbVYNNpvGUchZQNgdzpvndQYP/5BXzwbiB3cio6nMZzPpJJwRxFsJ+q7yMYWF/fWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785118520; c=relaxed/simple;
	bh=+tE9YRHd8mHLdZkbE1oKeRlw639j7MMwvayvDef3G/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgh2Fjsg4/onEyhzpAKs2rd7dZKm4sHha8ZsjzUDpKjvBIrtVtWLAbfnCZdCWUUJOxLJqEsBOcs+cSIOCvcCj+KEL7mNbj9qkJBU7wrhqqw32Tycoox2nfWteJwGYFIq1w0u07jLl4a+qvBL5emkI23PZP4iNkaWov3DEtegH+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dreBF7FN; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dreBF7FN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785118512; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=hOcPIxfh93lxNe7rUy19/b2wiviioqMWuFHWBQo6iXE=;
	b=dreBF7FNUG4d6Vs/KxfwAGkvvpv6Ks0vvNw7h7vzNjqQ+s5Mc2OLZXg6MVRbw/oh9JYVxonfiQYx/tZ5poUQ48C4mxvzRuRZ6dQHrFHwQtFV/g7/6m0kywpkBwRmySqq5U1/I2rhWl37p4ZU30issApG1EfQ2ADzCXEpuKsixsI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X7ogNL8_1785118511;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X7ogNL8_1785118511 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Jul 2026 10:15:11 +0800
Date: Mon, 27 Jul 2026 10:15:11 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: netdev@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: fix out-of-bounds read of rkey array in
 SMC-Rv2 LLC processing
Message-ID: <20260727021511.GA95674@j66a10360.sqa.eu95>
References: <20260724061606.433735-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724061606.433735-1-yhlee@isslab.korea.ac.kr>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Jul 24, 2026 at 03:16:06PM +0900, Yehyeong Lee wrote:
> SMC-Rv2 uses two receive-buffer layouts, selected by
> smc_link_shared_v2_rxbuf() (i.e. lnk->wr_rx_sge_cnt > 1):
> 
>  - shared (device max_recv_sge >= 2): each receive work request posts a
>    small primary SGE plus a spillover SGE that DMAs the message body into
>    the per-link-group lgr->wr_rx_buf_v2 (SMC_WR_BUF_V2_SIZE = 8 KiB) at
>    offset SMC_WR_TX_SIZE.
> 
>  - non-shared (device max_recv_sge == 1): each receive work request posts
>    a single SGE of wr_rx_buflen == SMC_WR_BUF_V2_SIZE, so the whole
>    message lands in the per-WR receive buffer.
> 
> smc_llc_rx_handler() hands the received buffer to smc_llc_enqueue(),
> which copies only sizeof(union smc_llc_msg) bytes into the fixed-size
> qentry->msg and queues the request; the LLC request is then processed
> later from the llc_event_work work item, after smc_wr_rx_process_cqes()
> has already reposted (and thus recycled) the per-WR receive buffer.
> 
> For the shared layout the rkey array survives in wr_rx_buf_v2, and
> smc_llc_rmt_delete_rkey() and smc_llc_save_add_link_rkeys() read it from
> there. For the non-shared layout nothing preserves the message body: both
> functions instead read the rkey array from the truncated qentry copy
> ((struct smc_llc_msg_delete_rkey_v2 *)llc, and (u8 *)add_llc +
> SMC_WR_TX_SIZE), running past the end of the ~72-byte qentry allocation.
> The loop bound num_rkeys comes straight off the wire and is only capped at
> SMC_LLC_RKEYS_PER_MSG_V2 (255), so a peer that sends a DELETE_RKEY or
> ADD_LINK message with an oversized rkey count triggers an out-of-bounds
> read of up to ~1 KiB (delete_rkey) or ~4 KiB (add_link) past a kmalloc-96
> object.
> 
>   BUG: KASAN: slab-out-of-bounds in smc_llc_rmt_delete_rkey+0x6a4/0x780
>   Read of size 4 at addr ffff8880059ee748 by task kworker/0:0H/11
>   Workqueue: events_highpri smc_llc_event_work
>   Call Trace:
>    dump_stack_lvl+0x53/0x70
>    print_report+0xd0/0x630
>    kasan_report+0xce/0x100
>    smc_llc_rmt_delete_rkey+0x6a4/0x780
>    smc_llc_event_handler+0xa13/0xef0
>    smc_llc_event_work+0x189/0x260
>    process_one_work+0x633/0x1030
>    worker_thread+0x45b/0xd10
>    kthread+0x2c6/0x3b0
>    ret_from_fork+0x36e/0x5a0
>    ret_from_fork_asm+0x1a/0x30
>   Allocated by task 43:
>    __kmalloc_cache_noprof+0x158/0x370
>    smc_llc_enqueue+0x72/0x560
>    smc_wr_rx_tasklet_fn+0x474/0xa80
>    ...
>   The buggy address is located 0 bytes to the right of
>    allocated 72-byte region [ffff8880059ee700, ffff8880059ee748)
> 
> Preserve the message body for the non-shared layout as well: in
> smc_llc_rx_handler() copy the bytes beyond SMC_WR_TX_SIZE into
> wr_rx_buf_v2 + SMC_WR_TX_SIZE before the receive work request is reposted,
> exactly mirroring the spillover SGE of the shared layout. The header
> (which for a message that fits in SMC_WR_TX_SIZE contains the whole rkey
> array) is not copied here; smc_llc_rmt_delete_rkey() now restores it from
> the per-qentry copy for both layouts, so a different v2 LLC message that
> reaches the shared wr_rx_buf_v2 between reception and processing cannot
> clobber it. The rkey array is then read from wr_rx_buf_v2, bounded by its
> SMC_WR_BUF_V2_SIZE size.
> 
> The body copy is guarded by lgr->smc_version == SMC_V2, since
> wr_rx_buf_v2 is only allocated for v2 link groups; keying it off the
> link-group version rather than only the wire llc_version prevents a NULL
> dereference should a v2-versioned LLC message arrive on a v1 link group.
> It also removes a latent use-after-free on the SMC-R server add-link path,
> where the non-shared code dereferenced add_llc after its qentry had been
> freed by smc_llc_flow_qentry_del().
> 
> The rkey count is still only capped at SMC_LLC_RKEYS_PER_MSG_V2; the reads
> now stay within the 8 KiB buffer regardless, and validating num_rkeys
> against the received message length is left as a separate hardening.
> 
> Triggering the bug requires a RoCE device that advertises
> max_recv_sge == 1 (a configuration the Fixes: change added support for)
> and a peer emitting an oversized rkey count. Reproduced under KASAN with
> soft-RoCE (rdma_rxe) after forcing wr_rx_sge_cnt = 1.

Could we consider attaching a full copy of the message body directly to
the qentry (e.g. kmalloc(wc->byte_len, GFP_ATOMIC)) for V2 messages that
exceed the 44-byte inline union smc_llc_msg? The only V2 types that grow
beyond the header are DELETE_RKEY_V2 (batch-delete, rare),
ADD_LINK_RESP_V2 with ext (link setup, rare), and REQ_ADD_LINK_V2
(~hundreds of bytes). Memory pressure should be acceptable, and this
also unifies the shared/non-shared paths.

> 
> Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> 
> Resent as a standalone thread per pv-bot: threaded.
> Previous posting: 20260724045310.430202-1-yhlee@isslab.korea.ac.kr
> 
>  net/smc/smc_llc.c | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 954b2ff1815c..84d8d9024efa 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -1099,9 +1099,8 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
>  	if (rc)
>  		goto out_clear_lnk;
>  	if (lgr->smc_version == SMC_V2) {
> -		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
> -			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)llc;
> -		smc_llc_save_add_link_rkeys(link, lnk_new, llc_msg);
> +		smc_llc_save_add_link_rkeys(link, lnk_new,
> +					    (u8 *)lgr->wr_rx_buf_v2);
>  	} else {
>  		rc = smc_llc_cli_rkey_exchange(link, lnk_new);
>  		if (rc) {
> @@ -1501,9 +1500,8 @@ int smc_llc_srv_add_link(struct smc_link *link,
>  	if (rc)
>  		goto out_err;
>  	if (lgr->smc_version == SMC_V2) {
> -		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
> -			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;
> -		smc_llc_save_add_link_rkeys(link, link_new, llc_msg);
> +		smc_llc_save_add_link_rkeys(link, link_new,
> +					    (u8 *)lgr->wr_rx_buf_v2);
>  	} else {
>  		rc = smc_llc_srv_rkey_exchange(link, link_new);
>  		if (rc)
> @@ -1812,12 +1810,15 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
>  	if (lgr->smc_version == SMC_V2) {
>  		struct smc_llc_msg_delete_rkey_v2 *llcv2;
>  
> -		if (smc_link_shared_v2_rxbuf(link)) {
> -			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
> -			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
> -		} else {
> -			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
> -		}
> +		/* Restore the header - and, for a message that fits in
> +		 * SMC_WR_TX_SIZE, the whole rkey array - from the per-qentry copy
> +		 * for both rxbuf layouts, so a v2 message that reached
> +		 * wr_rx_buf_v2 in the meantime cannot clobber it.  The body of a
> +		 * larger message is already in wr_rx_buf_v2 (shared: spillover
> +		 * DMA; non-shared: smc_llc_rx_handler()).
> +		 */
> +		memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
> +		llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
>  		llcv2->num_inval_rkeys = 0;
>  
>  		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
> @@ -2104,6 +2105,26 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
>  	} else {
>  		if (llc->raw.hdr.length_v2 < sizeof(*llc))
>  			return; /* invalid message */
> +		/* For the non-shared v2 rxbuf layout the message body beyond
> +		 * SMC_WR_TX_SIZE lives only in the per-WR receive buffer, which
> +		 * is reposted as soon as this handler returns.  The LLC event
> +		 * handlers run later from a work item and read the body from
> +		 * wr_rx_buf_v2, so copy it there now - only the body, mirroring
> +		 * the shared-rxbuf layout where the spillover SGE DMAs the body
> +		 * into wr_rx_buf_v2 + SMC_WR_TX_SIZE.  The header is left to the
> +		 * handlers, which restore it from the per-qentry copy, so a later
> +		 * message reaching wr_rx_buf_v2 cannot clobber it.  wr_rx_buf_v2
> +		 * only exists for SMC_V2 link groups, so the link-group version
> +		 * is checked (not just the wire llc_version) to avoid a NULL
> +		 * dereference on a v1 link group.
> +		 */
> +		if (link->lgr->smc_version == SMC_V2 &&
> +		    !smc_link_shared_v2_rxbuf(link) &&
> +		    wc->byte_len > SMC_WR_TX_SIZE)
> +			memcpy((u8 *)link->lgr->wr_rx_buf_v2 + SMC_WR_TX_SIZE,
> +			       (u8 *)llc + SMC_WR_TX_SIZE,
> +			       min_t(u32, wc->byte_len, SMC_WR_BUF_V2_SIZE) -
> +			       SMC_WR_TX_SIZE);
>  	}
>  
>  	smc_llc_enqueue(link, llc);
> -- 
> 2.43.0
