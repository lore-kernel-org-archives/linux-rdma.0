Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD6C346E6D;
	Sun, 22 Mar 2026 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204865; cv=none; b=ErYq82asxmDA57h74ow0nM2F6LFw1XpjNTwMsnaTIc5Pub71NNxie9fYPsWH3sMvwHbutcLiViUXvDZbO5skNjU0uVQlMBkmE6/az+cO4lL36npBLDg/aozoMncbMz0QG4F4EqbefZ2wco/d9ZNdf8Bb9PSFc7TiwX49Qe4cDR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204865; c=relaxed/simple;
	bh=9aVIR9Q3GFsJbREmDHykk78zavC2kgRPGm4fnPSwQfM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ulZHupxGXQuDhN+ulzsU5/XV8OisVEaTkM6luQzNmpowqQ1j16+WkxmFSrlUxowz5QK3vDAcEXhA+e89jZh+EQywEGhPU7Ry2t6wzFNA33uNhGevt76V9ZS9ovgn80v6PWenNQDRuvRFpTl4jjD17TyXd66toStXFMq1mukTp74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUd3Ij5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUd3Ij5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E59C19424;
	Sun, 22 Mar 2026 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774204865;
	bh=9aVIR9Q3GFsJbREmDHykk78zavC2kgRPGm4fnPSwQfM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=kUd3Ij5oEfXgGguu5Qpx7Ygz9l+n7Dd6vj3+OPJ//w1nNrpplLIbt/Wts9l6DryPh
	 I3d12pgxdMu9NBDHqu37vlPdXs7hm3p2oga4pIzYgkWWCQxCVVPi4u+SeN1H6pcNtn
	 D+nWilIG+WTQEhiFy93J3uaP23c2lHRm+h2+KWlv5se1TKFK8kNp+fT8B1+gYkxkyN
	 mhIcLRFynsDmthdVdK0n/PAhBAw2rn2nab8vBpbK6y+H78W8sH0co4fKWYS1/iYa+Y
	 TbnL3ZWkA5tXKKhw0DoxeS9XpTjIFy7tNHroL80JxgLYWDyEZzA/ZQNMZyVpv9pqTv
	 qjnF0N9+7qasA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Mark Bloch <mbloch@nvidia.com>, 
 Parav Pandit <parav@nvidia.com>, Simon Horman <horms@kernel.org>, 
 Shay Drori <shayd@nvidia.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, 
 Moshe Shemesh <moshe@nvidia.com>, Alexei Lazar <alazar@nvidia.com>
In-Reply-To: <20260319122211.27384-1-tariqt@nvidia.com>
References: <20260319122211.27384-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-03-19
Message-Id: <177420486191.2044775.9250138333807571163.b4-ty@kernel.org>
Date: Sun, 22 Mar 2026 14:41:01 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 19 Mar 2026 14:22:09 +0200, Tariq Toukan wrote:
> This series contains mlx5 shared cleanups and updates.
> 
> Regards,
> Tariq
> 
> Parav Pandit (1):
>   mlx5: Remove redundant iseg base
> 
> [...]

Applied, thanks!

[1/2] mlx5: Remove redundant iseg base
      https://git.kernel.org/rdma/rdma/c/c0368933dd3d4a
[2/2] net/mlx5: Add vhca_id_type bit to alias context
      https://git.kernel.org/rdma/rdma/c/26469110c750c8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

