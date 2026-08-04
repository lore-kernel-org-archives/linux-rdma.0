Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53D480949
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863708; cv=none; b=ReI/yM1fKDmdqQnmink943KcmJ9j0ZhMk0+nYOWcOuIYYmEQibi2kTKhaiSvN2j7kqhU+mn2Bzr+bj4SzCGoTszoc2HVKMawKjkt0gA+qmQ3zDDbvFLRt/gWsU8KPOvXRTUvpHI6+OwPAAthlAJ02x1WIGHK9wI5FlZYL+rFIuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863708; c=relaxed/simple;
	bh=CDg7R4z19rm3HhNKcpDry/8FXJmNNTW/k1bNkbouDnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=op6VhvRS/Z5gskLW48jb14vZHuHEKSg8JchyDqfefc7RSQ4RMFvpfGJq9tG3zpWANe1E1fyLoildZPtr5heY1BMemKU3tM2gHRvKYqQoaV8cr3wKHlt8SSQx2ay4h/cYF321orp0qwRAJeR1+DVaY93Q3jyO21nU1dBgugp8gm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tmc0909F; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tmc0909F"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso208842b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 04 Aug 2026 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785863693; x=1786468493; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+FyhIVgwr2eNJZrKd4apq3PGwedIYUrqhXnEIT+9gD0=;
        b=Tmc0909Fbx4wvfuc8YQaau8WA430Z0l5R23o64tJN0MXXVaNqEr/lEgTnvwwM0p/YN
         5PhTICdctolgRCT+oid4JmxUEtJiS1c5Zu+m7haLWGeXWc/ryZXOzDkfj2vfcG1tDUtI
         1tSB0Sx+hLPHTC63EkJ/O6/DdN+aRno8s2kSCfzPWrlgmX1Ozpk7tW4sH2CX6huUhwn3
         P8X01kMYx06vJzxJt0qEvvd8n817HdLOgQXbYdCIYaOmH/k7uzEMbYeIcU2mdbFL3uUX
         Zzftbi0Q8Ak4mw/G4IiaT1hXx4BhFEJ8Wy3tAKkIt6Zs3fK+YhzQc4YYdQ79QjuS7Jc3
         awyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785863693; x=1786468493;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+FyhIVgwr2eNJZrKd4apq3PGwedIYUrqhXnEIT+9gD0=;
        b=Ao7VTFmdePTFlB306CPZTNwExap2AzdyCjM3SPqn+I2mgqjYcEAYIa54kYmcMAX/Gv
         KqTAFF9PG9piRFCGOg6LOohRSj0suRFKyCaz0g2IKNNxGoNXOeBhm1iLOO5OUW5yt+gN
         aziRWrgTjxZiBp4KJlMIRx12vP1RyHRB736LdU1Y4Jw+y3m/0ETdUIpDpGp51dJzEJQb
         A0fC4EF6dn9vMlWXPdzIqjbjtRwbr//OTcmTR+J7+Cm2yJcSXK+Q3F9qRqgrkyZnZqtj
         3aQPWib9e66+zKd1Cn61ya6bJ6qbH/qAvs0bv4FYWcg2F4KgyWxGAb+iOCIzYc+DBBXF
         ndMQ==
X-Forwarded-Encrypted: i=1; AHgh+RreIsc1V6jLQainqJlfcvjlMKnlnWgFr4OR8Y25Klido3ZzKx1YRuU5JnUk27n3q43DON90KR9iLvLj@vger.kernel.org
X-Gm-Message-State: AOJu0YxHZ9WxW3Teb1t+nVM60CXgIaQ/Og8ewuwIGrufkHSJoZG8yr2w
	vcRRrOJguVW5S8tB6+iOse/xlOCN7Slj+6PdrTicgAIiB+auL8hVwIPs
X-Gm-Gg: AR+sD12NgHewOnc/9lEIjXTFoul3T5zUPC13ot3C78ZgZLRYQR4EqelSitfRw1SBVUn
	AXGZnpLVHojeBtzC36BzPmjDIiyd0lB9ale5BAVl5N+36Ty8PdkB8xbH4jMfa+U/8NEZlp018tH
	hVFINe2dY9S1xNcsK5z3r5zXAf7QVtBkCIRJwZSS/O3pkWy3WCKm5Iso8IUC5PQhKhwmoDULNHV
	2THJ7Lsz/aiddqtl+zn/mKK1xq70kXSAVNmAhn9sYN5fFUM3syFPyTpLdhkYZZQ7K2TrM/cUhUY
	FNa6/im6AEGwuEnU8/nudcsCCS0M6KvDmyfoLTo2dgJyKQz3HCU7G9lRsAqCEwe1H3oSGTmAupe
	eu5nrvFG125qT4dVyfx+KoznlEVcvCbtzw9SQLxtrf+vP7GYu0qvOXKTnmsoB6JQvjDO8yq7RyC
	z0+NCBBssLD6MVISBvff6acZX0NFlS0GbZPsdqp67AAkyK7AJibGMcJoQ7jwxg1jMoSlrZI42eE
	5qHQdztIA==
X-Received: by 2002:a05:6a00:12c9:b0:848:50ef:4157 with SMTP id d2e1a72fcca58-84f1cb966c9mr4481009b3a.27.1785863692576;
        Tue, 04 Aug 2026 10:14:52 -0700 (PDT)
Received: from devvm29614.prn0.facebook.com ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe707c9970sm77984a12.6.2026.08.04.10.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 10:14:51 -0700 (PDT)
Date: Tue, 4 Aug 2026 10:14:49 -0700
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
Subject: Re: [PATCH net v3] net/mlx5e: fix BQL reset on SQ re-activation
Message-ID: <anIeCTh6IUJaP2mz@devvm29614.prn0.facebook.com>
References: <20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com>
 <6ac643bf-c6f4-4ff2-ba57-964a645d9323@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ac643bf-c6f4-4ff2-ba57-964a645d9323@nvidia.com>

On Tue, Aug 04, 2026 at 11:23:53AM +0300, Tariq Toukan wrote:
> 
> 
> On 04/08/2026 2:47, Bobby Eshleman wrote:
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
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Thanks.

Thanks Tariq, and my apologies for forgetting to carry the R-b forward.

> 
> > ---
> > Changes in v3:
> > - Sample sq->cc/sq->pc before setting MLX5E_SQ_STATE_ENABLED, so a
> >    concurrent mlx5e_poll_tx_cq() cannot un-charge BQL between the check
> >    and netdev_tx_reset_queue() (Sashiko:
> >    https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260729-mlx5-bql-v2-1-cdf285e586df@meta.com)
> > - Link to v2: https://lore.kernel.org/r/20260729-mlx5-bql-v2-1-cdf285e586df@meta.com
> > 
> > Changes in v2:
> > - remove misleading comment (Tariq)
> > - Link to v1: https://lore.kernel.org/r/20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 7d47a1da8b6b..f0407a850ea8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -1939,8 +1939,10 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
> >   void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
> >   {
> >   	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
> > +	/* Reset BQL only when the SQ has no bytes in flight. */
> > +	if (sq->cc == sq->pc)
> > +		netdev_tx_reset_queue(sq->txq);
> >   	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> > -	netdev_tx_reset_queue(sq->txq);
> >   	netif_tx_start_queue(sq->txq);
> >   	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
> >   }
> > 
> > ---
> > base-commit: d1000fd7995e51deec872d154e0a40d82f7a539f
> > change-id: 20260728-mlx5-bql-84e02a5a46c8
> > 
> > Best regards,
> 
