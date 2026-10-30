Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336022;
	b=3WR4tP5T8dLRPPGs8/zGE19anPHV1PpS+vdbjHqE+VNuznr3+XdqleWq+wQC4qjuqMyR
	 M6HMgwIGUQwanGtdPZiCAVgHwMwmm/kLAShy9WtEvUr5PJ6WWi2r1Z++eFgEs0fSvZq05
	 eohN6N31lb3fvUXxDFM3XD2+QRITWkCFHnaVxaBBxnrJprHFqvlN4Yj+l5ieXaJYaQWy3
	 Ez90P5cWRi3Y5Mw7ePRVCx/OyP5FbIP+tEaHH8TBC5y9B0b9Bdg8SH0ZXFyJynNYVbVtQ
	 4BpDZzFjaTcmpu74/TBcUsjQVQ088aWBbWHY9WeSSrAHjGf6fNrFdrEmMVy9P4P6A/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kPFIqn26WX/ISJEWVQwCiiU3KwgL7jWNf6784drAlLI=;
	b=wVH4vEkMUSCulJiIXgK7XjOGbDrhA6/MAi4axKenjAgjtKzmfaOgf4y3vG6EiEcPI46v
	 68WeH8y257rIoBrlIRHovSXX02OF57pfTZf0AvgfOYAmt6Hm3H7kY6js142mwwZCQQSp6
	 SRqW4Y/E9KA+o0iWSXtMRQirtChlrMLpEz6l5FlQw3eBFvn4Lqu9TMkHFyR3Djr0IkXNq
	 2IJGoNB0jpaUlHfweoleqNFOLdtM9SQSQmI5wVmDU2MkjBOV790QL1/cuD/ZEaFHlOgoa
	 Sfdiwz0E0tvZ4jjvsremI1bOsmweb2dqgYfsQHko8y+pvygZDwMvGRUB9aUDRrFtlVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlFT6O88;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED6C606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlFT6O88
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4171F0093A;
	Fri, 30 Oct 2026 04:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336021;
	bh=kPFIqn26WX/ISJEWVQwCiiU3KwgL7jWNf6784drAlLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YlFT6O88rRM7+SD3790IM6WXlClWj3Bsh68yZzvnTIhp+Z7txNDR/0HUYhgVfQckv
	 fg53ABlMxI61QJiVqL9nHFkVcLTb1RB84ZN+efMzZRKXI4fBnwoXxjOp/glDw0d7lw
	 ivR2IktNYZlAhGH8bOc0/btLqbc/gwHPslQfbSJdhblffOUwxycxKVumGZStOlRvlw
	 eI/gV8Z+qlsbuOhsLYFqSlAjY490b7DeEyhFgH3kdqlJL0lReDAg0XHcR7WLGhxMgl
	 5+PAcn5IcfCeBjAxWb4IncVSwDpr27wp3Ne0DlW6AYi2l3YHMI2synICQbJoyKH7eH
	 z8o6aeZtMhZDg==
Message-ID: <sashiko-outbox-190337@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Remove unused host_sf_enable
 field
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428053851.220089-4-tariqt@nvidia.com>
References: <20260428053851.220089-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Moshe Shemesh <moshe@nvidia.com>
>=20
> Drop the unused host_sf_enable array from
> mlx5_ifc_query_esw_functions_out_bits layout. This field has been
> deprecated in firmware and is not referenced by the mlx5 driver, so it
> can be safely removed.
>=20
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428053851.2200=
89-1-tariqt@nvidia.com?part=3D3

