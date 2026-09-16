Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B634E80C0
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557647; cv=none; b=JqkvaQV056VY8Dil9UtdYWHkM4MAI+NcBYVPENci6CSOg+eXSL5buotNCz1raFawBbjmRCXasXyLjA2MP1sR7uU/WoWxGSJMt4O2GVoAn4Tllxq+ly/38bew8WQ3H6c8jFJdfEXcr1nkhtDMDKYH8kVNUxlmkuqxnAXGxorsXaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557647; c=relaxed/simple;
	bh=5/7l55s2Zhs5bIHeYLdinyGXyI/dm+rkM+ESPjQMVZs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C0cA61nPEZ/kDAHH9UigyEh5+6yvwXfDDLN5nlfzBdx5n3TI+wKwXGwQdgYZQyd2GNQXBHx3iwbQN6lYqIzBEJcE4gWzT5BUUn6gG2fDv0m90X9cgwZDRwiZ8slaZ31rlT/Q8w4Q+hwCrWpaGVgZaNhtia8KuAFvhqjPx7HrJ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kG6WkNHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kG6WkNHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6AD1F0089A;
	Wed, 16 Sep 2026 11:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557630;
	bh=5/7l55s2Zhs5bIHeYLdinyGXyI/dm+rkM+ESPjQMVZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kG6WkNHR1dUMsLACcohQ8uMTd216CnsDSUE7z+JSwRszqPC0Qi1bgcmKfkBzgVX/z
	 PR7y9w4S+/Q+0GpiUK26MXrox5dmTMNj2UqtofxX91jiSBgUYCHBuhtYKaLav6qtOF
	 UBeUZZHNZkP6KMdSU91R9zNQonYp/+ivf8Cpm/cXJIPwxWtL9K3Ba7Y8IGHdnb0Dud
	 qJWqKt8boxvJBh6lfHuwUC3co8DzFHawG+xt3tVXfPQk21HTzyuCPTiLSdURJR6QU0
	 muEbCHLaEPFvMNGa5Xf1yKxVw1ysQcg1FJvceEsrJzQBJrZTyG/zlm4TBHsBghHcNT
	 I1MrzapM6J08A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/6] net/mlx5: HWS, Replace kzalloc with
 kzalloc_obj
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915111912.3926585-4-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
 <20260915111912.3926585-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 11:20:30 +0000
Message-Id: <20260916112030.BB6AD1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> Replace kzalloc with the newer kzalloc_obj allocation function.
>=20
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915111912.3926=
585-1-tariqt@nvidia.com?part=3D3

