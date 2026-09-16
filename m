Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F117A448CF7
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 23:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599650; cv=none; b=BPLn5DsCn2uvto4yoy16zAEi1IswiO5D7+ghO8Qs2qQOLordyQrDZGEuQxvnl7gyM7ACIFix7drUW9i+KXLlBsXXnsz6dghpcbZHZrtvXKYTqxVQauJO6gKDf3gSEsvjJheLdTLtwZy8pvk47aVtOO8Hk83LcsVR5Xcp5JQ4ORo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599650; c=relaxed/simple;
	bh=OlRlXDPihgeilzQjH/thgoXEOm4MHx/nA/5UhnrJ6W4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r63uXJVgFaHgeKZe5fEnQ5RU/Rb+S5WWIEsTKS/fywmz89goNa1c6gCTv8v+N65EtMlCuNX7DIIYqt88du41DCbgiAfNeIMpVp43qCrieCqljJJnhp4iehRAVHNxO3P9hqHCEEEKXmruEMJ2Kf9HzXpROb9QwfAZy2ffbmdIxWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNiK380S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNiK380S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2201F000FF;
	Wed, 16 Sep 2026 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789599641;
	bh=ko6Upv6sauaPoT8WNKhlFhhN415eF2Z5QVhKOGlgGNI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DNiK380SM9MTkzuWj6D7EU5fK0aWGUw++D3l/rUpGJYO430uF3MACEwAeXHTdvmKX
	 VfPb9CvvGU03yWutLjNLK/ZnWF8LGTc6g1ThVOdpF2wtSzsRPhYFDLqi/OWVUcRlcF
	 thG+tDRNG+K+GZLR0zdgWefCPGk1Dz2TKRFsKRvgrucgPxMkXHMPOGn6gbSW2sd1tR
	 COBSaCGNoBCGv2ODoagmHnMSHiY5zUyRaKE1tcfkU9FDEJnaapcGGCwMAK1FO4SRws
	 hmd6mDRJzIhu4gKQ6Bs8jj0R3goDEKqqNzJNUw7DJZ12qHp4JOMcWEAbEHix/NfV4G
	 TVY46BBCfS4Xw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/2] net/mlx5: Bound the command interface drain so
 teardown cannot hang
Reply-To: sashiko-reviews@lists.linux.dev
To: "Danielle Costantino" <dcostantino@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915225941.554568-2-dcostantino@meta.com>
References: <20260915225941.554568-1-dcostantino@meta.com>
 <20260915225941.554568-2-dcostantino@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:00:40 +0000
Message-Id: <20260916230041.2D2201F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_cmd_allowed_opcode() and mlx5_cmd_change_mod() drain the command
> interface before updating a field that every in flight command reads, by
> taking every unit of cmd->vars.sem:
>=20
> 	for (i =3D 0; i < cmd->vars.max_reg_cmds; i++)
> 		down(&cmd->vars.sem);
> 	down(&cmd->vars.pages_sem);
>=20
> Since commit 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once
> got index free") a unit is handed back from cmd_ent_put(), under the
> refcount that reaches zero:
>=20
> 	if (ent->idx >=3D 0) {
> 		cmd_free_index(cmd, ent->idx);
> 		up(ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem);
> [ ... ]
> queue semaphore").
>=20
> Fixes: 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got i=
ndex free")
> Cc: stable@vger.kernel.org
> Signed-off-by: Danielle Costantino <dcostantino@meta.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915225941.5545=
68-1-dcostantino@meta.com?part=3D1

