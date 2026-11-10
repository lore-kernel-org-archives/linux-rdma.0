Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311202;
	b=hjJRcZnwx5DGS69tLCz4ZsGYV6qJNsC5EgkMQ+FJsrCp4zldw0lAIEPzhnJrQOa0nA8R
	 XOFAZ+0tz3DrrUUd+lpnmjI3pxznsHIHnI+Ool43dY2NkIy5H14+0tX4yB104VBEWDeWm
	 2wbu2hD9NCsSbT+KncdXWFE+/4PbppwnweRmaO98kwToONJ021W/7jNDhY548HEuNyJHF
	 YW3Phv3kq4ZBgyZ3UVVVsTgTqVaYjhRSM+w0EqHfoYCYkeKhwPbSkH7FfI4emMvqsFURn
	 XvFgtT0TX9Gfg4qiSJblhcAQNlw01SGV8koaLwouRScTX37dwd+lVoXUuKYbOnAAWJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	b=uA/Ykyelojlat/QvdmQuBXpEKg9wz5UFkSC72kwnPIbVlGncCXcyOTvHLazftBU6sY15
	 NaZktU9mR6wP7gVNqmpXwVifwiKspD3Lfxk/ph/yLFCr2CyLFZ2lh7rWVBicCRQwrN6ZR
	 ALPcEAkH9X6Xs+ecAD92iESVhx0uWsaVdpPaTuae8HQaEHDcf1BslEqcn6PT8EHZcJx1R
	 NtZZCmVJ4huVlZ2/30C+uckB7Fg9k0dzR7NOT+uaAD+Lo4PRU0QEMWbcEiD4j6yWo8667
	 V+t/HkvoOC+Ojs0SQady+FCdAjizJLvyEzYL042L5mLjlNVzXP4Ch4+dK50sLeIdlCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LFSFFYkp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE5E60A260F;
	Tue, 10 Nov 2026 11:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LFSFFYkp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FCD1F0089F;
	Tue, 10 Nov 2026 11:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311202;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFSFFYkpXH7uqQz46Yj46dzkAyO1t1Qyu1DXOZBeodOMBYJyIXJA81p0LqBIV9WAz
	 CWAhLuLD0Srhq1UJUpLIouTOhfL0/kJ/WvmDqI6PB7qnGLGcVFX9psdV/Sm47IVdgX
	 YPxF+/oJoXwhTUdxzmCkJZycAwUvGcS6G5jL8/s8Y3juDbsFv1dxUCljfgRBLUWZQU
	 opIbBHwEHC9Le9wzm1r/B1ZOAicV8zjLAGluUQDdqZ/W95JTi13wm51V72KRqoXFzr
	 KAdNUmfEKBtksWe+Ana6HUCX7f8sG72i5vSvGi7nyoQnYajq1sUD/R69VXeQMReVxR
	 2LFx8FUSDdoVg==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Roi Dayan <roid@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>,
 Uri Dar <udar@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: Lag, Return error when enabling MPESW
 without LAG support
Date: Tue, 10 Nov 2026 11:46:40 +0000
Message-ID: <179431120058.488859.15105288685934653677@kernel.org>
In-Reply-To: <20261110114350.2639891-1-tariqt@nvidia.com>
References: <20261110114350.2639891-1-tariqt@nvidia.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
