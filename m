Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295858;
	b=27WkOz3q4G7YAbuhXk/+4e8Tyf6LuCxdthCs82QfJaJUflS3B5MbsQA+VQQAxhp8/ngT
	 pzomrxxi8iJq4azfqH1CwPLEQvsT2KYIr7bh+k6m04lPwmHLLem7C7wrPsL8z5Z2dIC1x
	 hxj4KpRmCbCO11ICO1komN1SEnYz2xGM/bFH9Only6JgZl679Exc4KZWiE5JZ/HPzks1i
	 Ck+yu5g7knTJWKjDn00RsUQRlaek+gQftm98dk+Q/KSzGzhALrBY9kyBaJAAFHgo9YtxC
	 tNN+Tb7XeicsDbB1LBiSduyeQMFHL1/2fuhvRPh3nfHtfGZivMAUDqfdR5hHoKXGMhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295858;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ygaWC6fgtJ0AI6XqKUC+g0lmWjmeS9cByt38tmYUkoo=;
	b=OneohYNGlT3x9aeezKfPSuls3agC2Aaoiu57VLL8dwIQW6zFUXD9CrZ829pKKcnOePLh
	 nXYVrRYQ89gBvNEGpwJjlO4GDAG7z2i0LJIpqatNXupB79RP0hS3hnsTQA2JkpTjFPXfF
	 cqYhvp+s+rUrWAtdmtYYKq9fm2HlCi9SA6ShrrU6uXr57qckc28p5jjAVD/4d6cLR0tKG
	 JgaATAskirqHleJUhmi55RQ+4lab3W144j8L63CB5pTLemOHNQUu2AoWb9C0mjXsn3sPb
	 oBf8e6QiT+Wa0+aae6YcZ8xEy00nOd6tiLjYClrcO8jwUzg4K1Dj3WfPE9uUwq9WITA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YxLAt8xf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84234606A320;
	Sat, 21 Nov 2026 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YxLAt8xf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BA01F000C4;
	Sat, 21 Nov 2026 21:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295858;
	bh=ygaWC6fgtJ0AI6XqKUC+g0lmWjmeS9cByt38tmYUkoo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YxLAt8xfR5Vy1T3842E1byod408YGAEvPTYO8bGB8k/Dk5SqMeKT9O+9sDAc7OVXn
	 wm//mgLp6rGzxqRexTXiy/jwAthqJQkLwhCldUUvlpzMimgP0bmLSi7ZUpuCq06RaY
	 CDbrQSQKcNq1Sa69s/0Qeh3oHoJq5VSMLhupZa/cfTVfZuJkoy3eHOm8TkdV4+w6W+
	 /ttByNLZ/Hi7TRXXNYZD82Cw5c5irkrx9/p0NVo48TuwQZggqsuRIo4MNjPWj3CTJu
	 9nOpA4DCbIOIJ9V1OsdxlndQGUdErg5EYeDjwJZ09u8bfDmT10CRK3mrjHtDONU17z
	 mr9M9EOBV6T3w==
Subject: Re: [PATCH net v6 1/8] net/mlx5e: ring the tx doorbell when an accel
 offload drops a packet
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, borisp@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dsahern@kernel.org, dtatulea@nvidia.com,
 edumazet@kernel.org, idosch@nvidia.com, kuba@kernel.org,
 john.fastabend@gmail.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, pabeni@redhat.com, raeds@nvidia.com,
 rrameshbabu@nvidia.com, sd@queasysnail.net, saeedm@nvidia.com,
 shuah@kernel.org, horms@kernel.org, tariqt@nvidia.com, weiwan@google.com,
 willemdebruijn.kernel@gmail.com, stable@vger.kernel.org
Date: Sat, 21 Nov 2026 21:17:36 +0000
Message-ID: <179529585606.3135.5694313033561024003@kernel.org>
In-Reply-To: <20261117203137.804424-2-toddfreed@meta.com>
References: <20261117203137.804424-2-toddfreed@meta.com>
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

- [Low] The new mlx5e_tx_check_stop() call in mlx5e_tx_flush()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:368) can count one…

--

net/mlx5e: ring the tx doorbell when an accel offload drops a packet

When mlx5e_accel_tx_begin() drops an skb, this patch makes mlx5e_xmit()
call mlx5e_tx_flush(). That closes any open mpwqe session, posts a nop
and rings the doorbell that earlier xmit_more skbs had deferred. It also
adds a stop_room check to mlx5e_tx_flush() after the nop is posted.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 14479da98f427..006bf976def1a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -365,6 +365,7 @@ static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
>  	};
>  
>  	wqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
> +	mlx5e_tx_check_stop(sq);

[Severity: Low]
Can this count a single queue stop twice in sq->stats->stopped?

mlx5e_tx_flush() starts with mlx5e_tx_mpwqe_ensure_complete(). If an
MPWQE session is open, that goes into
mlx5e_tx_mpwqe_session_complete(), which already runs a stop check:

mlx5e_tx_mpwqe_session_complete() {
    ...
	sq->pc += wi->num_wqebbs;

	session->wqe = NULL;

	mlx5e_tx_check_stop(sq);
    ...
}

If closing the session leaves less than sq->stop_room free, the queue
is stopped and stopped is incremented. The nop then advances sq->pc by
one more, so free room has only gone down, and the new check also
fails. mlx5e_tx_check_stop() does not test whether the queue is
already stopped:

mlx5e_tx_check_stop() {
	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room))) {
		netif_tx_stop_queue(sq->txq);
		sq->stats->stopped++;
	}
}

When the nop completes, mlx5e_txqsq_wake() wakes the queue once and
increments wake once. That leaves stopped one higher than wake. These
counters are reported as the qstats tx stop/wake values and as
tx_queue_stopped/tx_queue_wake in ethtool.

This can be reached from the new accel drop path below. It can also
now be reached from the existing DMA error paths in
mlx5e_sq_xmit_mpwqe() and mlx5e_sq_xmit_wqe(), since they call the same
helper.

The PTP path in mlx5e_txwqe_complete() already avoids this:

	if (!netif_tx_queue_stopped(sq->txq) &&
	    mlx5e_ptpsq_metadata_freelist_empty(sq->ptpsq)) {
		netif_tx_stop_queue(sq->txq);
		sq->stats->stopped++;
	}

Would a similar netif_tx_queue_stopped() guard work here?

Only the statistics are affected. The queue still wakes when the nop
completes, and no packets are lost. The normal mlx5e_xmit() path can
already skew these counters the same way, through
mlx5e_tx_mpwqe_ensure_complete() followed by mlx5e_txwqe_complete().
Later patches in the series do not touch en_tx.c, so this is still
present at the end of the series.

>  	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
>  }
>  
> @@ -672,8 +673,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>  	}
>  
>  	/* May send SKBs and WQEs. */
> -	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
> +	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel))) {
> +		/* The skb was dropped: ring the doorbell which the previous
> +		 * ones may have deferred to it
> +		 */
> +		mlx5e_tx_flush(sq);
>  		return NETDEV_TX_OK;
> +	}

This is the new caller that reaches the double count above. It needs a
PSP, IPsec, MACsec or kTLS drop while an MPWQE session is open and the
SQ is close to full. The commit message says the next patch makes the
PSP drop reachable from user space.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117203137.804424-1-toddfreed%40meta.com
