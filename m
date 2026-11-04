Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812427;
	b=KpzCorwKY4EzkbBZDZNs0s4bggfkkhMvi8rNwtLArzfQxYVq7poElEzyo6G8EXoxbIvw
	 McwL8fx0wusAQ3hpVvHnap9JBIvsSJOCojLjoOQWYbns+7EOtNWiCu9mjSj4E2ItwYDbV
	 kRPp3I2jp4VO9SvnvmXS3cl3gElqxieKAlRSsuO+M+OBUcnGmqELQh8fOAbuEyyCaFyOA
	 ZV/pBr2AlYSyOC8OdU6Z5p8EY40++hBwfhSNi6FKNNKsq1Ps8jL1mXQ1aQd2b9R8cE6x+
	 aV2bgDcwaPuOOXCdG462oT2LZqKxx9mn/VcV6KEZnF+E8yGplBWLdU23iBcLqnjEERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812427;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7CYg0rujxHq//9Ee5sErBhdY19aW9vvrJFg/kytzZM4=;
	b=wk3gC6YERfPsui7VMAr+LdXgU4rE+eZT3P9imec1Tvqu0jitVuZV3jqbVD1EZgJNtugS
	 KU1XqWCmXyRIyZNPpBYpjBH2P/90u4mvw02agzMVmFNix/j7/Us7t/tYL78o7lfUt4LmX
	 fIjq2S2RL1L/e6FaXEif79MGIysH517dJ3wVkdR1ryKs/e07lb2A3jPosBm8UNtyGOZSE
	 BJWXfaYJQ3lOsW78MYk6MgZDZnJCxSQh+ypMRDtj6ffBFxSOdhDWRFMPeBrlmIgQdZGxW
	 sUOQb5/6r4Xe5wkq1+WeDH7l3fYmsNeeeiYWTxc1UizQpnlvGsba68H6Oid2VaEhVBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFGMAKnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535A6606A335
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFGMAKnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142301F0093A;
	Wed,  4 Nov 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812427;
	bh=7CYg0rujxHq//9Ee5sErBhdY19aW9vvrJFg/kytzZM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FFGMAKnw5R2oJpDVAwrZYYwXAtJBYn4fmtuQR4XV8gPOGZTsHTcEHYaRmm4fll3K5
	 nPY4zC47XvyVpHrZXIJ32TYdXKcGZPfRZch5oo6iPoryM2o5GKSD7phtNuVkRVTG8b
	 bWNzLvPICJ2BgttppHZ8H6YGa8cwpxEyFUgYaqTrT1y8IqvJMeRHN9sKj7oQj9+H2k
	 WFkgjUxcM5XIzCmo8kh8SyM+Y6Tau9FxYE6RWWNnGrO8fDj9HJhqRLOCVBAt27BYw7
	 KZVYrx6XJVqUSgK7L3ZmFtCQ8Fck0rpQoL2TusvfFWV9gcpA/Z74LoiVEQO796KUET
	 UPrqsB2RuT1zw==
Message-ID: <sashiko-outbox-197733@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 06/15] net/mlx5: LAG, rename PF naming to fn
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-7-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:46 +0000
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
> The LAG member bookkeeping is named after physical functions: the xarray
> is ldev->pfs, the lookup helpers are mlx5_lag_pf(),
> mlx5_lag_pf_by_dev(), mlx5_lag_pf_by_dev_idx() and
> mlx5_lag_dev_get_master_pf(), and the local variables holding the result
> are pf.
>=20
> A later patch enables virt LAG, which means LAG members won't always be
> physical functions.
>=20
> Rename the xarray to ldev->fns, the helpers to mlx5_lag_fn*(), and the
> locals to fn, so the naming matches struct lag_fn.
>=20
> No functional change.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D6

