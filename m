Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794835379;
	b=wvpMMYKG/tLrJZdjgplB8Z+ZoXNHvaVISNnRdN5+Vl+d3lSWcag7KoVNy/hU2Qum/e5Z
	 nU7liq3zSCA2mGZC4KXdN6V/9nAdZY3gWTjSL+fjQrpCMksyXim/79dyCXSc9VEZCp38i
	 GGIol1/P45tFbVKpKC2+hft4/+trIct63T3isGijI78D1j6TNM+smMnTve6maHoWF2ws+
	 ixhIRTRxEgwQ6chyblMRq3g4vhliN4BxXS2EAepontWiHeai1EkRq0PJtZU41i7ECCXZo
	 L8DH6YHfAiHH/M/PSRfQZ72WlwsLBstZgkAZob+t5aCaESDoaPAYHitU29DmOcuU3gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835379;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=IrY8B6W083i/Dm7Wsv8iM+bQiSqQWGRKHvn92iMpLHk=;
	b=w9MVIYO1n9KXYB2u/rOFRerhbaU2titUnRvpO4QyURVjP5fKi0kOSa89RpQaYLgUQmWb
	 5QE1sIuRvVm7bC4vBt2wwpSYr03DC/REOQf3ZQpO+wSApkgyPkPlAhwpWgzH7qwfTKxh4
	 EMFsckwEge2EE+yXUWRyEfXziY9f2mMeIMXCM5sOQQOGyrzilI4PrEwfDoQQ6AE8mU9Yx
	 O+2f45pUobwapyNSakNFreT01RHjrcKc4vYqvGh1YPALJNMrWkEUbeIOJMgGOsCyDsFmM
	 V1lbDU72k2l9HGvVRJiq/7nMU6oe/VSFj3U+LkTrIRCLspgJ+BT+HXfwLEblN9shu3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1Jqv5jn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6D5606A332;
	Mon, 16 Nov 2026 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1Jqv5jn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25231F000D2;
	Mon, 16 Nov 2026 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835378;
	bh=IrY8B6W083i/Dm7Wsv8iM+bQiSqQWGRKHvn92iMpLHk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=V1Jqv5jnDyW7yStsD84xry+1QpoBJOh7VxExphWNswrBNejqEYmWDctemcnVkvYby
	 TwjHcGtaiomAZVlGYoWhn15jHQzyerDJW6+WR3o99fZY/rkmO70MVSpPYZXWDphX1/
	 asqlEM4NiVFWAq6liX+rzLkL0p6gXVA2u/IhqgpGQ9+1a0n8HFYdE0DSXCs7MDjrRL
	 Vgqd/nyaM0Cldv2Vnyu/Yl4Y4PBwvh5pIeyiLQ4e58Mn9oEJ6TpiycoJ3MA5F3cEio
	 rHp8TRchb4pnG0xiIw/jH9Y8hsAbvto8mX8T8vJgeubSHSJHuqVswnabWxHg92wyLY
	 yyUXgy2sRkPNA==
From: Leon Romanovsky <leon@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: jgg@ziepe.ca, maorg@nvidia.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261115104342.56112-1-dennylin0707@gmail.com>
References: <20261115104342.56112-1-dennylin0707@gmail.com>
Subject: Re: [PATCH] RDMA/mlx5: Check the DM type before mapping a MEMIC
 operation
Message-Id: <179483537573.1367860.690111618603841164.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 08:22:55 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 15 Nov 2026 10:43:42 +0000, Hungyu Lin wrote:
> MLX5_IB_METHOD_DM_MAP_OP_ADDR accepts a handle to any DM object and
> converts it with to_memic() without checking the DM type. The handle can
> refer to a SW ICM object, which is a struct mlx5_ib_dm_icm and is
> smaller than struct mlx5_ib_dm_memic.
> 
> The handler then uses the ops_xa_lock, ops and ref members, which are
> all located past the end of the mlx5_ib_dm_icm allocation, so it locks
> and modifies memory that belongs to other slab objects.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Check the DM type before mapping a MEMIC operation
      https://git.kernel.org/rdma/rdma/c/ea97d0a83f4ed6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

