Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6922033939C;
	Sun, 18 Oct 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792335852; cv=none; b=swXCZwNXv5U8ObcOvjzVy6sT2c16mJACjFatMD4+NWBVc2y4CZqHJCcNQ0MF6qk7kRpQgJRdpPMigEs/02WjdrgElLZQ980dFhkokeSlibEWe6mk2dF3SsJ4RkbnARRIR05dvxdduIVmRjjk0pRDfWcIeO4qI3yVRb+oiFGYu0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792335852; c=relaxed/simple;
	bh=SaVVYrW2VHMoKu//CaCbmUhdGJvzpFoi7K8fOw1Ca0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1s2TfzxbEt6jaJC5G4JvKLULlsTI75xOmIQV+0DpBfNmDn6gcA5Q8kWvfr1KUWq0efjAolno9rolpxN0866LdR0mYa0pkAFggqYxNkDw0OlrMyruHqTTVCrN7tw1+exxiGQSKA9fxwdPYdk4eRTStE3mK+AXhAGZu7Ibcv7shI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ci7aakrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ci7aakrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B708A1F000C4;
	Sun, 18 Oct 2026 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792335851;
	bh=yETzaNof+WvrGSJOkhyVX8lj6E3JOoi0Ct305J/xlUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ci7aakrvdKM7UVaToBu32r+gAD9/+ocR2nLZBK5KUnGB6a3B8qihM5itPQKV9efjE
	 5M43IQRWZg6zuJcudlYG/CT6sBMoyLIQ/U4Xr3VnU7ResM7FekgBo1roRLiSfI3vS0
	 GbvVtsFahotMa4woRQFE8CY5UsgtMHJiOvlJ7ufU/tJzqZBONAmIuT+aIL7FAIlf+l
	 q2bRIXMxSAcMuTdAZr1fRVVbP8B/6TjAPBasJS3guD5bzqhEr/LFnPilooi893El1t
	 hRPrQbhepMrIZ776m7UMnGdD1iU52Wg9RvS2V2oTh8+PCZFjiLb1ja+E6dnaF5C81O
	 nXJOTOS4MowdQ==
Date: Sun, 18 Oct 2026 16:04:06 +0100
From: Simon Horman <horms@kernel.org>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Hamdan Agbariya <hamdani@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool match
 for copy actions
Message-ID: <20261018150406.GO503057@horms.kernel.org>
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-3-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012101937.1335231-3-acassen@corp.free.fr>

On Mon, Oct 12, 2026 at 12:19:35PM +0200, Alexandre Cassen wrote:
> mlx5_fs_hws_mh_pool_match() compares a single dword of each action
> since rules pass their values as arguments. Copy and add_field actions
> keep their destination in the second dword and HWS reads them from the
> pattern alone. Two modify headers whose copies differ only in
> destination then share a pool and the second rule writes to the wrong
> field.
> 
> Use the HWS core comparison that checks these actions in full.
> 
> Found while checking a Sashiko AI review report and confirmed against
> the HWS pattern code. Not reproduced. No in-kernel user puts such
> actions on the FDB but RDMA flow actions can.
> 
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Simon Horman <horms@kernel.org>

