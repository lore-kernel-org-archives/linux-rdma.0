Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBA74963CF
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785342788; cv=none; b=PbuXiLYSERIdrjUl+Qk01opG0pRidOzT39SRv2K/sQ5Bt7siXVNtDx2l0a6BVcTpV787UQRA5ehJZnL8VFlBGQxuepEuoXZNuu8C7DEBLDwxNs2O2i6m2/kkH8O0mAdvluNwai7evz8XN9Ey6PcrDHFaI90xT+nzqTGQcllgtXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785342788; c=relaxed/simple;
	bh=/4XUSjwFIMzU/ofJvehDBkb4qTc5c53Yt9jPhCQa1Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Klb4JEQMbChGuMMPluTa0vCxZRICrKHI36B6n5vdCCpZlo7joICyiG0uwJdTibr9y6z3RTsaXtVRfBCIx4XxtLTUayvrvkf7QAeN8AN9hw4OR8b8JqVn/jp3AMneMyy6kSS4F+FRL5g3KeRwJMcvFD1p397W8mcprsxpAzZ6SQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qgn5PVBQ; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qgn5PVBQ"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso1048220a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785342785; x=1785947585; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fArv74sVKQZ0CBDPXzKJ26kTPH49bXsdYCIt+szposY=;
        b=Qgn5PVBQ8pu96bgenzbkcQs1VTplQN7+cQWi6I0EwLy8YNPqig6KVtHIOrb131Ic9B
         P1fFR8BgQBd8DsgbWH/sE5qBo3srTeyDrpbA5u4aZkbcIjygSLrFM5wxW1NNkFgQhgvT
         myw79vus+8Ccc+neTEKYopYkA4HVrf+hiEBfxoaKAeHiET7YiQ64oQNDPC5rOKjPx6SR
         O6frWIcYJWbfFxQtWKyK2tIslhVEvbvuxRuosYkS1WzmHVzLm2wayrSx6R09i3BtDBjw
         /3jSInR8+HtvlJh++OVgB7Yl7K0QbUm1aHWXZu0f0utZaT+Qv0TjvszsuPeSzAMvSjqR
         Ib5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785342785; x=1785947585;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fArv74sVKQZ0CBDPXzKJ26kTPH49bXsdYCIt+szposY=;
        b=fyRLmaI1r00mc+JiCQJ8gi1X/xqb0UYJuTBaWexj4cmOk3W6tIFWeO5J81idiIAgCO
         Qh0djnMu63N6R3rR3ZMVm57w9I/ny6AYthUOllU3YZX2dDM3XMCn7Imnf8gWZUyuaA6e
         /S4ZePJmslqc1QaJ33fAFS1tUKeuYOBqPYa3fW/esBpze7XV9Gxxfxzn0BUz7gVnANHD
         3t64jEfdY3dJQ/7Gv5X1PNpzu74IBf1mOsjJedzT2xYTXsXHmxXk/lG/jXrwAQePyfqd
         9zozh1RRGDSvw2zpZhyN+KAqccuPA3eTMdYNCTYZkTzmdBUqz21B8kySjrQ0J5TTxIPb
         L6MQ==
X-Forwarded-Encrypted: i=1; AHgh+RrfSvYnuPXMP2zXzuyL6FBikZ03PG2PDzeJJrBOQyHTEhzRvWCI3zp1RnBE3HDD7hPawGM7e1HnXp3b@vger.kernel.org
X-Gm-Message-State: AOJu0YxgZs8IC4Laks6lrIpl2bU8hORHLUWN613aKR+sJhXUM1xwdqYE
	Mh+M3L6zblLuVgzpS+3xfnj1YA33c3QIINnwG9OH6q+LZuNdVdeb/Ds4
X-Gm-Gg: AR+sD136mEezb9XmMGq0HtyhZ3pla8Z2Bisa0LcI/mdgAogU0BwPRepkQbXgtNCIuZe
	Jlj0rCNPhvjA7CQe3h2IT9h3zijWj7aYK1Vi7F+YpaBDM6hTNTlIGqIEvZCVJJrUmdJfbWvSboL
	Aii7TAk/7kKLevcYR3Mn+4JnzTGUamdZOp2FfR1DFUExt0f+zR/mejqzJ64+jNULQYexrU5PCT/
	pvigmYIq/qnLwAud7Gnq0Jy5oIpI3DGDuPqJ06s8IGX7JL9SQORHcYUVqzV/qUtsTZwkSpffuKm
	PCQ5mmvasAMkIrEV9DBh5vX3J81Gv91I4PCIxnohN+UI90stQfdIfhC1aD0Jts1xDjUqwf9L8JC
	yFbpJNJ23jc+5ONew+1OIqbz8JcQomx/Hdkem3lUDGCEWQpE3wc+wbJlGwK1saefH+NwY6eIY6M
	2nTjfypUklN4OFAgh1Fm/MsvNlvOnsgWg4umwLyLiMM5y2o0Ic3RJ3ab0OklKyVGny06zAQ/lUO
	5PmenVgww==
