Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529663;
	b=gqyKr0a4TnLUghVJp39MtLvdmJWHhXfIarjjcgZIPqg5yl9zTxuAceNhS/TmVn0FYuLv
	 JIGtAXJDFAPNpFqsZr5qncHz89UdhRnvj/uWXPLaG6ku8HK3rU+RVFDJp/I5sFt1I8zvk
	 tKTyJEPdMtJIj5w+Y4MK5P3sl4m6QVGf6Hm67aEMWTCR2Jzi4e5j147fVaQ4LqLdYtzPD
	 noOXqB8AxfsmsgiFZ8Ac7aMUtVMy4gaRNabY1W/44EiLmT8MZHOwoFHaibZTnsKlN+I7r
	 QrCPQgJj72vnFkzUxJfo6A9RtUp7zwOpE7P/TaJa2+y5Hx9L911UpBHtL1BY2/Mo3Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529663;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=QJkEoPSyNyr4Whek43Q0LFVoTI67yife7jFNatawwd8=;
	b=azP3qvDhliidKM5rN6CNeDwtg1TxUrWoo2+9kk0Ji6W21rpuNXbxBbpo8GdvxQRvix5N
	 i05GAeK9BDsvR1vMwGdP179IhzZn2BKTGbIJI3+rWgy6IKlcSfhCSq333ofqNrPg11LDy
	 jOPLuHZ46H2d0QtSYijuC1+nBH9NhBLDTk4Bgyb3rB63p5pNtlxZGKhnEYC2+rxk1D5zD
	 cfnbBPZIZil2GMBb0/B5Zd7nu9mD0WGuMwQ0G7LfgjwR5xlHlfJjcI5e42wqKmIzp3CGK
	 Yn6rB9tuO4uZVbZB0z5CI5kgc097X+B0IwLys57te9e9rIbEaU7wQjsNOk6QjSsebvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mfb6ZTHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06658606A337;
	Tue, 24 Nov 2026 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mfb6ZTHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A301F000EC;
	Tue, 24 Nov 2026 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529662;
	bh=QJkEoPSyNyr4Whek43Q0LFVoTI67yife7jFNatawwd8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mfb6ZTHwo06Ake6CsvbWC38ZlieUQ9g+uf+9HOs6pDgLJG+KxxLS3jGkQ4qwB38Oi
	 zLhiIAcokxXGxGQUAigpXKT9gQQ1MB1JQG7xMTgnDRnG8oKfUK4YiJqoDR9VPXFmQc
	 +zSd7+DFi1qympJdT1hX1iu47KwRec6gC45dAgDQ6bg58fqQUvmpT2KTPwibmeRQR9
	 dFPJqTvDqr5I4BY/Qe/6Yr15cg1MbyKXa0dhQRuBXYBA7KiRlMdYxWTKVXg9DPMVID
	 W6tX1ntGdDw2iznTuuKN+ZYTo3kS3JslSfCQyZHvHryXu3Cjbe/iaawrlY7L2qvY/4
	 OlVxiAdbQ9+cw==
Subject: Re: [PATCH net v2 2/2] net/smc: bound the DMB-nocopy send-buffer
 credit as well
