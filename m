Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB602D0601;
	Tue,  5 May 2026 01:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777943424; cv=none; b=bJoNznsUG4eB5P+guRekrrq6/BdTxvaVBXkfxwf1/vqNvFDXYfLwwdw6fjNawqf5p9oKEAkKk1byHlURAw6D+VlH1/JpImDH6Lr6+jU4kueq+GhOUs7nnwXNUB+Ar8iTeFbSxcE5tQi4XSsXxWBPgNwv2Uh0J2p2X7q7YYWOe3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777943424; c=relaxed/simple;
	bh=HSJ4+SdJVYdg/SxjcsI1GghaTXFxJmxWZOJKZ1VTTOw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRwx+z+eHOct5Q0A8rLatIzDocB6w2PjCmH+5z8fYWGh+TulOP2efMaKV4EHllxyJM/zOPyQ31KyQrv9QOOQP2ezzHfoV3q7GLoCPf5fG1X2zdtaoW18HQpTDIoFmdi9klmqLctXELPQT7iljy3hSOdkxSOozcA3/3kPTHuZqwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4QJVbvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4QJVbvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15CAC2BCB8;
	Tue,  5 May 2026 01:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777943424;
	bh=HSJ4+SdJVYdg/SxjcsI1GghaTXFxJmxWZOJKZ1VTTOw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=U4QJVbvRuKZ8IgDDxzwIrug3Z1miKGoBqsVskwLKx0ewH89mUxArfSgshF/3lPRMc
	 NPzKQrbec2pHXXPcFNJEWjyC5Rxknsfz7tSrln1+AHgI/4m1jIoJsZVOhIWa8xrgjN
	 LEXKrvn8+mKf/iI6DDY7+Xtr/In0HKhkmsx6d85su3p8CxM2NKbXd9I/1/p6ZJb75k
	 aOgCYcXumo0Lzay84cF3e2xP2Oqihsz3YG86/yOBVJuH+PXccYnaJpfMziGcDIo4rA
	 OAKl4eCFvQ5MObX4bFh4p7jEXP47Zf5NtruUrbOhiz7JkLNpnqwZCkw0P1D/IO58mz
	 00prZRu9P1C9Q==
Date: Mon, 4 May 2026 18:10:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Marc Harvey <marcharvey@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH net-next] net/mlx5: Add MLX5_VXLAN config option
Message-ID: <20260504181022.60ee2a1a@kernel.org>
In-Reply-To: <CANkEMg=Xc9jN8McZmLerK_ffOwRFfX+yO=4Ha6+umVogbkBj3A@mail.gmail.com>
References: <20260428-mlx5_vxlan-v1-1-cf666d042618@google.com>
	<20260428184631.40f1f1b7@kernel.org>
	<CANkEMgkBnuRfurKcFEUAZcJcX1XYSnHbBozZGP8DpnKq--tWbw@mail.gmail.com>
	<20260429190150.417b0302@kernel.org>
	<CANkEMg=Xc9jN8McZmLerK_ffOwRFfX+yO=4Ha6+umVogbkBj3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 May 2026 15:44:26 -0700 Marc Harvey wrote:
> > Are you aware of NETIF_F_RX_UDP_TUNNEL_PORT ?
> > I haven't checked it does exactly what we need, but I recall there was
> > a ethtool feature for this..  
> 
> Thanks, I didn't know about that feature and mlx5 uses it. However,
> mlx5 unconditionally sets the `UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN`
> flag, which excludes port 4789 from the entire UDP tunnel core offload
> management (see `__udp_tunnel_nic_add_port()`).
> 
> So using ethtool to disable `NETIF_F_RX_UDP_TUNNEL_PORT` will not
> disable vxlan offload for port 4789.
> 
> I think a better approach would be to just remove this static
> automatic offloading for port 4789, mlx5 is the only driver using
> `UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN` anyway. However, there might
> be a reason for this, such as some supported hardware offloading vxlan
> on port 4789 by default even without commands from the driver.
> 
> If mlx5 continues to use the `UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN`
> flag, then some change is required to fully disable vxlan offloading.

Sorry, I don't know mlx5 very well. Sounds like you have to talk 
to nVidia or/and run some experiments. The current patch is a no-go.
