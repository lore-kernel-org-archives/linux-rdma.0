Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64557357CFB
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790421562; cv=none; b=XAr/Px0TC0VhA/xMla8Y8JglyIOrkLJd9XgEp7RgFnk73zzYV4pUMTkKlSTgBLcUKK6MYsph38USq/wp7cXGUaHlUqKxdzsLdKhpnL1JIkwQS9vHcHeyIzezvtlODQ+QQBlUuYVkZnSlPck2hpTW0qulyQDFPrJ+5t7zEPSUowQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790421562; c=relaxed/simple;
	bh=MydCHVrOFkzw7ifN0DSj2OG+smpECWIj7dvWDX33OXk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AbrUaCuq5WVd2HfdEUkdmBANMk6TsQ+h32cZiwubkNQEU7zHeHruTUVgaRUHTeW7l5VrS56GxtEDGsQPdhbVcMgHVNLGo4LYITdvn9OKzKIM7sx4CJ4z4SCZvG5oZSvCs9+hc6ogHYtAP7NRUTCSi8jKvWVKpi/87h5UN1N4oCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKbyQ/qW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKbyQ/qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37C21F000FF;
	Sat, 26 Sep 2026 11:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790421560;
	bh=MydCHVrOFkzw7ifN0DSj2OG+smpECWIj7dvWDX33OXk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RKbyQ/qW5uTCfMGi/x7BmAPa5KbrmV8gd7Yf7IaVB2RwV3cPBNeaNUt5qqSjnnDum
	 wthPcfx967qeB9BrtAg8nIr8n9WL/dOXhlFpGyrwep+LmWktKUFgi+qhUFtHhCE5nD
	 akJS1YcXFlCV7IKAv2XhNtqvxH3gleJnojjlv8UML+c7pJe0YldVDNd0TQ38TupkG2
	 grEeR3c6Pg/4Zp41nXU1nhL/I8BxromlMOPlgCAdxQN7C/GSIKb8O07IZMyJt7lLdb
	 EWeRxxuoFcmyyhml+TRifd3neQtoZkH/lz7PBE439RtQr6tRFAqWHg2ldl2isFT4Vj
	 fHNYHg2at/dlw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx4: Do not allow the user to write to the clock
 page
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260926111150.3197004-1-yaojiale02@163.com>
References: <20260926111150.3197004-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 11:19:20 +0000
Message-Id: <20260926111920.B37C21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx4_ib_mmap() maps the internal clock page to userspace through
> rdma_user_mmap_io(), which does not restrict write access. Userspace can
> request PROT_WRITE directly, or upgrade a read-only mapping later with
> mprotect() because VM_MAYWRITE remains set.
>=20
> Reject VM_WRITE and clear VM_MAYWRITE, applying the same read-only policy
> as commit c660133c339f ("RDMA/mlx5: Do not allow the user to write to the
> clock page"). The rdma-core mlx4 provider requests this mapping with
> PROT_READ, so its existing behavior is unchanged.
>=20
> Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926111150.3197=
004-1-yaojiale02@163.com?part=3D1