From: netdev-bot+sashiko@kernel.org
To: piyus@iiitd.ac.in
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kapil@presceralabs.ai, stable@vger.kernel.org, kuba@kernel.org
Date: Tue, 24 Nov 2026 14:14:21 +0000
Message-ID: <179552966151.3135.8162716126718648323@kernel.org>
In-Reply-To: <20261123135327.3953509-2-piyus@iiitd.ac.in>
References: <20261123135327.3953509-2-piyus@iiitd.ac.in>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] In net/smc/smc_cdc.c:smc_cdc_msg_recv_action(), the new DMB-
  nocopy clamp uses `sent = conn->sndbuf_desc->len -…

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but in
  net/smc/smc_cdc.c:smc_cdc_msg_recv_action() peer_rmbe_space is still…

--

net/smc: bound the DMB-nocopy send-buffer credit as well

On the SMC-D DMB-nocopy path, smc_cdc_msg_recv_action() credits
sndbuf_space from the peer's consumer cursor. This patch limits that
credit to the number of bytes this side has outstanding. It also moves
tx_curs_fin forward by the limited amount instead of copying the
peer-reported cursor into it. The commit message calls this hardening,
because only dibs_loopback provides support_mmapped_rdmb() today.

Link: https://lore.kernel.org/all/20261122053223.2497832-2-piyus@iiitd.ac.in/

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..9ffa3e422aa1f 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c

[ ... ]

> @@ -361,13 +362,26 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);
> +			/* This difference comes from the cursor the peer
> +			 * reported, which is taken as it arrives.  A peer
> +			 * cannot have consumed more than this side has
> +			 * outstanding, so bound it by that and advance
> +			 * tx_curs_fin by the bounded amount rather than
> +			 * assigning the reported cursor: the invariant below
> +			 * then holds by construction, and tx_curs_fin stays
> +			 * inside the send buffer.
> +			 */
> +			sent = conn->sndbuf_desc->len -
> +			       atomic_read(&conn->sndbuf_space);
> +			diff_tx = min_t(int, diff_tx, max_t(int, sent, 0));
> +
>  			/* increase local sndbuf space and fin_curs */
>  			smp_mb__before_atomic();
>  			atomic_add(diff_tx, &conn->sndbuf_space);
>  			/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
>  			smp_mb__after_atomic();
> -			smc_curs_copy(&conn->tx_curs_fin,
> -				      &conn->local_rx_ctrl.cons, conn);
> +			smc_curs_add(conn->sndbuf_desc->len,
> +				     &conn->tx_curs_fin, diff_tx);

[Severity: Low]
Is len - sndbuf_space the right bound here?

smc_tx_sendmsg() lowers sndbuf_space when data is prepared, not when it
is sent:

net/smc/smc_tx.c:smc_tx_sendmsg() {
    ...
		atomic_sub(copylen, &conn->sndbuf_space);
    ...
}

On the nocopy path, smcd_cdc_msg_send() returns before it credits
sndbuf_space, so this function is the only place that adds to it. That
makes len - sndbuf_space the distance from tx_curs_fin to tx_curs_prep.
This distance includes bytes that are prepared but not yet sent.
smc_ioctl() uses the same expression for SIOCOUTQ and describes it as
"not send + not acked".

The peer can only consume up to the producer cursor it was given.
smc_tx_rdma_writes() advances that cursor together with tx_curs_sent. A
consumer cursor that claims more than tx_curs_sent is therefore clamped
only to prep - fin. The smc_curs_add() above can then move tx_curs_fin
past tx_curs_sent.

Would that break the fin <= sent <= prep ordering implied by the
tx_curs_sent ("sent data") and tx_curs_fin ("confirmed by peer") field
comments in smc.h?

If so, a later smc_tx_sendmsg() could wrap from tx_curs_prep into
[tx_curs_sent, tx_curs_prep). It would then overwrite queued data before
that data is advertised. On the nocopy path this buffer is the peer's
DMB. Today this needs a forged consumer cursor, since only loopback-ism
reaches this branch.

The memory-safety goals do look met: sndbuf_space stays <= len, and
tx_curs_fin.count stays below len. However, the new comment ("A peer
cannot have consumed more than this side has outstanding"), the variable
name sent, and the commit message ("credits nothing beyond the
outstanding bytes") seem to describe a tighter bound than the code
computes.

smc_switch_cursor() in smc_core.c uses the same formula. It advances
tx_curs_sent together with tx_curs_fin, so the ordering holds there.
Here only tx_curs_fin moves.

Would a bound like this match the comment, and leave the honest-peer
case unchanged?

	sent = smc_curs_diff(conn->sndbuf_desc->len, &conn->tx_curs_fin,
			     &conn->tx_curs_sent);

>  
>  			smc_tx_sndbuf_nonfull(smc);
>  		}

[Severity: Low]
This is a pre-existing issue, not one introduced by this patch. Earlier in
smc_cdc_msg_recv_action(), peer_rmbe_space is still credited from the
same peer-reported consumer cursor with no bound:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
	diff_cons = smc_curs_diff(conn->peer_rmbe_size, &cons_old,
				  &conn->local_rx_ctrl.cons);
	if (diff_cons) {
		...
		atomic_add(diff_cons, &conn->peer_rmbe_space);
		/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */
    ...
}

With a forged cursor, can peer_rmbe_space exceed peer_rmbe_size here?
That would make the comment false. This path runs for all SMC-R and SMC-D
connections, not only nocopy ones.

After this patch, the nocopy path bounds sndbuf_space and tx_curs_fin,
but peer_rmbe_space still takes the full diff_cons. The two counters
describe the same shared buffer, so they can now disagree. The comment
above the nocopy branch says both are updated "since peer has already
consumed the data".

smc_tx_rdma_writes() uses peer_rmbe_space to compute write_blocked and
the transmit length. The urg_tx_pend wake-up at the end of this function
also requires:

	atomic_read(&conn->peer_rmbe_space) == conn->peer_rmbe_size

Would an inflated peer_rmbe_space mean the urgent data sender is never
woken through that path?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135327.3953509-1-piyus%40iiitd.ac.in
