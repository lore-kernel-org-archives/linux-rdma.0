Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812424;
	b=w5vVzq5JyKuv8OfnCXyvbe9+ub38gliGo08vPTUqBeEJTcZyXaGMgAPQHlvCMqO69SAZ
	 r9VLUQaGhzWeHhtyFQec7AbRXoOjh6QLpdAoeBm1gSqkOXEk6q5l6vhLJ0cc/Crqy7KS8
	 IDd8dsbbPFenWY2omoWFLOu4ANshZcnBbUkEHMFP5Vzp6Sd4slZmxoLAcdcHfd9jKdXVJ
	 O4kTZh50p9wZgB18I3Y5oa84ZP8E5KVHVFNmBE4YvoB8trftXQ1UILyZwKQb3fYTgQXpb
	 FGJ1Ut8g4nd3sC2e3pltnvkZAOxYyTTAhv4Ibh7wJRPjbHDe1LjUJrzD9oF8FW2fwYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812424;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3luBs8luGLhg0Ns1HJhG/gb0WsABhKtR6YRW8CuwgOQ=;
	b=IZEv1PvhdcvRT7PLstIiTZwNRlH+cg9Pa+EQ5AgJYOnjI9VTCw/wF4mBzQntItUiMbV4
	 bGLqiKos+ongmdP4fZXGjI7XIkf51fGncst24xFa5gxGDiwvfQ5LdGHZCIkCwDQFRYQ82
	 2eUoK5I5uhn6wrNhBIX4Eumwi41nwYXcdImXw/Q+2jRMIKxplGTco9M3Cu/gYJuU8a9cH
	 ddgh6A2BxN2LJby8Ppfqiy4AqQFqcsryvK6ALyzGsHHD4VDbUd6GwMd/8IvSoy2CL1y6p
	 MaM6ibIF/tg+q4N4Bw4ntbh7WJpRd200FaOtncbIXYenYhVWNM2ROEjZ/wEQ0XD2rgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D75tLzxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5821B606A32D
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D75tLzxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CA31F00919;
	Wed,  4 Nov 2026 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812423;
	bh=3luBs8luGLhg0Ns1HJhG/gb0WsABhKtR6YRW8CuwgOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D75tLzxFc7METK/k2yD1FLn0M5IvDbetcrt3nB0XDvA6XrPNkVl2iXO5B7w/iSFfH
	 RAEGbKZ9NOD1XaQ1pDqMY7GT+iFe5PaSZ0zZIMKf0ip4gNRRGjBopvfJo5guzxx17Y
	 HxBZajwL5XNS/K/fjhuuLY/g6e0Rnr4yP+6HGDpS44So/WPdh7bxJ50rZ3UBwHfNjd
	 0JAmHdXcce3qu1i8xpvwgXUzSv9Qo4N3MZ6h2pqwPuB0fVE7EzJHI69zeM1/+KNwe7
	 nSM4WhYM1a0MFHipSh4dXmzhzsLHEx5h4dxbwmbJav5Db3lyhHDH0KMR5X6yxrE7CT
	 ZocGZBuZQtMBg==
Message-ID: <sashiko-outbox-197728@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 01/15] net/mlx5: Distinguish VFs/SFs in the SW
 system image GUID for LAG grouping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-2-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_query_nic_sw_system_image_guid() builds the key used to group
> devices that may form a LAG. A PF and its VFs/SFs share the same FW
> system image GUID, so without a discriminator a VF/SF that can join a
> virt LAG would be grouped with its PF.
>=20
> Appending bare discriminator bytes at conditional offsets is not enough:
> distinct capability sets can collapse to the same key (a PF ending in a
> load_balance byte of 0x01 vs a VF whose marker is 0x01). Give each
> discriminator a fixed position instead, and add the VF and SF as such
> fields. Trailing zero fields are trimmed, so keys of devices that set
> none of the new fields are unchanged.
>=20
> Set the VF/SF markers only when mlx5_virt_lag_is_supported(). The same
> key also backs mlx5_same_hw_devs(), so a VF/SF that cannot join a virt
> LAG keeps its current key and is still identified as the same HW as its
> PF.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D1

