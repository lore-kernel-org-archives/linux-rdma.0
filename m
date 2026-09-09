Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD6569F10;
	Wed,  9 Sep 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968271; cv=none; b=H+THmNKIlqzN5msbUt9Web1yQgd3qxb9RLMgL7MHfXI6dilGh9X9pIUUwQj11/KE2TyX94+/CG50jflARg+LGvQ3zZ6lr8w7hyZgS5K0CUgnAP5/jPMKnDo9/uZNHW4ImwM0WoGis+r6TuTH5eYsl75M8xsQoeGs4erH82thtMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968271; c=relaxed/simple;
	bh=9BEitvZ9S9Y0Jqf9gWQGZLS/JDGsG2PQpqJ8serW7uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSl3pvkwwty+WMIvxWmgkrNDF/uCjFIWc9zHafAl0Mwojs85z8vJLnmYR0FCd0b8vtPNYaYafRGZkw/riiW50jPArhCpFUN6cWtwhX1MzcF7ijuCR7VVZDmdIm8TyZkUAJuf8N8C2PiiMXu3CMB1q55O3PY7wNWniRdY0caqkXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjBXBQtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjBXBQtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A60B1F00A3A;
	Wed,  9 Sep 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788968269;
	bh=TF20FA59yQP1qnbiOu5rsaMKLoAPkX3GU36tbQG2uoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bjBXBQtbh2wmYJIvCDTIIetjm3awBU/cpcKM5mw9H81avwDTkS1YspdsjaLT1rE8Q
	 87noMVdHF7KJ2aykVHwwcOGjAo4bhGNefRsiaTDt4PHgfEO9uiEe8kasxpRceP8nwf
	 WYh5KQl5559jY2oKsewrqkbUcBmIvs7aB0i8yV7kQTbBT3LCj6XUODG/fzgIpuUfDH
	 X0KW4eco5XKt7PU2bqLeCm4Yg1RtgHjMtsEIbijx5yiDbeRpMQX+32UrxA5RXs7Dc4
	 5cuv6mP6GpOdZb+DsZa/uQhfEnm20HN5lYaE9xIwhI3qyK6u9T0ZfStsRTH3s6UMB5
	 B0rvlbziO3kpQ==
Date: Wed, 9 Sep 2026 16:37:44 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5e: Move representor vnic reporter to
 eswitch devlink port
Message-ID: <20260909153744.GH40544@horms.kernel.org>
References: <20260906090700.3761260-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906090700.3761260-1-tariqt@nvidia.com>

On Sun, Sep 06, 2026 at 12:07:00PM +0300, Tariq Toukan wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> The representor vnic devlink health reporter is created and destroyed
> along the representor netdev (un)load path, which is not serialized by
> the devlink instance lock. Destroying the reporter from there triggers
> a devl_assert_locked() splat on driver unbind:
>   WARNING: net/devlink/core.c:259 at devl_assert_locked+0x54/0x70, CPU#2: bash/3758
>   Modules linked in: mlx5_vdpa vringh vdpa mlx5_ib mlx5_fwctl mlx5_core ...
>   CPU: 2 UID: 0 PID: 3758 Comm: bash Tainted: G        W           6.19.0+ #1 PREEMPT
>   Tainted: [W]=WARN
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), ...
>   RIP: 0010:devl_assert_locked+0x54/0x70
>   Call Trace:
>    <TASK>
>    devl_health_reporter_destroy+0x3a/0x1b0
>    mlx5e_vport_rep_unload+0x12d/0x2b0 [mlx5_core]
>    mlx5_eswitch_unregister_vport_reps+0x1b8/0x220 [mlx5_core]
>    ? __esw_offloads_unload_rep+0x190/0x190 [mlx5_core]
>    ? kernfs_remove_by_name_ns+0xc3/0xf0
>    device_release_driver_internal+0x3b2/0x560
>    unbind_store+0xce/0xf0
> 
> Move the reporter's lifecycle to the eswitch devlink port (un)register
> paths, which are already serialized by the devlink instance lock, and
> store the handle on mlx5_devlink_port. Use the port's mlx5_vport as the
> reporter priv since the diagnose callback only needs a device handle and
> a vport number, and mlx5_vport carries both and is initialized before
> any representor driver probes.
> 
> Fixes: cf14af140a5a ("net/mlx5e: Add vnic devlink health reporter to representors")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Simon Horman <horms@kernel.org>

