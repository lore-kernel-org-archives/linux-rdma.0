Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4501E5B63;
	Thu, 29 Jan 2026 04:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769662584; cv=none; b=K0LawL+Y+tZ7Rv9m67HPiaRCxdGWMssvttiNsf2tuur87gZjgvxq8MJnqSGhG4H+0z4g5A7KDZHbZOUAi52Yht+x6GEWb+RIZkx9ervbBgiH/bMYz9WMF2HCEsBAW/qrnVqY5oBJTWF3boUVsZO6FXyS9+PNk60tLZ5LdZ3IEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769662584; c=relaxed/simple;
	bh=SerLTwZ+LhtfYFpLrN67YUZOpCe9AL6eTZImxwCM5fY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W9SWxXa9lriitNbodwjyp5/VdMf5qcgpWiYJADrfyQEUpjU87iJOmpZpA57P/Lw4XWHPjwB1tQR9a4JWZpRLc3w7YfaABwROhfXVfSQgpegePf7MUMyr7D4FbQCfBqm3sa7OQdHgj8T6i9h863koN0NtDqhzu5AX41awFVPFaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u/h0mCUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u/h0mCUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCC2C116D0;
	Thu, 29 Jan 2026 04:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769662584;
	bh=SerLTwZ+LhtfYFpLrN67YUZOpCe9AL6eTZImxwCM5fY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u/h0mCUYf5UNkFsPGfhAJASK05ubr/x2Z1x3ftnqPYzceK+ggT5+UdFO9pnSbkqDX
	 n9p75RmqzabBbe3CaR9gd8Bclie4GGivTReRhVR6MSqncCbbkOXYeuzc3pe06LmE3k
	 n4shhrBDviGSyZ2s6P1ZnrjrgnSA3U26wR0Cw3b49aMpk19y+UsPxFWks894K6g/dD
	 xETb0H7guYi7zaMbSzRQ39naR9RcOlCvJcbhbi0fp56KrU2h4fJ6e9w/lfWc9VrDhy
	 ikmqkHM0pfffpF44T2hUYI4F5oUx49/QmKhljAeURi24AQXawBjkEFJe8cdJPXW7J1
	 CcxKP12/VXnAw==
Date: Wed, 28 Jan 2026 20:56:22 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Moshe
 Shemesh <moshe@nvidia.com>, Simon Horman <horms@kernel.org>, Cosmin Ratiu
 <cratiu@nvidia.com>
Subject: Re: [PATCH net V2 2/4] net/mlx5: Fix deadlock between devlink lock
 and esw->wq
Message-ID: <20260128205622.12e1f026@kernel.org>
In-Reply-To: <1769503961-124173-3-git-send-email-tariqt@nvidia.com>
References: <1769503961-124173-1-git-send-email-tariqt@nvidia.com>
	<1769503961-124173-3-git-send-email-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Jan 2026 10:52:39 +0200 Tariq Toukan wrote:
> esw_functions_changed_event_handler -> esw_vfs_changed_event_handler is
> called from the esw->work_queue and acquires the devlink lock.
> 
> Changing the esw mode is done via .eswitch_mode_set (acquires devlink
> lock in the devlink_nl_pre_doit call) -> mlx5_devlink_eswitch_mode_set
> -> mlx5_eswitch_disable_locked -> mlx5_eswitch_event_handler_unregister
> -> flush_workqueue.  

This is quite an ugly hack, is there no way to avoid the flush and let 
the work discover that what it was supposed to do is no longer needed?

>  	devlink = priv_to_devlink(esw->dev);
> -	devl_lock(devlink);
> +	/* Repeatedly try to grab the lock with a delay while this work is
> +	 * still relevant.
> +	 * This allows a concurrent mlx5_eswitch_event_handler_unregister
> +	 * (holding the devlink lock) to flush the wq without deadlocking.
> +	 */
> +	while (!devl_trylock(devlink)) {
> +		if (!esw->esw_funcs.notifier_enabled)

Technically READ_ONCE/WRITE_ONCE is required on this.

> +			return;
> +		schedule_timeout_interruptible(msecs_to_jiffies(10));

Why _interruptible(), you're not handling the return value.
If somehow this thread gets a signal pending we'll turn this
loop into a busy poll which doesn't seem ideal?


Ima take this patch out of the series and apply the rest.
