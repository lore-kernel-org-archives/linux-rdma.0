Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC473AAF6B
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936942; cv=none; b=Z7L5ZnM5Kz/rgaKd9QYUhMZ9XtEP1zSvFcTNbMs9mGSRGFflUoOyuOdAG5UAOHkss52OgfzfrtHEOLJFCrWCVYiwyvy0ASVweOcTmv6hzc9Yn5UhtCq9/1QyXl7FuBf6oCUmYqNajgaRgKWkkyUEAgCIekYocJh393RUwOWHin4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936942; c=relaxed/simple;
	bh=1S8fzqqoDLu7BodF3e8HV/DUH5IA9EZs3kkY9GkeZcs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vto8ajdPR8OlveSBvcifuxO/AfY9+4ZLH/gLJgpfIRVYg4fyrhUaG8foiZTtmWu1Nb92UcmT1uuBfF2+0g8cU9VgHieYpA3lmBA0uDauJEE017dE+mBc63UQQhQ3k/NWzg3QOBVa0+q0gSw/RBRLFakNqnyi/M0IUQetos/IRUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ld6VRVOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ld6VRVOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0441F00A3E;
	Wed,  9 Sep 2026 06:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936941;
	bh=1S8fzqqoDLu7BodF3e8HV/DUH5IA9EZs3kkY9GkeZcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ld6VRVOrpQc8I1C6eNarHBENDMvkFDDnu1uF3DmvFIW9+bewc6N7pQEYr6nyLIDHX
	 z85nN7l/49gs62xr20AFcKtko2gaw8MwC5Uzx+IpJBjMvN1i2aXX+2O4MaxYYEKlSM
	 vocfkTxgwxgJsBB9/f4GKYmdv7kM0SwOpB+rKwgckv39EU9RPVFOIR+EQer/N4w/Mh
	 U34UeMPp+irBqIFNAadtqsj8TKT2pZ9P9+kPQ9sGobWG5BQQmdI4cXojnc0th1W+81
	 1J6nLZjXdETYRpcppMhUNJJxIhQvtvLPTfa1Fr8MZOOeW/Syr4bEmStGT3891nQaxt
	 4g4pIPkHwC4Kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 05/14] net/mlx5e: psp: Move RX marker from
 ft_metadata to flow_tag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-6-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:40 +0000
Message-Id: <20260909065540.EE0441F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Move PSP RX marker from ft_metadata (set via modify_hdr action) to
> flow_tag (set via flow_context). This frees ft_metadata for storing
> SPI for future decapsulated PSP packets.
>=20
> All mlx5e accel protos have to move to avoid misinterpreting packets
> with high bits of ft_metadata as IPsec or Macsec. This patch is the
> first step, defining a new header, bit layout and macros.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D5

