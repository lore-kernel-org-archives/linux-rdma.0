Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB6548B398
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246507; cv=none; b=Izc1gWq6M7DHwHUZIvLfFmzm0nef6MbKozxtVMxKonc87Q7JCI12RewPU0MPwkwpVJfHw4//KUUw4i+3LAygOf1Ki0Dq7L/JflVbhCjN5xoMILQgtrQpun+MYWZ1jTu/3GCvB2AqdQrHMh5s+pwiFDQLuIKW1Bm/QaBlOzYyykM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246507; c=relaxed/simple;
	bh=LPBFjcuH5gl2EZm+6imRXsX2oQxAd059j+AsMTuPtLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YbuX06owYg8Bm3/SPydbC4xE6tmLzh8+wHV9nhRfL0TRGgVzX2Yur5PEW/7HhcpE/bRzkG0l4KgpPR1wwIbHmSf/0fl9LlAvxZoC+iJf4fWuzSi1OhXkiWxlIPH0KQXmLsp3cpVuWBpWHvjKKIt5FTU3/xIH2Ruw1RytiFD4SHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HD5eSqLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HD5eSqLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD591F00898;
	Thu, 24 Sep 2026 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246505;
	bh=aJ8/wtUOBFN6knTGT3pp29ygfyLLrCWIYJYugzMG1To=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HD5eSqLCtnX4GazU0Y/F450Ih9qBA+GxgM6ZWGqweiwYGvZ7DywlvC3L0h1lpMc6v
	 GmPiMPJA5NsH+0k3q8rgqS/F2hjZuNZi1a4nzleP+KzZwm9MFSdxXomPHytiyU2jJe
	 7Fvzxe58yYxvF4jk+JwuMhx2hY1u5rXg+QJ89J7WE30VU2ycsm4PjtDBxBfY+MmRb3
	 xiqPsBJ7EmobJ4Ir33bpeg5/lIQcJYDhnE5DPBIs0ZdFQnWScNfuBlF++r/YL5jAkn
	 tqdRQ/sBBh3b/Z+Iv7Q0vy/69WoXy73YbYaUCrr6Qp16t7FSWTQNAKmskYulohEFKC
	 fA6MHYRg/SZTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 07/13] net/mlx5e: TC, anchor peer-flow reverse
 index on the duplicated flow
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-8-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:44 +0000
Message-Id: <20260924104145.5DD591F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> A TC eswitch flow offloaded to a shared FDB is duplicated onto every
> peer eswitch. Besides the forward list of duplicates on the origin flow
> (mlx5e_tc_flow.peer_flows), the eswitch keeps a reverse index,
> esw->offloads.peer_flows[], an array of per-peer list heads keyed by the
> peer's LAG sequence number, used to tear down a peer's duplicates when
> it is removed.
>=20
> That reverse index was anchored on the origin: since one origin can have
> a duplicate on every peer, the origin carried per-peer storage sized to
> the max port count - a peer[MLX5_MAX_PORTS] array of list nodes plus a
> peer_used bitmap - and each duplicate stored its peer_index.
>=20
> Anchor it on the duplicate instead, which belongs to a single peer. Give
> each flow one list node, mlx5e_tc_flow.peer, and place the duplicate -
> not the origin - on its peer's list through it; add a peer_orig back-ref
> so del can reach the origin from the duplicate. One node then replaces
> the origin's per-peer array, and del unlinks the duplicate directly, so
> peer[], peer_used and peer_index are dropped.
>=20
> The per-peer list heads remain the fixed esw->offloads.peer_flows[]
> array keyed by the LAG sequence number - that array is replaced in the
> next patch.  No functional change.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D7

