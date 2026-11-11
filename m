Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404807;
	b=K+ZcKTWSbN+VVqU1TEv8BzBFBL3QQvDVoPoakV/hW2ASkRS8w+n8/r4smqPaN88HYG8o
	 FlM9U9JOPw/vgmDzPAPCLSB39X5xOk1WerfiR6iDH3nyRq8v8LKTDOrpeptx4lfTag3Ea
	 OXRGRHkjwEREGYUhSZ7Pqjm5F7DaDIZIIpMZ5uOGmI76kwb1JvZO/bg65yF+4mHtS6mXv
	 bEQFDpQSfjL4x2aTYZgylvJNP0nImHqMDPrQph2WmpbcnuQ4OR8As4xfAaj0PAGgs4rBp
	 492H68dtWYaKDRwRU3qQ+WoD0NTzRKLNGyVgT3QMvzPojIiwiTxcBQ0Z6S6sqhEG1GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=np4we2pFrpkrk9GEFn4vEA6C2IfqVicr1YnCH6/sFC0=;
	b=KzFywsjod1O5WXg6nTuHMRFqFwedsEx9LumLorhHJsqW91H3AEEfCZwsC+BAiDQ1iHZA
	 4Zm7FSkI0fCPN8g4JIS6xcDBF4kQkTYIe7j1b9tOk3XdFP40EEyj2yaoQIC19V4WaHCRA
	 0k8zkuk5KNT5fdSzxxlV0YHciFI9CrXYdfIA4+EICn/FMud80H76i6Z+gRqHGU7X+zrSO
	 1MrrTjbc9oOQYOa1Wp5KynLkEKQKhGpYwMWUR0vEh2Nm3AsOxhtMO9uaa17Wdon9G2YI8
	 zCqVpcQTiYBktwConDtL647eX7jMG17vbeB+j7zpR2pOZd+oQhNBvYhWL286xTHgZQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFUMKKnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F093D606A338
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFUMKKnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A527D1F00A06;
	Wed, 11 Nov 2026 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404806;
	bh=np4we2pFrpkrk9GEFn4vEA6C2IfqVicr1YnCH6/sFC0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FFUMKKnwUcmXyK5IdllV8oR1sHYXA7iGwMXZ7vbGsWmG054tUkgyUG4kPPBS5+d7b
	 wt1sNaQUUhX40VeQRYu+eyAJAcJqnjTU2ingSt3iaM1eN/ju230WDZ+EuIt1VmckS2
	 UQEmFCNeJttOhaFaP3BVeaspBZMzo9vtiRaG5TyzJAywpwtRVZJxLjzY8F5c2hEVkJ
	 WjvDicm4aVd8R0AaQVOOsV+k/Yu7iwoOwPh3NX9TTFT0ID3UV+OqsAEblZUZPxWvHY
	 gDjJQZHSoDdc3O3LpaIheWqbd/69I6eGYWm/leP3SwSJxUmgdq9pgacGgKFNGb1wD3
	 dnHXgHKvA3kvw==
Message-ID: <sashiko-outbox-209089@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 04/24] net/mlx5: Catch too low max number
 of EQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-5-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-5-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> get_num_eqs() can return a <=3D 0 value when an adversarial FW reports
> such a value of EQs <=3D MLX5_MAX_ASYNC_EQS. Return an error in this case.
>=20
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D4

