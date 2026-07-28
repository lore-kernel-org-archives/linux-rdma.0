Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5CB15FA81;
	Tue, 28 Jul 2026 01:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785201540; cv=none; b=CYG9lM17wEGu6Bz2DIm6xB65kxUgHhKx8ivU/tWRmcCAVLPgOpwC2yBhh7KUAFKU5/yeGjII70B+bezIn/PXJA+6eHKWe9+SaGrFZsnQ8a0pDpu3Q/t2VuBcHWGLoK/cN25fuzTwrb1fMNK08QtbK86SiWgmt1HyFa+Twt5bKzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785201540; c=relaxed/simple;
	bh=nJj6HVm54usLAtb+iHNJ68vu+QRYTYu0hBNI41xtLcA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UOY8YE2MulBqTMS5PKiRUskJRjCf7pUvFHKxwiNLmTe7Y+n7/q/M5l+GheijV1ATyrA5pYv9iInrsITN1xNjTZy8dg6b/lXp8w6+v/QyMxvgBzhQErcXBi5HSb79dQ38UeI4lll9G8XDKKHYY11xMd+SiOB/gqLRuPzyc4jGxFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBFKMw+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBFKMw+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5731F000E9;
	Tue, 28 Jul 2026 01:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785201539;
	bh=hKBRute5puBoz2A5NuiuSr45HQgM6N92M8ZdSrBZi84=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QBFKMw+xgjGwNLaAf6g/xA7bja3Ue9Yk1zAend7yIwbq5WJijvuW7GdZZ2VPPtT7/
	 yMPFxwMEnFDRkc5Nu38Bcz+jGMDEWoalMpKYOwJiGmhxqM+OVbkSnUR7saUf0U/Op9
	 bDEmMKmSWJJ2OkP8ceGfxA5lBxX7KqZBEqiNXdde+qsJni+X8mAPIeFOqo9gNEL7Oa
	 t3s58MlE1LVQS+GMqnj3s5G9kEy71r58D0VOZLX/TQRZuu9i0GdQsYybj5ihDgU0a2
	 Lg04Uq9bV7DX1OdneyOjufPYYvfqabNgf5feWrMVxp8CkbxnYUJIFJXzmwoBuat1sz
	 3qe8UrVxkZPZw==
Date: Mon, 27 Jul 2026 18:18:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Akiva Goldberger
 <agoldberger@nvidia.com>, Alexei Lazar <alazar@nvidia.com>, Alex Vesker
 <valex@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea
 <dtatulea@nvidia.com>, Erez Shitrit <erezsh@nvidia.com>, Feng Liu
 <feliu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
 <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
 <parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
 <horms@kernel.org>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
 <kliteyn@nvidia.com>
Subject: Re: [PATCH net-next 0/5] net/mlx5: HWS misc enhancements
Message-ID: <20260727181857.70ddf786@kernel.org>
In-Reply-To: <20260723095349.1890983-1-tariqt@nvidia.com>
References: <20260723095349.1890983-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 12:53:44 +0300 Tariq Toukan wrote:
> This series by Yevgeny brings several misc improvements to the mlx5 HWS
> driver.

Looks like this conflicted with some patch in net at the time of
posting, because the build tests against net-next/main worked
but it never gotten into the selftest stage.
And now it doesn't apply even to net-next.
-- 
pw-bot: cr
