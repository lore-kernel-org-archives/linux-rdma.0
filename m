Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C76D33F8C4;
	Wed, 29 Apr 2026 01:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777427193; cv=none; b=AGwOSmBypjbhDLfx2WeNLGo9mEvLGTpbpBNOLc6fOw37jphOfCzqdur3zbmMQQGHjflNasjGm2/8YEraCY2FaNfDEvuYjtgk6V5H6SuNNBlIL7krky7DZv8wNAUuoIAd6KYmgzgY7sBwNL+aNgEMCZThUlMiWzlwujTUjSCqNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777427193; c=relaxed/simple;
	bh=sRe4dp3Omm+NGAYOYEzRs45aKL4JXVJG+80i3lBgmjA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pO9bjoLTjy3UQdRh9vwIIkRVnOv7DKgX6U1EhEoPC7PAWrFHDzXUqIWB0vL2Hz5kMStcrHz/nbgmUO3HGMTEiQbeB4exXrfACMvGIYPZzXZZKo0Ojr71wBQX6FqKMiIIM95Qq8++Wzdgms42PKFzTPWuTx61ANk6efsoFb7L3A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCJwZb9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCJwZb9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A026C2BCB7;
	Wed, 29 Apr 2026 01:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777427193;
	bh=sRe4dp3Omm+NGAYOYEzRs45aKL4JXVJG+80i3lBgmjA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FCJwZb9oDWUqXGsrpoKFTATqT+Fri0BZ+jpU2yjF2y8bNomq72D7a+FYGpwjTKogo
	 tcVViXIETmRAjNsQPQPQppiZ9vEHx2CIPrasAREbQZ3ckANPVh33hBSwEg+GCwdjt/
	 MGsY4jDEf7RNpqgWaaO+uJolxl9mP//Yq6gNZXK3xPrFBdz5zIfb9T4w/VMNy/2po5
	 l/34OlT+ceJeVFsGZ2B5aCee/wLaOjd+WPoUJLKXJCnYfldElh8AjYoP32OwN4MX0/
	 408X7JMRifm/UjcZlvl5lzoEZ43a5NYzF5z4xzDAnrulX8H93W417Ua/CixPDBMS80
	 tuxyB/avFywCQ==
Date: Tue, 28 Apr 2026 18:46:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Marc Harvey <marcharvey@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH net-next] net/mlx5: Add MLX5_VXLAN config option
Message-ID: <20260428184631.40f1f1b7@kernel.org>
In-Reply-To: <20260428-mlx5_vxlan-v1-1-cf666d042618@google.com>
References: <20260428-mlx5_vxlan-v1-1-cf666d042618@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Apr 2026 22:44:34 +0000 Marc Harvey wrote:
> Currently, there is no way to disable mlx5 vxlan offloading if vxlan
> is enabled. We've (possibly) seen some minor udp rr and udp stream
> regressions when enabling vxlan, and want a way to disable this
> offloading. Also coupling vxlan offloading with vxlan enablement
> generally limits the flexability of vxlan setups.
> 
> Add a new config option for mlx5 vxlan offloading specifically, so
> that users can use vxlan without automatically opting in to the
> offloading.
> 
> To keep the same behavior as before, the new config option is enabled
> by default if vxlan is enabled.

Can we delay init of whatever makes the device slow down until the
first vxlan port is registered? A kconfig level optimization of this
sort will have rather limited applicability.
