Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0C3793D5;
	Sat, 10 Oct 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791646953; cv=none; b=e7mhiWuQvk9TUEwH1nmlR/skWfDfnSyw/h+YuHr3F61VnqHimdwCSzlaIR0lEmHnu5gFiYVwl0cxnKv3p/fNBYtwiqNeNZpRLCdjOZPnJlvchgr5Qe5FeLbuNKyDmA0POoNILs+QiZvfHCSXzPaZpCm0QV5DqJW5TXIqQnd4E14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791646953; c=relaxed/simple;
	bh=+/stIHVnNllyLNmgxOiEfWQPD3m+sCUJ6EaD1hPNroc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOpe2rng736T3SNiZJrDBW8Ps3ZAH8R/EIu1XEjKFVcBKaGSM7BUIxN+nkfCxffrGaeKyDieZB6NpTVZkBzX+jT63JzuBEM8aHClq1xvL0ae+fFj7NGwI7QypM5RfjxzejhIrc5OqYz4tVXpPzhSRLPY/SLHL54fvNIrBvk86RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaB2IpWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaB2IpWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738DD1F000FF;
	Sat, 10 Oct 2026 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791646951;
	bh=t3Bj1MwXTOKzIBEfeF8JBZnRpIJ12Xf+XRKo8umfYuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HaB2IpWpTyqZzWXjSUxNAC3YA9UmHVXV7wkhKcW50MF8ZBRB8Er5QqTFdjzCIWWJt
	 u2lAHg9jjVUCquQ/F7Yahz55a9iRn6bMC3irRRaOkl+1wORQw2sS7ctlZHXgsflX6G
	 qqrwerWL34jgUvqfq8Zs/tCxvz5JAfdHSA4QFRSgKyOywXKJU4laW8tbTVVmntT5m6
	 nC27N5RhkSsTQViOdm43tiUo1C4OXazfTzo8glPNzQ8kOM251qrKxZgcZ+rxVoG8Qr
	 SY29wERWnn5+iV1S3fcAMkBJvC5Sy3N+RYf+W4I1IdB4Pv5u5rBlgjFvyO1rXruXHz
	 cc5Kc2z0fIhAQ==
Date: Sat, 10 Oct 2026 16:42:27 +0100
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
Subject: Re: [PATCH net-next 2/2] net/mlx5: HWS, shrink FTE action array to
 fit
Message-ID: <20261010154227.GT83879@horms.kernel.org>
References: <20261009052103.3621855-1-acassen@corp.free.fr>
 <20261009052103.3621855-3-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009052103.3621855-3-acassen@corp.free.fr>

On Fri, Oct 09, 2026 at 07:21:01AM +0200, Alexandre Cassen wrote:
> An FTE keeps the actions it must release in the array used to build
> them. This is a 1 KB allocation sized for MLX5_FLOW_CONTEXT_ACTION_MAX
> entries while a rule rarely needs more than three. Keep a copy sized to
> the actions in use.
> 
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Simon Horman <horms@kernel.org>

