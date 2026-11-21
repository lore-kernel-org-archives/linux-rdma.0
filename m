Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795248152;
	b=0dOD92vKCp+sMLDrEv/jVjEXzadKM0oL7xyzLbNWdXqaVT0XeMDZ1M1HaJPSMdgDaV7x
	 Ueu+/j4an4oCyTICC2T/Hu9t8jnV4YMHvOmZJdNE0HD+0TOEdnDTDI3ZQypzGrdSlpBDm
	 L21PJp8j/sQQqJIkgf5ud6CpFmv3RZQLVmQrK5t2Ah8JL3xxa3ohabx2yD5CjhJ2Z+yZP
	 40b/2oiRoQXMEjyBUwnAfLBZukgP68vRngQFTK65ggsuLFez8PEd2ZDJ4Fn/ixNLOqc+n
	 +yLYtpiXP08AK3ggkCdmusjPOoE4o7m7Q9dsmyjehY0ozcBVHwntuf2JY17Fk0UD+sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795248152;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bsR9AUtERwiJwLyDPQ2nfPtzZ3K0hN21UqQQru05kZs=;
	b=viJDSl4C6Ff9Z+CUhT16jDmik1ZeL/cjBJ3lIhIQMovmPexGykgmKcQk0DQyVevfOWYJ
	 atnkBkHlC0DJvOqoOuGzsPy6z0qJkEpwTcfDivg6VquaigcVihgGNVSKVudoKvb+IAodT
	 hU8sqzsR/kJTfIu0YdYZz5kBTXTVsJROEoTAgg9xBPT5kjl6jzPjpsUGf7GDDluCu4B8d
	 oob58/0rVQgT82yw9ulrrHGCwOgYzj4i1ANHLlb7YZeYZqWz/44jH5z2OWEhvJ5pKE+uo
	 R0wgfQZQ+QtjAPo2oM2Jwp/csAix4aJJgN8vPjuHhjjzpdG2cW/dlri6oddEBUOP1Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4S2Pm3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87720606A338
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4S2Pm3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522FD1F000C0;
	Sat, 21 Nov 2026 08:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795248152;
	bh=bsR9AUtERwiJwLyDPQ2nfPtzZ3K0hN21UqQQru05kZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4S2Pm3DuP0Yb7SVHTX86PU3bwWZlLFZTeq/jehZ1MQpTF2ybydKSb2SsnrP7sChI
	 NIASEbpwxeDC8BYKL+XBj+Nmcfv05rN68U9BpvaXHtQrSA0dtjHfnnzr27zuqUD3yB
	 Dgz0uRCfoo9rvb8Pz4xYMfByXIMYVs5Wz3WEcT3UbO6yNLdcf2NX4B4Y49GyLEONBZ
	 aTaztwD0ZaNDwrTq2xiSs4rgmHmV8U/ps+E6ki3VHBIo9n/guoZfrSzTSmTmd94wsB
	 F5piMfv6TSe0y7AIpYa4SpdMr9s9xfGKeZQtjb383YhDELkWaO3KabGC+73ChozhkX
	 ZiYNJGecsmaNg==
Message-ID: <sashiko-outbox-226817@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 0/5] net/mlx5: LAG over VFs/SFs (virtual
 LAG)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120075959.2533702-1-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:02:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 5-patch series:

- Patches 2 and 3: no issues found.
- Patch 1 ("net/mlx5: E-switch, add match-metadata allocator for..."): 1
  potential issue (1 High)
- Patch 4 ("net/mlx5e: Register eswitch-manager VF/SF self-port..."): 1
  potential issue (1 Low)
- Patch 5 ("net/mlx5: LAG, enable LAG over functions that do not..."): 1
  potential issue (1 Medium)

Detailed reviews have been sent as separate replies to patches 1, 4, and
5.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120075959.2533=
702-1-tariqt@nvidia.com
