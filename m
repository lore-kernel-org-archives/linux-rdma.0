Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873721;
	b=CceR3SpCMeLCvQ0IvfCPC7EU7Sy5/nh8k2ywuxvTPvHjtnwzfEbSmObUvIkBDrwaPxiq
	 c8EmKoiGf86Dh78y5Qteg1Jfd9o2yLujYqGphSAVnoIdP9i/Oukl5FWvPRzQxbiQoYpfD
	 GbKceE0JPKdkSUMaZDkPNykOG9Cxv7waZyJAwpFRuIhyj+kurAf42xhQZL1px92ozehb7
	 TCmD/BUA9DEUWZxvY0p1doSHEyOIb4DjR9qyuUt/x82gnR2N6fXCHnD7nNsRDXgxEHMr5
	 JN07gd5xhMunYTvtPwn3UgOkN+rBDBGIfvzAnwJRQ0tg5FL9vYAZNRLSffMQUSve0Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873721;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R657cRqa3j7WuKNmLK/s+7XgK/pfH4UcMsfbDhKrQJQ=;
	b=Cqu8IiSEu7Oyk8qSs0R/XEA40I0mImOq4D63o4dx1u59bqh3RZTG0//0w4Zzhj/p3ZIZ
	 TXYv3We4dBT8u7E9mgDYvcnxX3Pz/iqi+IYto44X35WqWvTdwzzfOGUjDUA2Fm9P3t8l8
	 ApHFlEy0EuDSt37D2Pn+9Rl8gxttyiDNa7F7OP9aX45S0k2NdKcwIe2Y5zksC+l1QcRBc
	 Z/kzAdbAw8DtEqKlzznvdESQwa8bhdWNHViTDvT8ggfKWp+QbUAaz1dMtkDP0i8V2rfqY
	 5in7BbndDMGCmZACQrNhIZNe2WFxjrgFSTauSGa8olBDdhPSCjiqPjkS1vO9AGjRl9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVHJseRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF290606A329;
	Thu,  5 Nov 2026 10:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVHJseRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EE51F000C1;
	Thu,  5 Nov 2026 10:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873720;
	bh=R657cRqa3j7WuKNmLK/s+7XgK/pfH4UcMsfbDhKrQJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PVHJseRsp4CRRJnQlS9bIHhQcZDkPEWzATzaUq5mrUxTqor/JCM5TvghEe9+pd7WA
	 5QhFTitPMrPLX7lerl+QMpxpVaCixt/3rYIz9HjrbQGYIXqgjRQF5NhOx2twf8qkIW
	 Lj+YFF4kmOydHDGsERAtTjIPuSuEPIHorB0REf8DPm1OSv0MfqwtasJWTYEORUwWYP
	 fZDQsDDbyCC69WNFjqC2bZ5u77UX8NiRxAFzhcyoapEBoUZKax/w7RNT+4ZADUXq7S
	 dX8AYAF+R7lH3Hn8F+TpkAeqHH6LBIYBNkM+j31zaPNucnwAtJLFq3tHJ1BKye3jWY
	 PXFbLp1Gk8N1Q==
Message-ID: <sashiko-outbox-198827@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 07/19] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-7-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-7-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:15:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() combines ACS reads, routing decisions and
> diagnostics. Adding decisions for different TLP attributes would duplicate
> the walk or thread each attribute through its counters.
>=20
> Collect the divergence controls, internal-route restrictions and upstream
> forwarding state in struct pci_p2pdma_acs_path, then decide each direction
> from it. Check shared forwarding ports only when a host route is needed,
> and keep forwarding read failures separate so they do not suppress
> redirect advice.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D7

