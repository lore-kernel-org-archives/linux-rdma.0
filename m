Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE02E3DC4A4;
	Thu, 16 Jul 2026 08:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190313; cv=none; b=UahOELgzjvEmSXLxqFQ4WA8RuM5RPU6Yb+8/XZlVFZQll2mPvWR/I+SGOihFD8KO19k/ycg8s/icB7TkBWv6pqTHevpaXxqiokAKtC7uDqfqEwKl84Movxsxd+F+MMYLZRYDSXxiwWGBDuLH41mlyI8PB0RDh66fbPJYyUGdFh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190313; c=relaxed/simple;
	bh=hTseHX9McpunvK9ku+Y1VPRrEwU9kKTwkoegTw9D25A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UjdP1H3eSuOry4db7QRePIFpZ5f6Czq/8q4jf/NRBZtqfNJTjuKq7iyKuhfjZysgMAI/KhBVQzsotCUyQTWXQnwTJyFKm3phQ8Ofg4rK0STg+hYF+fNeERRrhhjGhjIY0TeNb8oYiTxUH1uRvkAQ25MG1iaZBA68ZSksAicqyEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClylrU35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClylrU35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A21F000E9;
	Thu, 16 Jul 2026 08:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784190310;
	bh=qZW+M3P/+ig7Jw2pQiKmK7s0foyMbhMBzVV1CbKMT3E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ClylrU35aD3TpVVZALIA2ckGp9CRCh09VF2wBVSTSEUxIbmy/6oa9ffsv2biR4hWM
	 z1FaYeivzfuFKmcc5/evqUqTh/n5g8INlko/0dWmkpuf+xO8rwIuLT0FUZlRSc0u8Q
	 bjlNeW7j7jmeHrORuxS74ueqRkqbJ19Kcv2zjj7tufaYD4avswEXhFay4tlMCiuaTE
	 D3VyIphHz94R1Ry/9eAhfgZUb/dpdZjnNyUmceTCBhe6m1T746WGf/1Ap6ty40jWTE
	 qK1ql19tdcHKg5CZwXu9sjptrwNLqwXMUFkNkr7XAdSh3fNBLuCSNl9+Nf20WIFYiF
	 /JKjjp5CX+Afg==
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
Message-Id: <178419030714.296156.690668882209911823.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:25:07 -0400
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

