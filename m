Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794583657;
	b=5EhcZ4/jNYMX7+b8IfUkiVysHagMBuKchb9ai38IosDntGGvbdjwwT8h624wIB3jn4/S
	 khkx3/tZMjUBMkpu5gF7Y8F6l1FH+lcb4yWqHh1IKJ8Dc5W0P6feQiGCkiH6VMwt4eVU5
	 T3FlGU/73I4o1NZEmIp5AVyUOYwI+2fdjNclA/83DN9ITF6W76HDbo7sBx6TsZaTv9M2i
	 qtjUu5j6T6K7b27oYv7WwggAcg3P2bvWBIGxz/lgTaeFNSursHYhxxfbK5jVup9MtURYP
	 UuUGx3WkBOn4/lSbVKOp59qa67sjydgZpNinHQZ4OktHLa3adFfU02OdVqnH2ARom9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583657;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BBBrdtU2t9dzevLArI+XY8GHtkyeZcaoBH3Pgyu3/FY=;
	b=O+saMqKA3vMSCSnat1aeELo6VFfYTngmAy3tXrFgu8kk77iHVTOIH/eyu0CFaeDSGNQx
	 gJzwufGvp5o1SzsfKikOTHJHTWaGaIP+cKTtslgD+M4YpgeQPfTkdLaHKJ/32+W5g7Edb
	 eZaoPoaReoPKbmrGq5gCdKF2XsPYfI1DmrLUsxqMwk/vNPAcTWeTdaIDbyUSRRU4fmuu/
	 lwcH2rhXuMK5+TcDCH6tetRQcEE3uS1fA/sZ6bf8kWLOQ0QIAfgEtazOX4RjfkK3O1PQB
	 d1g56rmT0JPNlWBYIIbH07amKGBJjtxWKMv+pdkqkPGVJP7MZVmFZyjeY6EHGb3oqcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AWkwufjg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86717606A8AB
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AWkwufjg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B86F1F000C8;
	Fri, 13 Nov 2026 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794583657;
	bh=BBBrdtU2t9dzevLArI+XY8GHtkyeZcaoBH3Pgyu3/FY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AWkwufjg8Nyu95poMsLoPKPT7NNUvngtIml9QML4TODx6RASxTE8we/v1rXR1sXkq
	 3A+fSKFqznPcCBY2nB1H7Qi4rwYpSj/+EoWfFMoxICgoECSMbGFbvkRjMKSm1AnI/B
	 d3jD4WEdNbXMzQ8sIV1sg7xVgGuYV4YcLA1zwj4Wid6kjbZ+I1ApEHcfckekPD/HyH
	 iw5D37nWnVKelidrJbkVuZV+qaa+s2b1KXpce5qbgBQ/lVCWpiivmGUgaReuQniYPN
	 WlEh6o4jiw/HBOsKeqkBfk3VqLea2jseNnCuHY4eRnU8mKxy7Ua8LgRisUQCu8ZSAq
	 ONHd0nQaBnoFQ==
Message-ID: <sashiko-outbox-213088@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: IFC, enlarge active_port field to support
 8 port LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112182940.3655773-1-tariqt@nvidia.com>
References: <20261112182940.3655773-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 15:27:36 +0000
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
> active_port is a bitmask with a bit per LAG port. The cited commit
> enabled 8 port LAG, but active_port remained 4 bits wide.
>=20
> Enlarge active_port to 8 bits, as defined in the PRM.
>=20
> Fixes: e0e6adfe8c20 ("net/mlx5: Enable 8 ports LAG")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112182940.3655=
773-1-tariqt@nvidia.com?part=3D1

