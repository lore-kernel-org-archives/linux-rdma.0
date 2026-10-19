Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A294F3900
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417012; cv=none; b=chei90X0xzALDt2LZmSFNRInvuuFR8n30CY7W7SK87zIVsjHHmU+n8i2uQgnYGyTe7LszKCU4vUpY6GCz+EByUcQHoxoh7SFkDL6pUOe2aQ/SFNVb0dnbAuuACrzowv7TNM693/gE1pKhjC8W8VBfJe88nDAO9zcyaa/torNstE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417012; c=relaxed/simple;
	bh=etMv3lGdlh7MmzHHwFEbLn1LB3ZXyV+01vJsLb697Uo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VQng76vVTriFWGzaOvWLWKWfbb0qcT2+1tIYq3MghyJsszfBMxFdmJqZJ7SYq4rNVpSDI7FQKj6mCB3kH8ZBmjxKSOjmWDX7qp5G3n0mp1LUWzebu0x1YKYOMDEV+cPmmx4zzlg2onq+JfpnHFYthjwJJI0Bz44R+5X0+BS8jm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmu0ny8a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmu0ny8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1983B1F000C4;
	Mon, 19 Oct 2026 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417011;
	bh=etMv3lGdlh7MmzHHwFEbLn1LB3ZXyV+01vJsLb697Uo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lmu0ny8a9D0HPHn1jhaTdZ/Kde9GZb5DOGKZPRW4Z/iIN1tITta/ZW2KBNULzHuYR
	 jN6eNRXMX1uuTSn3FB2HEg9wYF4VreuHdO2lPf5p8YdjTyMKA1Aem6aFZSAKxclTil
	 NUSi5eQYN+WJ3RCws2Ojlp/InqXqhHGG0xSdBBxIbf5JHIMUZLeFtxyB7s3sBE+IiM
	 X+AVyNlujfdX4xYaytBhlyJCCnawyZ/rJ37kGbBYNYSbx03+lWtWc9miY6S0p4yojO
	 o+o7mW5dLX3Zw/xF1npktvcghdmuBfoxkpLLWglaPZqD6uCt5QIR/sc017UXDh8ABz
	 TofAB5T5YYpaw==
Message-ID: <sashiko-outbox-177171@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 1/2] net/mlx5: HWS, fix modify header pattern
 compare on big-endian
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019133159.1742411-2-acassen@corp.free.fr>
References: <20261019133159.1742411-1-acassen@corp.free.fr>
 <20261019133159.1742411-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 13:36:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
> compare only its control dword. On big-endian this keeps the data dword
> instead, which HWS clears from the pattern of set and add actions. Two
> such actions writing the same value into different fields then share a
> pattern and the second rule modifies the wrong field.
>=20
> Read the first dword of each action from memory instead. Little-endian
> behavior is unchanged.
>=20
> Discovered by an AI code review agent [1] and confirmed by code
> inspection. Not reproduced for lack of big-endian hardware running HWS.
> Tested for regressions on ConnectX-7 with firmware 28.48.1000 on a
> little-endian host.
>=20
> Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args=
 handling")
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.=
135825-1-acassen%40corp.free.fr [1]
> Reviewed-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019133159.1742=
411-1-acassen@corp.free.fr?part=3D1

