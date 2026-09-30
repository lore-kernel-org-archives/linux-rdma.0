Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90713B19C6
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 12:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771151; cv=none; b=EmJqnZ5qbuJExrZqnqiZz9DFiJIRMpZyGtbD2Y6B8dNr1KsDqo82ZcXPzDQzBTALB5keDfIrUqTeeSLT6bf1dq6oGDnzFCs6l4oGYybhekU4hHp1EbLAbrInyFAgs1SSY8/T6QmeOmI85y9iMfc0iCQt+knkn62Qoneo9jLhOnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771151; c=relaxed/simple;
	bh=6t+1fju1QcCn/QzBCtxih2PXY8NhAnL5DdIut+qiYKM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E7IdyIdI5BZD9lEa42MbebSPiNfwGJVUHrXdNkHhZG28aRMkcWQRxbw31pZKS3MuMA3DRHI5bm7jysoHNgmZQxcS+L1oPiP31+2pQnCHTxNX5oWFZskbiBFeR734C+f/S9q5UwL/KCXuRyb9yE869evzJ2s4uzUm5jx3+DnuMCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgcPDxvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgcPDxvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738671F000FF;
	Wed, 30 Sep 2026 12:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771150;
	bh=6t+1fju1QcCn/QzBCtxih2PXY8NhAnL5DdIut+qiYKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VgcPDxvfNFlaUKVRnF2ClmqIQQBmONK7STNZz6SQqfAcHpF0Bwry5ATd/25U2K3Ia
	 +C+sPC0LlYU7X0YGqbJB3jK9MvIfStArSf7n7NZWPFcd1qvAP1SwbVul3q1SnY/qpf
	 vcoXW8dTlO1NDobGlbhBSJ1isTerkKRKfhW2byY5puY4srsPoo2/lFqZkhFPoAMjlB
	 TQ/u1j6FVpi+jTfmsWoYs7lMuCS+/fVU1srTvzAU7w5VIPKbtfoQkVwVTtphX1KxL2
	 1x3veMnQPBX2Eo1E/hM2j1i8HEnCcjygGeuj7Z002XlrugdQxFLcz4rEPRwTOF6dXx
	 XmlK+0Q70ZMbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 1/4] net/mlx5e: ipsec: Block eswitch mode changes
 during policy creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930121119.141953-2-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
 <20260930121119.141953-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 12:25:49 +0000
Message-Id: <20260930122550.738671F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Eswitch mode changes can tear down the IPsec context while policy
> creation is accessing it. The mode-blocking reference acquired when
> creating a flow table comes too late: the table lookup already accesses
> the IPsec context before taking that reference.
>=20
> Block mode changes before checking the IPsec context and validating the
> policy. Release the temporary reference after successful setup, when the
> flow table holds its own reference, or after unwinding on failure.
>=20
> Unfortunately, simply using mlx5_eswitch_block_mode() for this would
> introduce a regression where:
> 1. An offloaded inbound IPsec policy is added on the uplink.
> 2. A TC flower rule is added on a VF representor.
> [ ... ]
>=20
> Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930121119.1419=
53-1-tariqt@nvidia.com?part=3D1

