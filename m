Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7CE449B2B
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552665; cv=none; b=IpjxJcEqfzOnNlbc6cW1OjIBqjBa6fbwDzRokh5uwPmqjE5rfpdhn8sX8u7xqwPdny/T8JRLDbciC3Q7JTQwO8rbonf/Cb2c2gMGwrabF4gV14g66th2m+w8eid8mRqJmgT0rON9VeqtJWaPoDp6c7+lWOFBpLNTm/EWumTKpys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552665; c=relaxed/simple;
	bh=zkwTIA4PZlPWG8UAn7pxa20hdKQMHA5S38p/hbLKLYs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=MIhPsJg0Q6QpxlXbvJpmPdaL/9KhvOsWVU/L4rRZ6qvfWtAN8FM3azyTqGLbyBATTE/NyvR7fmvkQgslQ/mBO0vFQ+47OqHefPi/ZS3HG6AZOQTWkXSjqcMaaO41m5OjS76sxM+cdDU9ufYsAIIVw+IF5nVlNNesHmBGdSghhj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beSB+pSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beSB+pSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADBA1F000FF;
	Fri,  9 Oct 2026 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552664;
	bh=zkwTIA4PZlPWG8UAn7pxa20hdKQMHA5S38p/hbLKLYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=beSB+pSURY40aA7zbPfFlaGuXABosRm9tiXJesZWasCt6frxEfwBwUcQibE+PQyVZ
	 hVtZXMGDy4CBi9mA6LWKwfOQbmZRW67bVnNn/kwRdk/qJ1eos0krm/hQbd+ddhCx/G
	 xHeyVW6y+ivQxTmAcY/AlUo1XeXXo4i0h24Ah3xlqL6k1YUlnSVCP+eX/tNnGGNty7
	 e1b9gAS5nmYjnx8Q+8k6pZtGjbZHMjCcKztqsBp3iEjibv0GvP3+4KSFKeCScpHimM
	 jzW67IdpX86wU4XAUcDntgH5NY933L0uARat8YnDQj1PvG4AasDyzLy8O4nZu+Q7He
	 Ny78UJ8gCc7Yw==
Message-ID: <sashiko-outbox-165638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 04/10] net/mlx5e: Add data direct ethtool
 private flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-5-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> This patch adds the data direct private flag infrastructure.
> The MLX5E_PFLAG_DATA_DIRECT flag is needed in the follow-up patches to
> detect the configuration of data direct from the user side.
>=20
> For now the flag can't be actually set. This will be implemented in a
> follow-up patch once all pieces are put together.
>=20
> This patch doesn't introduce any functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D4

