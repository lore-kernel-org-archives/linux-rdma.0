Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26553D75B1;
	Tue, 28 Jul 2026 11:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785238499; cv=none; b=AJy/oZFVBMKG+YniH9RZuEtI3sjC7qKLAqkfUlsIICKZUEbT7WIl4ji8ntMm2gdvptuiPNAjuMdlHILHFps90BG+euk8tImX8LspzJ1wWva/ztXSSjgjBcoSg3U+PvqtCZKeBdu/Tm4loyIjziNO5L0SRcg2YpUGs8aiRsQBSh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785238499; c=relaxed/simple;
	bh=6vy5au28jtD8HxoeaBv8y2hyotQQWJxm6KFpOHgDnNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZClxzDHyIjpETVIWhVAJQ7PmFs1pyQkwF+rTa0NfZWnzehHkXIm1MSfZTj3PymJ2swXPoSxm+hVwlh0o/57/Pgupph9srZFx9vmdXePBZ4tA+Gp7+wqqSvc6qKCXHIQGJVthG67dx6wFSpNaWvQtV00NOcVBIC0NtjEjsx1Lxzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wuWJbsIC; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wuWJbsIC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785238485; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=pC3JYw/mzT2qWxAHaOZMxCgpZOFRIe5y355Ny0X5Ot8=;
	b=wuWJbsICB4Le7+DwQ7CFhrwmMC8Z2aElQH8rtMzPojA+dMVZwOUdyT4jzDueyAo5izOYQerhXrpcuUZQc7sAgxL2kFFvJfE4AS6HfIVrf/9ho4QZWQm4eq0hNnSYXgdnoSLnBxJtqO8CDXZ3l3/VbDNVjObX6GWM0ZldK9BC5Yw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8-g6WU_1785238484;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X8-g6WU_1785238484 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 19:34:44 +0800
Date: Tue, 28 Jul 2026 19:34:44 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Ibrahim Hashimov <security@auditcode.ai>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
	wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, horms@kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: validate peer CDC cursor against RMBE
 size before accepting it
