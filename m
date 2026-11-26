Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719443;
	b=cFqJgEKLOLV0yNcWGTwdGz4/xBkwBdWRmg/YQCZ8Ibts84joDsSPHRAfSkAvV5cJHgPy
	 cYFj+pI4rwDgZuAJCcM56Ay1xjP9SX/rNuFwh5qB4u2QTpntVmP7aJgGfoSsCx8U5hpp6
	 YTqVGw3JI00tkdwF9ODnVAvJtpiSdAyorlAQwKwnVTiq2wIijysx1FOd0rMYcGdsMx3yq
	 tw8xRBzHC/LjusG7N18KqkSF8q+SdtWXNZLg4NcT1vXlWyOi0L1ly1yiThqrjse2lrHoG
	 chC6ZhTTzxDj2grF3LBBHIMJVVXmLa3eLhmeKk+wPCZ8SLzni1qQIEJwwhIrInaMouA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719443;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kSBAdZUXpcsjCp+/A0gxdvnXhRhVJKjpkJ20SMNflzo=;
	b=ToQowoVr2WvBLBkU2hMrR6rNcBx8k9nk81uxuhChMkVnviDVNVg+QQ2Rs5hl2iV3Wv3x
	 wenNAkIbxMOz2taFRdhoaTr1o0TBVEpgQeqW/0gjUaUJL1QbRpjP++RQosAg4/4+wipCv
	 N/xSAA2Y9l/CfpcT8Pc642/Ga3JQXWHCGRg/4+N4zmB5WJ8Bv7vXZn0qXtSdMLqechSDI
	 VeJAkUchfa1iylVm+UHejJfWkVpMyJjrXJHw4cSYyHEy6EbaRNY0zgIiFSF9GozGFQlHs
	 ustPgWVlXw0F04A+804y0UrPT5RCrOTD6FEmgAjT2TZZZG8vqejGuheGkVzEBJkeZXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBDW9EZl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5B2606A31C;
	Thu, 26 Nov 2026 18:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBDW9EZl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F521F000C4;
	Thu, 26 Nov 2026 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719442;
	bh=kSBAdZUXpcsjCp+/A0gxdvnXhRhVJKjpkJ20SMNflzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WBDW9EZlwxmVJ8SNHTmzMM64N3CqIPoWnMMV6Sk3wlco+L7sDJkrQH0qB7bmdy5iv
	 K1Ywf/A5vXYQbjJwBdOOPkuUsAIJPxacQGOAs4Yj4/aRfzf1vC01Tqsgz4oDVHXwsW
	 DIRCr2y9g14aI0PkviiwpYEQkSV0IOq6DKhYMrGzfs0C1XPHKh9XSO8Hoa1s3PyTvu
	 GMRkaxRwUctVRIvoL2+EAObQevzOFKvkVnIQUYO/QZ9HZ2P8RlH2u7PIiyy/aNNwAw
	 QbQB0VVSTRlGjkVs7aHjm2sd4npn/BvAu3Ir5INhc1gfGbUGFSmSMZIQJc3EFruW/G
	 9uIoRGWA2rApw==
Date: Thu, 26 Nov 2026 20:57:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Eric Dumazet <edumazet@kernel.org>, Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Add PSP header extension length
 match field
Message-ID: <20261126185718.GV774860@unreal>
References: <20261126061904.387686-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126061904.387686-1-tariqt@nvidia.com>

On Thu, Nov 26, 2026 at 08:19:04AM +0200, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> Expose the PSP header extension length (hdr_ext_len), so steering rules
> can match PSP packets with extension headers (such as the virt cookie).
> 
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied to mlx5-next and created tag mlx5-next-2026-11-26.

Thanks
