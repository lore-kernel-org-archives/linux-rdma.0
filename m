Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145F128FFF6;
	Wed, 22 Jul 2026 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784692073; cv=none; b=qgbbl+Q9YN6CT4vPl7kJiwSaqhPY6KLcVjwz4TvHze6EMcW6tQjk7D8HYFNoq2Cynf+Vl7wVWQ/5vUJCqGlWD/diWtKdefAyT9cSeIDkltw5IKpQM7EOpUTfJcyXqDlNlxhb8uqoIjCTS5Ql0ta95+z3evCxRZ7YipHk2SeUaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784692073; c=relaxed/simple;
	bh=U5orYbkn7aAXqsiQ0r8ZE2YgklsSx9sVL827kt2SKYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ljqt92kJimSPvYtxzLhn8SCejajYmihWkeG/3odGtYGgmmCFAWR9zhgOX7201n2DKE6v6m6MqKoWZdEs+Clh7Hn2m+CuNvUTsHR1vVnSi915yqH9Ij7PvBnCI0UGATm0Eoh3HVTPHBckYvwwtsfwcCPvliNKONX0Avi3jwwGiYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s21uDTcD; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s21uDTcD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784692062; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=DdS7iV0fw22ioV9moVyPfHztNR68dF8K57N0I2joKNU=;
	b=s21uDTcD3VrW9l1M0JeIeRvvJ2Hgms8uE80W4NsOpqjay6s1vp5+obyF3QFP991NFJj4lqBgAv9YObkitqxG3HUeHfrvRzgEleWpcH570376j6L4QShXIelw49rL6rS2tYf8jLfHH1b/RjWXNPRYtIGokTCGqOfVKT19Ea2QyeY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X7c0hKr_1784692060;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X7c0hKr_1784692060 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 11:47:41 +0800
Date: Wed, 22 Jul 2026 11:47:40 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Ibrahim Hashimov <security@auditcode.ai>, alibuda@linux.alibaba.com,
	wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursor against RMBE size
 before accepting it
Message-ID: <amA9XGOWH3z4Z1fu@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260720170717.11425-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720170717.11425-1-security@auditcode.ai>

On 2026-07-20 19:07:17, Ibrahim Hashimov wrote:

Hi Ibrahim,

I believe Bryam already sent a similar patch to the mailist and I have already
reviewed it.

https://lore.kernel.org/netdev/20260705-b4-disp-28a1bbca-v4-1-be089b98acc6@proton.me/

Best regards,
Dust


>smc_cdc_cursor_to_host() converts the wire-format producer/consumer
>cursor of an incoming CDC message into a host smc_host_cursor. It rejects
>a cursor that goes backwards, but never checks that the cursor's count is
>inside the buffer it indexes. Per smc_host_cursor ("an offset in an
>RMBE") and the invariant smc_curs_add() enforces for every local advance
>(0 <= count < size), a valid cursor count must be < size; the wire cursor
>is peer-controlled and was never checked against that.
>
>smcr_cdc_msg_to_host() accepts the producer and consumer cursors, and the
>unbounded value feeds smc_curs_diff() in smc_cdc_msg_recv_action(), which
>computes new->count - old->count without clamping against size. A peer
>that puts an out-of-range prod.count on the wire (e.g. 0x7fffffff) drives
>bytes_to_rcv far past rmb_desc->len -- the very invariant the comment
>above the atomic_add() claims but does not enforce.
>
>smc_rx_recvmsg() then trusts bytes_to_rcv as the amount of valid RMB
>data. Its first copy chunk is safely bounded by rmb_desc->len -
>cons.count, but the second chunk copies (copylen - chunk_len) bytes from
>offset 0, and copylen came from the inflated readable -- an out-of-bounds
>read of the RMB's backing (v)malloc allocation, copied straight to the
>receiving process via _copy_to_iter(). This is a remote kernel-memory
>disclosure driven by a malicious SMC-R peer, needing no local privilege
>on the victim. The same unbounded count also reaches
>smc_cdc_handle_urg_data_arrival() (base + urg_curs.count - 1) -- a
>second, narrower OOB read.
>
>Fix it where the wire cursor is accepted, mirroring the cursor-sanity
>idiom two lines above: reject any incoming cursor whose count is >= the
>size of the buffer it will index. smc_cdc_cursor_to_host() gains a size
>parameter; smcr_cdc_msg_to_host() passes conn->rmb_desc->len for the
>producer cursor and conn->peer_rmbe_size for the consumer cursor. This
>bounds it at its single origin instead of patching every downstream
>consumer. SMC-D (smcd_cdc_msg_to_host()) does not use this helper and is
>a separate, out-of-scope gap.
>
>Reproduced on a v6.19 KASAN kernel (SMC-Rv2 over soft-RoCE): a peer
>emitting prod.count=0x7fffffff triggers a vmalloc-out-of-bounds read in
>_copy_to_iter() via smc_rx_recvmsg(), returning ~960 KB of RMB-adjacent
>kernel heap to userspace; an in-range cursor transfers cleanly. With the
>fix the out-of-range cursor is dropped before it reaches
>conn->local_rx_ctrl.prod, and the reproducer returns rc=0 with no report.
>
>Fixes: 5f08318f617b ("smc: connection data control (CDC)")
>Cc: stable@vger.kernel.org
>Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
>Assisted-by: AuditCode-AI:2026.07
>---
> net/smc/smc_cdc.h | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
>index 696cc11f2303..f07bbef47073 100644
>--- a/net/smc/smc_cdc.h
>+++ b/net/smc/smc_cdc.h
>@@ -221,6 +221,7 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
> 
> static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
> 					  union smc_cdc_cursor *peer,
>+					  unsigned int size,
> 					  struct smc_connection *conn)
> {
> 	union smc_host_cursor temp, old;
>@@ -235,6 +236,14 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
> 	if ((old.wrap == temp.wrap) &&
> 	    (old.count > temp.count))
> 		return;
>+	/* count is an offset into the RMBE and must always stay inside
>+	 * it (see smc_curs_add()); the peer is untrusted, so reject an
>+	 * out-of-range wire cursor the same way an out-of-order one is
>+	 * already rejected above, instead of letting it drive
>+	 * bytes_to_rcv / the urgent-byte offset past the buffer end
>+	 */
>+	if (temp.count >= size)
>+		return;
> 	smc_curs_copy(local, &temp, conn);
> }
> 
>@@ -246,8 +255,10 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
> 	local->len = peer->len;
> 	local->seqno = ntohs(peer->seqno);
> 	local->token = ntohl(peer->token);
>-	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
>-	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
>+	smc_cdc_cursor_to_host(&local->prod, &peer->prod,
>+			       conn->rmb_desc->len, conn);
>+	smc_cdc_cursor_to_host(&local->cons, &peer->cons,
>+			       conn->peer_rmbe_size, conn);
> 	local->prod_flags = peer->prod_flags;
> 	local->conn_state_flags = peer->conn_state_flags;
> }
>-- 
>2.50.1 (Apple Git-155)