Message-ID: <20260728113444.GA12703@j66a10360.sqa.eu95>
References: <20260722101758.37817-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722101758.37817-1-security@auditcode.ai>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jul 22, 2026 at 12:17:58PM +0200, Ibrahim Hashimov wrote:
> smc_cdc_cursor_to_host() converts the wire-format producer/consumer
> cursor of an incoming CDC message into a host smc_host_cursor. It rejects
> a cursor that goes backwards, but never checks that the cursor stays
> inside the buffer it indexes. Per smc_host_cursor ("an offset in an
> RMBE") and the invariant smc_curs_add() enforces for every local advance
> (0 <= count < size), a valid cursor count must be < size and a single
> advance can be at most one bufferful; the wire cursor is peer-controlled
> and was never checked against either.
> 
> smcr_cdc_msg_to_host() accepts the producer and consumer cursors, and the
> unbounded value feeds smc_curs_diff() in smc_cdc_msg_recv_action(), which
> computes the advance without clamping against size. A peer can inflate it
> two ways: an out-of-range prod.count (e.g. 0x7fffffff), or -- since on a
> wrap increment smc_curs_diff() returns (size - old.count) + new.count --
> a cursor with a bumped wrap and new.count above old.count. Either drives
> bytes_to_rcv far past rmb_desc->len, the very invariant the comment above
> the atomic_add() claims but does not enforce.
> 
> smc_rx_recvmsg() then trusts bytes_to_rcv as the amount of valid RMB
> data. Its first copy chunk is safely bounded by rmb_desc->len -
> cons.count, but the second chunk copies (copylen - chunk_len) bytes from
> offset 0, and copylen came from the inflated readable -- an out-of-bounds
> read of the RMB's backing (v)malloc allocation, copied straight to the
> receiving process via _copy_to_iter(). This is a remote kernel-memory
> disclosure driven by a malicious SMC-R peer, needing no local privilege
> on the victim. The same unbounded count also reaches
> smc_cdc_handle_urg_data_arrival() (base + urg_curs.count - 1) -- a
> second, narrower OOB read.
> 
> Reject the bad cursor at ingress, mirroring the cursor-sanity idiom two
> lines above: drop any incoming cursor whose count is outside the buffer
> (>= size), and any whose advance from the last accepted cursor exceeds
> one bufferful (smc_curs_diff() > size), which catches the wrap case.
> smc_cdc_cursor_to_host() gains a size parameter; smcr_cdc_msg_to_host()
> passes conn->rmb_desc->len for the producer cursor and
> conn->peer_rmbe_size for the consumer cursor, bounding it at its single
> origin instead of patching every downstream consumer. SMC-D
> (smcd_cdc_msg_to_host()) does not use this helper and is a separate,
> out-of-scope gap.
> 
> Reproduced on a v6.19 KASAN kernel (SMC-Rv2 over soft-RoCE): a peer
> emitting prod.count=0x7fffffff triggers a vmalloc-out-of-bounds read in
> _copy_to_iter() via smc_rx_recvmsg(), returning ~960 KB of RMB-adjacent
> kernel heap to userspace; an in-range cursor transfers cleanly. With the
> fix the out-of-range cursor is dropped before it reaches
> conn->local_rx_ctrl.prod, and the reproducer returns rc=0 with no report.
> 
> Fixes: 5f08318f617b ("smc: connection data control (CDC)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07
> ---
> v2: also bound the cursor *advance* (smc_curs_diff() <= size), not just
>     the count. A wrap increment with new.count above old.count passes the
>     count check yet still inflates bytes_to_rcv past the buffer -- thanks
>     to sashiko-bot for spotting the count-only gap. Resent standalone.
> 
>  net/smc/smc_cdc.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11f2303..b0ae4d43b017 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
> @@ -221,6 +221,7 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
>  
>  static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  					  union smc_cdc_cursor *peer,
> +					  unsigned int size,
>  					  struct smc_connection *conn)
>  {
>  	union smc_host_cursor temp, old;
> @@ -235,6 +236,21 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  	if ((old.wrap == temp.wrap) &&
>  	    (old.count > temp.count))
>  		return;
> +	/* count is an offset into the RMBE and must always stay inside
> +	 * it (see smc_curs_add()); the peer is untrusted, so reject an
> +	 * out-of-range wire cursor the same way an out-of-order one is
> +	 * already rejected above, instead of letting it drive
> +	 * bytes_to_rcv / the urgent-byte offset past the buffer end
> +	 */
> +	if (temp.count >= size)
> +		return;
> +	/* Bound the advance too: a wrap increment with temp.count above
> +	 * old.count makes smc_curs_diff() report more than one bufferful,
> +	 * which would inflate bytes_to_rcv / peer_rmbe_space past the buffer
> +	 * in smc_cdc_msg_recv_action(). Reject such a cursor.
> +	 */
> +	if (smc_curs_diff(size, &old, &temp) > size)
> +		return;


At minimum there should be a rate-limited log indicating something
unusual happened. Ideally the connection should be actively aborted,
a peer sending an out-of-range cursor is either malicious, buggy, or the
data is corrupted, and silently continuing is pointless.


>  	smc_curs_copy(local, &temp, conn);
>  }
>  
> @@ -246,8 +262,10 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  	local->len = peer->len;
>  	local->seqno = ntohs(peer->seqno);
>  	local->token = ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod,
> +			       conn->rmb_desc->len, conn);
> +	smc_cdc_cursor_to_host(&local->cons, &peer->cons,
> +			       conn->peer_rmbe_size, conn);
>  	local->prod_flags = peer->prod_flags;
>  	local->conn_state_flags = peer->conn_state_flags;
>  }
> -- 
> 2.50.1 (Apple Git-155)
