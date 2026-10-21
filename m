Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615752;
	b=aCSs5AxKSVVnbcBEYyn1hqu5IYUBrKJK8XWZleZAoT30sLE/94iQdLO6V9tGUn7TUES/
	 Qs+7D/zzU4hqkaqvXDLjoG3/U4Cp+Nvd2uKTyZ0bYyBXQIkMHzYng3AAuY0Ah+k+QAlbM
	 MQz02eVT94LLsY9Nc/SVP958ko3QcnK6krHVYhHZvlWjAdZvFPgkurH9UNl+PmO13pm/l
	 mRs3khbmWqWJUIL4pH2XqwYuW5zwg8T+Rq7poNh2m9pxfHQLjFYdGdRApPDz2E68xk5fB
	 28orjiVEmIQc8T9Eemof182IRnaQgf0Xml1rYC7smKZYiryY0isLK6lDCo3VX0pZ0Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615752;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7NaFQUC0xMf2JZBbEgaE/Q4hbRvyXkdJbWRi0iEK4UM=;
	b=Ld4xW+wuGTF7+FobxZt0NOAtwWvtkK5lY49EpN3dE8gsL45lXM3TFt+VFQjDaX+Eq389
	 veskGQrhqcwKWdpaNSHEDBw9fecZsTD/PwJ7gwuNskDGwWWWCeks318LUmwPOcnMXWrgB
	 b6kU1jHvTKHh5Hpkkfdq0QZQIZwseeTh6oLZrO4SF9ZrH1QJQIaltCLjG4GbENO8qL3la
	 YemPEjMTSJBbpJQBjyQ05+XzBvGirfRQSzAg/30a/LirwNw9m2iYFgr+YKsOnT3nDom00
	 EHBwcpurqD8am7MwA0O90McW96qyJGMFjw9YQsifp/tMrx1d8mhqyWXpW2nGivCVv1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OcKt8yPX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100A6606A319;
	Wed, 21 Oct 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OcKt8yPX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5906C1F000C2;
	Wed, 21 Oct 2026 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792615751;
	bh=7NaFQUC0xMf2JZBbEgaE/Q4hbRvyXkdJbWRi0iEK4UM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OcKt8yPXqCaHsIItEnm6PMiiD6d/uaxbpTKvJUm698UVr0/hgSrprQpPeZhl0hihD
	 RO5yHXEEOHNp2o+iphkN34OSYU2+YEP/IJZYTyZqNGgtMcpO+vlkTmm12l2h++RkaR
	 fzYkYqEyrz7zIi312jatg1ppSJ+8qXwA/kux8ebXuOVz8ZEKHMQn9wNdI0XC61GYpA
	 7eEJh8rdRkK+pYytfwGriRmdSs1x0WuOMuhxqWm6TkXdB0sI7tMCTrE8dy7M1pfXcL
	 K7OoNO6GEvDjMtk8K8q3yoaBE3DgkQJuasu+rSnLen0UAICnZvMLJ5QIzGtnjCWi4P
	 9zGM0vypgSgUQ==
Date: Wed, 21 Oct 2026 13:49:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew
 Lunn <andrew+netdev@lunn.ch>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
Message-ID: <20261021134910.3575fcaf@kernel.org>
In-Reply-To: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Oct 2026 17:37:24 +0000 Josef Bacik wrote:
> +		if (likely(mlx5e_channel_no_affinity_change(c)) ||
> +		    test_bit(NAPI_STATE_THREADED, &napi->state)) {

I'd say this chek belongs in mlx5e_channel_no_affinity_change()
-- 
pw-bot: cr
