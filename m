Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA33AFB1B;
	Sat,  5 Sep 2026 20:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639164; cv=none; b=ACwYxRDg+DcydWJu+9h6P330PPed/dsQ9IY+Fh09jYEeG0o9Giz4mzhbRpkJ/7oDR6tZPArpdMIZ+xgBcnvyp2hR7Y/bb26aXaRrdDt5C17P+PNdUX94/mTOvjL4cRvizDT5Gz9vr6G21RkVyBuiV2vaR3Az+lVUT+vYrv5AmvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639164; c=relaxed/simple;
	bh=5TQfNG1CzxgK1SZw/KxXisYZc/as6DcbJrDW3tvpCEM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2suyZjNEaMFzTuUuDDz4+P4+16mSc+ZE+tBY12gyhu0de3Ts8pMEDB3GDs51xjOHvdQQWBQnhiUKy+gfq2+hZWWcPwwRmvxR5Aw80NGlqAqoqye4FNdmb7fWaKUzWTTCmICDGo4TNqdLuzo4salJexCkQY4kO/8spIcBgGk2RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiJxifnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiJxifnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB17F1F00A3A;
	Sat,  5 Sep 2026 20:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639162;
	bh=7YUwzqUuCttKXScpOw0rR5PWnJiFbEbUAD5VJetCK9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oiJxifnHsSpZV0sY02P4vhV0iw/K9pP/QTwpG6RvGoJb9KxAbwy/IHr2J+TaTqIWl
	 BKQERaAxazwc9XTxWVDwHafzTWPLp8hJFEatvsvrZBUgy5QBW+HpIlYrWWmfkF1xlQ
	 U0SyKP0bZs9rACht4bOG9XTJeCF99zPGjv/UN3GHxToWdY6c5PkzK9WPUD01DY0fW9
	 af98u0HanHl4G2SkZiSGgQQ3xrG/rg2SA0HmKMT8eQMgqpPuq64gX5qiX6ui+0a9E5
	 I0b0B1YjqhrKBStxIxTUN/JW0V9QbyhEU9kQ9PjHRT2G9DrorRc3yI/iUWotlJUPYr
	 WVlnuEfyN4KuA==
Date: Sat, 5 Sep 2026 13:12:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Akiva Goldberger
 <agoldberger@nvidia.com>, Edward Srouji <edwards@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Parav Pandit
 <parav@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Simon Horman
 <horms@kernel.org>
Subject: Re: [PATCH net 0/4] net/mlx5: SD LAG and devcom stability fixes
Message-ID: <20260905131241.19654927@kernel.org>
In-Reply-To: <20260902163716.3656279-1-tariqt@nvidia.com>
References: <20260902163716.3656279-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Sep 2026 19:37:12 +0300 Tariq Toukan wrote:
> Hi,
> 
> This series by Shay fixes four bugs in the Socket Direct LAG and devcom
> subsystems, all related to initialization/teardown ordering and
> concurrent access to the LAG device.

Patchwork seems right, this doesn't apply.

Failed to apply patch:
Applying: net/mlx5: SD, serialize SD LAG init/cleanup against LAG mode changes
error: git diff header lacks filename information when removing 1 leading pathname component at .git/rebase-apply/patch:10
error: could not build fake ancestor

The format of the pre-replies seems to break git am?
