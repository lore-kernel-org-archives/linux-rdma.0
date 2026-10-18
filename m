Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0406B47FB09;
	Sun, 18 Oct 2026 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792333109; cv=none; b=UPKyLvpp0W+y68ID9dbx7NPdRDMsyuz6qtsXe+VE1zFjcfF3QJuprkZxl1tOLXCpZIprqE1vT4HXgxDvFNaNmnbViEVYx1VuOTSDwlPC6crTwUcSiW5Ewf/PXQ+eI/JsCdYh671GspQPfbAbOGrSa1phHQ8Qmo8pJvmApoY4sas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792333109; c=relaxed/simple;
	bh=IM5Fj4JPOCqrT5rOKKEjy7zGKt1J3J3HuZ1yE56Voa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hA00SCGAfRfogefKhQNrO+YPDLgNsN6DbbrVEAOfpcHeUxQqTBMIEJthyvMQleShoe8tsPkTPOyU9vTxkQsaYlojwdrZNzU6KNOB59LiAyCsvOGy5jcEcehRZw0a2w4BIyCLXzU4Ql5xna5O7FF4yb3KxOSzswu7VxEGJQGNd1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1VJP5RX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1VJP5RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6B21F000C4;
	Sun, 18 Oct 2026 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792333107;
	bh=mOL84OQuObBVmDFgNFC/EKKiIIyg2jUUUmh2KezEB6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V1VJP5RX7hMlIHZ2elYRJPIfDUBab4+to5Pd450gLi6sDXQRpHfM7b8Ik6hDjttjR
	 3Foszn/qc4+oWENaY8fDO7GsKkk3yVkqR1u3C2CcQydrG+GI6062HwTYceiUzFjALT
	 S9MIu6uudBb+5DRRAE+apoNNerydDUFWd9+1r5JYolCE5WUHtgyFBTUsSddXI70X1N
	 q+1rMOXhoHqz9hacYYNMeAZit2ssNhlZQZKy4BsdqaNdZxhCUmWU1S/Vj5Nc28AkJf
	 hacBi+0Ghk0JoJ1HunRrRQtW2wlED94oblet3QBeu0gP3X7nE8iY1E6UqXMsQhbYaf
	 b4nLJfV3uUz1w==
Date: Sun, 18 Oct 2026 15:18:23 +0100
From: Simon Horman <horms@kernel.org>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool
 creation race
Message-ID: <20261018141823.GL503057@horms.kernel.org>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
 <20261012100555.1317878-3-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012100555.1317878-3-acassen@corp.free.fr>

On Mon, Oct 12, 2026 at 12:05:54PM +0200, Alexandre Cassen wrote:
> mlx5_cmd_hws_modify_header_alloc() creates a pool at the index after
> the last one if no pool matches the pattern. TC and CT allocate modify
> headers concurrently, meaning two callers can take the same index and
> the second call fails with -EBUSY.
> 
> Its error path also destroys the pool it just created although another
> caller may already use it. Keep such a pool since cleanup releases it.
> 
> Pools now live until cleanup so the lookup needs no lock. A miss looks
> again under a mutex before creating the pool.
> 
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
> 
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Simon Horman <horms@kernel.org>

