Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727666;
	b=B8Zwjq+Bih7na2xZZpYH6kSaUZcaBsngRKos7mbSZ6Sk1e+Hxma/wYb6evDmyR/PHC31
	 ZOPYM9Ex+qYeZaYkx6cDTEvTwK6BYp/5lRtq5bLkYlNrb0i5gY/GBX+E1w868rTMHGfZP
	 isqAYHbjuuswpNX0ilMiCdnnA4PwSUSfz16tSpFO4RrYVhVIqLz8oKw+XhKErGZ7sQ+7q
	 50Xri/B/ajSnzgq2vh5HfhWmq3poVl3AyzHrgFP204w66gch31XE4QLcSmwxp2zvKqw4v
	 XruknpWos3eCTnAcMFNwqjtuVNH3W/EBJOy0ERkyZNigiSyO4ieeKc2JeY7YxNMNoSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727666;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/ku9zQZbZlWnGiOe4sDVKzfmLrRQvcm2yDmQg9N43qc=;
	b=qyMZs+Nb9NDy7uIclunAcU3E8zsEDsYLlsWMSBlTcZII/WwpqfAHAQu7Ylck1ElE5+5C
	 YuSMuSF6nSoKbTJJ7+Eg2b8dxQWW0c0RbStZwJFNOp0NcUgquU0fRxSDY2ChrijD0o2EP
	 kCVUGbvn5DJ5gjHXIzLgGXic8AL+xVLKy8matdulcTrSEP212Qlhxk4NRajz0XH4Q4iBh
	 Ui/HNKyUXJ5ZYmCpiS6lx2PgeFqHVFzg518HsNTwPmCYxYj1OcxzdYdMr4KpANuwKve50
	 0HsxudnaB4RnADfQ2YybgQYF1yQnlYhei9Y5+p/0RzzW/4zH8gFcvUL0hBN3wBAszhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NP2J46vC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371B0606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 21:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NP2J46vC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F310A1F00893;
	Thu, 26 Nov 2026 21:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727666;
	bh=/ku9zQZbZlWnGiOe4sDVKzfmLrRQvcm2yDmQg9N43qc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NP2J46vCGEdckrd185P5tj9cuDIx0+KmkxrUFKL6NIPYnuN0d2R68KFwuyim7MrWw
	 3xiZYTM9MffAb4jqVFMqoR8arM5uHs0S3LJOxMDCk3IAnvPhtdN+hOxvX/TnE0NWoe
	 5extk+GHN+h5aNPb9KcaIBWT+bkNKu+1NVH+pKsi666XAB61f7LVis1593ZR9o7e/H
	 TboduwF6t4ZxGQQ0/FiN/67e5vDVyiz1S6DcvjSWyvVDkcl4CdM5AQW/PoZGNNTgko
	 z40zipIBtHWI2muwuduZlzaB+ecnmDG4LoLfP/QkDOAWks47EDupImjEWsCB/zhO7E
	 4a2PFT/Fd//gA==
Message-ID: <sashiko-outbox-236220@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: psp: Fix stack info leak in PSP device
 stats
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126211115.767481-1-tariqt@nvidia.com>
References: <20261126211115.767481-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:14:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5e_psp_get_stats() reads the PSP flow counters into an uninitialized
> on-stack struct. mlx5e_accel_psp_fs_get_stats_fill() ignores the
> mlx5_fc_query() return value, and a failed query, e.g. -ENOLINK when the
> device is in internal error state, leaves the counter fields unset. The
> uninitialized stack values are then reported to user space through the
> PSP get-stats netlink command.
>=20
> Zero-initialize the struct, so the counters of a failed query read 0.
>=20
> Fixes: b1346219e535 ("net/mlx5e: Add PSP stats support for Rx/Tx flows")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126211115.7674=
81-1-tariqt@nvidia.com?part=3D1
