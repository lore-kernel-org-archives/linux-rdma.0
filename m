Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F79A4F93D2
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755157; cv=none; b=KAphqD/p6TspO68F4xc4THAq6LAcrJN+5YCTqg66kgeDqfQmbHZyLJzsxk9R+cVfnhlCqkM0DiHX8m1VxJFzmZ5MMPrkHdOF/2MmbW/CLjb3MkGs5PKRdcWTBU5YxMQIjecn76wfm7dsTJtrQRX4eTsxuSUFNRfgmu/ehpfo1GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755157; c=relaxed/simple;
	bh=Y+uPfHjakqJwJezvnIoQOQDH3q4ik4HT26vWwHCNxc8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bxFTHs2PsJBvHQK62Lp0+hZ7+u3uJ5cgDOiGzxb/cB+4qhaZYl/UiUksYm9SDj3Ht7DhWb9SIENUM20LlmBdPFc5A9aEPp8+6+c2LPdxvQFf412BWP4+zhsNB4CHsN11Vfg3txdWXu+7HauPC3fYjOfORu9k3I2BqGNB6VDCAwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbC6YcMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbC6YcMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1457C1F00899;
	Fri, 18 Sep 2026 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755155;
	bh=Y+uPfHjakqJwJezvnIoQOQDH3q4ik4HT26vWwHCNxc8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GbC6YcMNwNgzPLfKIDfNeeHDYFzqurv+5R3pDN0dEOm9ZwXXzwVrC/82zDxm6y5EK
	 HsaPfRpsD56Hu/hll+Cru60gThShrK++ZZFPFMJSU/Na1kErwaSo2zkX2TZUxO+yI7
	 Fje+1W5ypP684S/7nqXTaK4QFJTmp+vLvsBhL4S4PANXIvuDs9ZUQylGia1Deuotwg
	 f8WFIttiIewjN974GKKEYgHBknOlCWXs668Pz2hhfqVTM0c/gL1e8ZvrM/4mMWotyM
	 0GPpz6rccC8/M2zH9SgdD62nJE69Jg5PP4jeJd3ebKD+jV8b8s1KwponFl4cMgw5ZD
	 xw+W+N3z1Y38A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/7] net/mlx5e: ipsec: Block eswitch mode changes
 during policy creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-2-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:34 +0000
Message-Id: <20260918181235.1457C1F00899@smtp.kernel.org>
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
> 3. Another uplink IPsec policy using the same RX tables is added.
>=20
> Before this change, the 3rd rule would reuse an existing RX/TX table
> from 1 and would avoid an mlx5_eswitch_block_mode() check in
> rx_get()/tx_get(). After this change, the temporary mode block added
> would reject the 3rd rule because esw->user_count > 0.
>=20
> To avoid that, I was forced to separate the mode blocking from the TC
> check by introducing a check_users argument to
> mlx5_eswitch_block_mode().
>=20
> Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D1

