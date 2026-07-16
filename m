Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324293DCDBF;
	Thu, 16 Jul 2026 08:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190340; cv=none; b=IQhCGiw/T+aQB8bO+qEzbYqvENcvdjqK8Csuy2NveWZRZ8DoeUihfOO2vT3ZfD2R0lFxjpekQ21i2vlzR4bmnsOTupx38XiP96rAy47E2Paksb8Ct/I8NHSQ5EJwTscJu6hb30nqTfrq73I0qbMWRSplIHJSNMxGrgFQsBhQI5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190340; c=relaxed/simple;
	bh=hTseHX9McpunvK9ku+Y1VPRrEwU9kKTwkoegTw9D25A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=o7M9T11XfAoUwJzIhB29Wzx6lBefww7eQz1yPXEeLphBHlGftKio/yJHNx+HF6JnRILqmP8aREAmgiGl4e1PmxLx6KVAxz/9VH9PkxXO15khm3O2SRh9J8bL/EK8P9Fnovgj7yh7RGzatfy+LOvMp3Q3uMkIPAiNkJj0BI1yxHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VooyUSBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VooyUSBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD811F000E9;
	Thu, 16 Jul 2026 08:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784190337;
	bh=qZW+M3P/+ig7Jw2pQiKmK7s0foyMbhMBzVV1CbKMT3E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VooyUSBA/aLIk7mc+S7WnuDjCbhI35Nu6XJ2T22OUncxNcM8AHbPLnL9rxFMJ2Ni8
	 IxYp4a0Ys7A6skJwtWLeJIzs8i0+xe9OlXnWT7jfgfFzo3DczBYl0jYCs9itTDYwDL
	 9yR3Or5pChF+13gfprcjNptw0790sfLtZwZVjAHc3rauxCBJo86VwCQi50xeyZVITm
	 EVH9V8D1Z1UdNHNh+M2M42pkWiTxDaY9jX9VL7EYBYIdGUtOb5XYTiWzFbWddsIkW6
	 XzVTTS7uhtt5gIKzODRUT1ZI77MyuUKVQQZ76JjaN4+3OcatdYzxznsMijie4TUkge
	 Gpi4tTECObiAQ==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Alexei Lazar <alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, 
 Feng Liu <feliu@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
 Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
 Paolo Abeni <pabeni@redhat.com>, Parav Pandit <parav@nvidia.com>, 
 Shay Drory <shayd@nvidia.com>, Simon Horman <horms@kernel.org>, 
 Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20260713084320.1015240-1-tariqt@nvidia.com>
References: <20260713084320.1015240-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-07-13
Message-Id: <178419033442.296394.4741555309463988362.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:25:34 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 13 Jul 2026 11:43:18 +0300, Tariq Toukan wrote:
> This series contains mlx5 shared updates.
> 
> Regards,
> Tariq
> 
> Cosmin Ratiu (1):
>   net/mlx5: ifc: Add PSP related fields
> 
> [...]

Applied, thanks!

[1/2] net/mlx5: Drop redundant esw_cap, reuse e_switch_cap
      https://git.kernel.org/rdma/rdma/c/0b7b17502300f7
[2/2] net/mlx5: ifc: Add PSP related fields
      https://git.kernel.org/rdma/rdma/c/bee40a7d0bd126

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

