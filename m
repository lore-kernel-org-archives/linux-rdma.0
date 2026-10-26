Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792999597;
	b=k09I3zKcU/9L8UZPX0uWp6JtiXHuc/Oy3zW3FVXgYS89IMRZt4IjfmFikE6IZMo+Xmz1
	 CNa+bdESFm5/0RJhQApyJbPe+zJXkesB9qfAJlGqKcu/UzEXCtCr5TUECEGbfcNupWabp
	 RbQ6JfhlCAbwbT2q/dlN9hZl3/9IUziqrbHi2hngfb/rDBTgsPi3S/3VpWRWIF9VQy7KQ
	 PrWQ517N9sihbdkhLEpP0DPc7sUiALlw6elTiXMcyAerp2CUbsKfjRn5eOEfmRVpe/wq6
	 oq+ki4yvD81xJzpaD3ZR+i2njTfuogzQwrt9nCYPnuyUIJyMagQ9GvwjHda4IUio9Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792999597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=Db2xr3TEMNCS+jRvJ5XkCh/32cc8swyzUxFdTzJeipEl7zMKNd2isD1tCQNp0YQMca7C
	 LJdZ737hM2L3iO2qSStuSrYpT2nGUKYl5blVclFNcRdpkO0eTvXU77NBIwJxLE6qa++h1
	 Bp0hy4+2dEbjJ8ahRuFkuJF8NerbUdg3AmavstmZggJdzyQFRClkJeYT+OlMhecRALyCM
	 yKTIVkqdItTWhdJSz2eOQwU0A40fErIwHKIEjfk5FVKvbQzlOBIO5IORTCuiS+pJ7A4Iu
	 MVNIcoFpZkVVu41RnKeJ52xmvOKUq02m7Z6PXjDrvS8+NF4dIHdTKYZnqhThVxoDeEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmFo8F73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B91F606A31A;
	Mon, 26 Oct 2026 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmFo8F73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716491F01825;
	Mon, 26 Oct 2026 07:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792999597;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmFo8F73n5xbafBwmq3iZ8Ti0FJLcc0FXHauFpAkOR7+Fy8nOQkOu0cuWVk3MeRmS
	 8dab5qt1Cuw/2aAY+09nbx+3CQm0erVBNnEzMc/1aHVL5dxTEuCxNfzd78+BXBkV22
	 AMglZEDRS4nD41vEg1Tc0rwWFNGi9782nzJ+aJj7NuE2bVTtW3nRljxgioMJhYPdT3
	 09/0hiYibDCxBZyJ3VyNImCV3J6OL4QIUrwT5/pwVAwwDXeO+B6KFspGJDJWiCSObt
	 jhC0I+G0W99fmhSHGlrWoy/Uz+1djHQpZBk++xLu6wSFsfzXKvnkliaeBDhl8KdmUL
	 2u2WI9ezP48IQ==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Alexei Lazar <alazar@nvidia.com>,
 Aya Levin <ayal@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shahar Shitrit <shshitrit@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Fix false WARN_ON_ONCE in flow steering
 cleanup during RX init failure
Date: Mon, 26 Oct 2026 07:26:36 +0000
Message-ID: <179299959603.3327.6891126841822324163@kernel.org>
In-Reply-To: <20261026072253.4118892-1-tariqt@nvidia.com>
References: <20261026072253.4118892-1-tariqt@nvidia.com>
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

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
