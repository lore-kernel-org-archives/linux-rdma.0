Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CF548D896
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246514; cv=none; b=tzjR6/clAOe5njKWTAfkqOecdILRhDziS3vu0owVJ1F1NiEHAmvZroB0k9qn4cD9AKA5cKXpdbhdQKc4y/LwjfNMZWcoqo3sFi5WJ8RJthxFdphOnz25N9womltKyssb3NutXymIYKCseJmL5vJ6TKe+9B/7Mo5T9/fjx0YRcE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246514; c=relaxed/simple;
	bh=66VF0MOPS8XjtiGvpNCuSldtqMV92pGViNshxICQmQo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZAXx+V6qMXfXEPf9zpkjRiqfZ9pR5TyZ6g+z88tL+7W3vH0g9RL/1DlPvLNCnA1Ix8ehqgln18f1F/KbPOQTOzaCSSmrd7Van/Dd2Odpso7IU/nNVjQJwyzgAK7HhLeiY+w3cBstkWRo/j9insqRrJbaR0Bbm/DbMg3sHg+5GBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k14a0Bqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k14a0Bqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7D01F008A3;
	Thu, 24 Sep 2026 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246509;
	bh=66VF0MOPS8XjtiGvpNCuSldtqMV92pGViNshxICQmQo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k14a0BqssuTUDtiUhurjyxW3tJf+5J49WhBSpy/v3IXbIgcoxpj8AtXKKmZsT4xmL
	 90YzMFJXFs7fDXg/LfiQaBantaCUWoUMBW8z3y2Etio5b6Sb0TiLMsgexd/pZUorqd
	 NaEZj17uw4r3dfnZKv8/tzKekuexYHLheb6obYjp/XNEtO/AlWf32igf56be+tDZn2
	 5TYpf3B2QuQwTsOitgr7lGMBFtaLfJQFamcCz+M8z6tOFQpKhGuC1AADLwbJZxSDyS
	 9uhE3nVbZhNMk62/OnZ8PVFJjkjh9M7w8AWGOe/S0n+nt8E0izCWuW+FMXi1FFMvCF
	 E06L3t7AWkIfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 13/13] net/mlx5: E-switch, disable host
 functions for a non PF e-switch manager
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-14-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-14-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:49 +0000
Message-Id: <20260924104149.AE7D01F008A3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_esw_host_functions_enabled() only treated host functions as
> disabled for an ECPF manager.
>=20
> To support a non PF acting as an e-switch manager, add a check for a non
> PF e-switch manager that treats host functions as disabled. This will
> avoid allocating a host-PF vport in mlx5_esw_vports_init().
>=20
> With host functions disabled for non PF, its e-switch is the expected
> manager + uplink only.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D13