X-Received: by 2002:a17:90b:4ad0:b0:38e:11ba:992e with SMTP id 98e67ed59e1d1-38f6a544ac8mr6261749a91.35.1785342785061;
        Wed, 29 Jul 2026 09:33:05 -0700 (PDT)
Received: from devvm29614.prn0.facebook.com ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f12bcbcsm1672033a91.6.2026.07.29.09.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 09:33:04 -0700 (PDT)
Date: Wed, 29 Jul 2026 09:33:02 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net] net/mlx5e: fix BQL reset on SQ re-activation
Message-ID: <amorPql8QJRbCNJW@devvm29614.prn0.facebook.com>
References: <20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com>
 <756e9c86-38f3-4a94-833f-afb0559397a3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756e9c86-38f3-4a94-833f-afb0559397a3@nvidia.com>

On Wed, Jul 29, 2026 at 03:32:56PM +0300, Tariq Toukan wrote:
> 
> 
> On 29/07/2026 0:47, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > mlx5e_queue_start() deactivates and re-activates all channels but closes
> > only the queue being restarted. mlx5e_activate_txqsq() then
> > unconditionally calls netdev_tx_reset_queue(), zeroing the BQL counters
> > of channels that kept their in-flight TX WQEs. The next completion then
> > over-charges and trips the BUG_ON() in dql_completed():
> > 
> >    kernel BUG at lib/dynamic_queue_limits.c:99!
> >    RIP: 0010:dql_completed+0x23d/0x280
> >    Call Trace:
> >     <IRQ>
> >     mlx5e_poll_tx_cq+0x668/0xa60
> >     mlx5e_napi_poll+0x5b/0x7b0
> >     net_rx_action+0x15a/0x580
> > 
> > Reset BQL only when the SQ has no bytes in flight (sq->cc == sq->pc).
> > 
> > In the case that reset is skipped, the outstanding WQEs will eventually
> > complete and rebalance the dql. The dql->limit is carried across the
> > reset.
> > 
> > Fixes: b2588ea40ec9 ("net/mlx5e: Implement queue mgmt ops and single channel swap")
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
> >   drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 3 ++-
> >   2 files changed, 5 insertions(+), 2 deletions(-)
> > 
> 
> Thanks for your patch.
> 
> Overall the fix LGTM, just one comment below.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 4a8351f95b27..44834890a409 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -1940,7 +1940,9 @@ void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
> >   {
> >   	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
> >   	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> > -	netdev_tx_reset_queue(sq->txq);
> > +	/* Reset BQL only when the SQ has no bytes in flight. */
> > +	if (sq->cc == sq->pc)
> > +		netdev_tx_reset_queue(sq->txq);
> >   	netif_tx_start_queue(sq->txq);
> >   	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
> >   }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > index 0b5e600e4a6a..d0ad1b8d6988 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > @@ -909,7 +909,8 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
> >   	sq->cc = sqcc;
> >   	/* Do not update BQL for TXQs that got replaced by new active ones, as
> > -	 * netdev_tx_reset_queue() is called for them in mlx5e_activate_txqsq().
> > +	 * netdev_tx_reset_queue() is called for them in mlx5e_activate_txqsq()
> > +	 * if the queue has zero in-flight WQEs.
> >   	 */
> 
> Please drop this hunk. In this path the replacement SQ is always freshly
> created, so cc == pc == 0 and the reset always happens - the qualifier
> invites the reader to worry about a case that cannot occur here. The
> original wording is accurate as-is.

Ah makes sense, thanks. Will re-send with the change!

Best,
Bobby

> 
> >   	if (sq == sq->priv->txq2sq[sq->txq_ix])
> >   		netdev_tx_completed_queue(sq->txq, npkts, nbytes);
> > 
> > ---
> > base-commit: b515dc54795ef370be3cb396e7c12ad91686b6d1
> > change-id: 20260728-mlx5-bql-84e02a5a46c8
> > 
> > Best regards,
> 
