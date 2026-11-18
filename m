Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023715;
	b=H1YLyH5iiUaoblgEjnNtMkb0fNalYSxvnZ+XYOopK3IVv6wRU5ie9+iPLt5t9W0vUHWU
	 mEIMbjdPDvwF5WhzCS6uP1WS88YvGk94ueKRu9ibsA1Jixgq4IZ4puG0G2A9K3Gp31xZV
	 7vsz5DPN0h56IjHocCyOBeR7BLWL90QBEd40BNu8GMNaPtTmj//yiuVshBkJWs+zbKLbM
	 w6/qPuU71Raz6q/mGJrkEZb1pdV/PbqAj/wiqxFsmsbP3QCtd96rHIUpt2ln0heO46j5L
	 cbDbmBRh4uMMw/a6Q8Gk2uN7LgEfRTORehZyxmRdLc0rvR0tnTiadjUCJ6/NIZihTZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023715;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sySt1xBOdSh4NZAkJO/VXC52CEk8Y8WdM83sFijaq+o=;
	b=Taq+/8cWmzgaMyjGODhvCMNPULnFssKGeqFNs8n/s1k34KW7GHDNb63LAXtfyD8bvMga
	 JJ5kZRCfuNg4EnbOeExFkAgZrdwVfdUI+dISkec/E3Un8r0FLuy4CE2bgaad/7XTHbs8M
	 mNell0Djne/eXBPCusXTGdXGHRBVMchsIi4Z3p1a3xEFPj0z0s7TBp8Nik6ouGojolpyd
	 k4iF1Q1DLb30Jsm00lgzRLE+R0JaXtksBn/NvTz9Ec/38pmuz7hrhid/vT+U9uWHks+5Y
	 2QdvyDk6Gk95FTJSqkSWSD0k0hyxlcyYtesfVNMAmTtrhSDuE8NWx75RtdaQgkT7uFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WELKyQOA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E424606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WELKyQOA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB0C1F000C5;
	Wed, 18 Nov 2026 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795023715;
	bh=sySt1xBOdSh4NZAkJO/VXC52CEk8Y8WdM83sFijaq+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WELKyQOAVXRAWDTm9f7TDy7A2+ddm0FzIe2tWqIiYipuslvPOJjZK1jFGt7x3JD5Z
	 nKRkJZ3c31UVghmCKCOQwnH/aE5GgXap+wLjmxoQx/ATeBSLBa8t18hH3xO5bsbqV3
	 vAPaKksl4JYJWdnMMTW0T6XC9hl8+2XR13ImwDytn/ouR6KASJl/0WYr2tujT6FCHS
	 JzRzc+K3v0hU5+uKX/cPpzddJFgCJfW/oMI/QuZ4mepi7WIzqSLeOMC8m5s43QK4ce
	 eAW7xhO9Ia2K0wMBRDFZlaLzX1M1R6NsGRQIm3zRdt96oursUIkMiW6svAUJPQw3Ma
	 KkCL7++Ofvzng==
Message-ID: <sashiko-outbox-221676@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 1/2] net/mlx5: HWS, Handle NULL in vport
 destination action creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118173227.1957670-2-tariqt@nvidia.com>
References: <20261118173227.1957670-1-tariqt@nvidia.com>
 <20261118173227.1957670-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:41:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> mlx5hws_action_create_dest_vport() can return NULL. If this
> happens, xa_insert() will insert a NULL entry into the xarray.
> The next mlx5hws_action_create_dest_vport() failure will try to
> insert NULL again, but xa_insert() will return -EBUSY, because
> we already have NULL entry. In such case the code will go into
> error flow of action creation, and eventually will cause NULL
> dereference at hws_action_destroy_hws().
>=20
> The issue was discovered by code inspection.
>=20
> Fixes: 8e2e08a6d1e0 ("net/mlx5: fs, add support for dest vport HWS action=
")
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Alex Vesker <valex@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118173227.1957=
670-1-tariqt@nvidia.com?part=3D1

