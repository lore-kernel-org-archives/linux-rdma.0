Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290782DF12F;
	Wed, 14 Oct 2026 21:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014088; cv=none; b=FAaVJVRb1dCgUFfjU2QJZlQbXiI8rpVgWU/UI1LbGZ2jiHDWheWbr9QmmJlsI8LUhK9wLy3DD7ktOQr/I5o/6wi+tPp94N1frR/6TYvDbL7fBV9dL1+Ud7Ze4Ip3t5aTfhPqrpFkevuPH+WuHYAjS6bnV07vtSZ63PB3ty0BTwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014088; c=relaxed/simple;
	bh=mAVTMRFo1vjrXJKjZ4GB8UYm7iHtkcIECw9ZALxMtYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knYB2Sl0WGoGmCPH03Sg+QsGNtvqW1CtDDSggRd7/61rDwmM3YrExqmh0+bGO0xzhrTh9KQb2/Ahey/5LjWZCRfJAf1uVjMuEEVCXSSbONZHCaQ/7xriQZczZ7PvOYYCrW/NBI4Bc/b1u0Zig5anNAG10jHpt6RWS/2k6hyjb0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ywNCF0IY; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vTwg8sks; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ywNCF0IY";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vTwg8sks"
Date: Wed, 14 Oct 2026 23:41:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792014084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/L5wlkW/gq8uEhSDV4sxmEeSjlj/PBLvbAGF8LDYLuA=;
	b=ywNCF0IYgyQ39uQPzFS1uhsGic1yRHVjC8B1AyBiQ5GHkhj2HXU3HiriIgzMI4OBkDQZOZ
	idGMoNQyah77v3c5P94aBqqUydimVZ5Qa/1LzbqF4+naX8xQYsxV2rfKR6mVzgWxGgWsy7
	z2NMqPXUe70/C02ZhZLzafnTrJVCMBIPGkq4+TCPO7p6QqGDtiZcxr9Mvqfkhk4qBwfXkG
	w/B81ZGYS32RSWBgbusNDEfxmFkI6x2pesfay9VgWcq3jE5JG7pHTRuzHIP77tatSTnCXY
	G/19s8cwSfR2UFNEzyC8Is/WL4hNzhUcGmg1hC27Wq8hIy9zZH+s0XYv3nMW7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792014084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/L5wlkW/gq8uEhSDV4sxmEeSjlj/PBLvbAGF8LDYLuA=;
	b=vTwg8sksfd3IhYlWRxocW3c0EG5blQNywespIOQcCPYHeD1aZrF9cJftxLPwqJXKnYNcia
	2k0tMBV7ccoV0eCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Hidayath Khan <hidayath@linux.ibm.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com,
	andrew+netdev@lunn.ch, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	pasic@linux.ibm.com, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v3] net/smc: fix abort_work termination in
 smc_conn_free()
Message-ID: <20261014214123.qNDtgrhJ@linutronix.de>
References: <20261006073550.1595003-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261006073550.1595003-1-hidayath@linux.ibm.com>

On 2026-10-06 09:35:50 [+0200], Hidayath Khan wrote:
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1251,9 +1251,13 @@ static void smc_buf_unuse(struct smc_connection *conn,
>  	}
>  }
>  
> -/* remove a finished connection from its link group */
> +/* remove a finished connection from its link group.
> + * Must be called with the socket lock held: conn->freed is what disarms
> + * a pending or running abort_work, and both are set and tested under it.
> + */

If so, sock_owned_by_me(conn->sk) would verify it at runtime, right?

>  void smc_conn_free(struct smc_connection *conn)
>  {
> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>  	struct smc_link_group *lgr = conn->lgr;
>  
>  	if (!lgr || conn->freed)

This change looks reasonable. sashiko complains that smc_conn_create()
will reset conn->freed. Does this make sense to you?
I *think* the connection is cleaned up and it shouldn't happen but then
I just started looking at this a while ago.

Sebastian
