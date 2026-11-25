Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593025;
	b=G2uR+XhWyY7MLEH9FQuZN2A/aHIMyQaUyjLZfQqNeSXaw3DotifPscM+q7Y5tL2vHYzw
	 lrrV68gRNbDneuBDzpzXBc/A5d+rL7p4tpbzJRrzcltZOWw9nXUVF1w7djoMgrI/y18PZ
	 xdixqrbVFOOdkJYZZfAZ2DtOuM2vM93vJy0GCZtisGDOZtXC/Cz3CBSSyVq/QLW8+xUIu
	 siso5D3jx6if4KicF9j7JTA16JwGZ2bsdB5YPY13ap0MsTD3lez86RQnGZpa6bGFwDPcm
	 TR+exs2g1wOnPT7HsfAvEgSHyM+zmpBgEn0Jl+4dSyTdGkQTakfj9/0w8XKESOim6Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f16qkDKqpDI7HrX/ZGk63gKimzPg3ro1vWf9717ecSw=;
	b=ln0NYHlh5jrBVeQtOduy4xrItO6b4JTgrglWeoFsNo4ic9v1e0AWOVD3HrkRuhmIL98O
	 mbRCWnPfJqUp84V2asVQ+i6CHUbSiE7qKq9oqLl99V6BD34RjwoCkcTPbFehsbI5jW8fL
	 u2BCKGI0LvUMVUpYwZTfe/Gfea7AEDWTYe7s8IIBap8qlSMaBJRF7DLDu7ys+T8E3oLm8
	 N1EGZngp8Pm1asS7gG7emBruGgYlT3vfNvDLJXF8JwH3q3bkMnOZbTNATtAnpDfxlkAmD
	 Zwmu6UGl7yzAm1nIoPs/+3NMkbIRDhAjhZcmhzZEeM+LcBzs04hX8dRNvHDbY85XDCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izuA0Obb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1867606A31E;
	Wed, 25 Nov 2026 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izuA0Obb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5573D1F000D0;
	Wed, 25 Nov 2026 07:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593025;
	bh=f16qkDKqpDI7HrX/ZGk63gKimzPg3ro1vWf9717ecSw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izuA0ObbMt4avcyFAJQk0PWKd2ERl3M/WzqTcNEwHffd3X6mJkXnPSnqOOK4KV1xt
	 ebPjuWzY/v6wPXVw6nIbdiWEWNpKHIetRQwBVEYetjxvIacWdKjwKGhqbEKu3CXJ4J
	 K5gIFpB/3CrVSGAyu0NWnMQTM/HDhR5noGGCqX9aEMVCwcELorf/9vDQkd7JFlw74K
	 mG94M/EB2G+9zLrPmxlgU+r08JWPcX7S1QGXE5eKXf0uph61Ht89y1c1CaPm+Mxhpx
	 dFrGV5sJW4INSWmvLfRwNl+iwAGn7bhyX4p/3ffPABDbNqV5FZCC8sh/FqzfYg1X90
	 leG0NpsPj58kg==
Message-ID: <sashiko-outbox-232837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 0/3] net/smc: fix clcsock lifetime vs
 asynchronous paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
References: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:50:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 3-patch series:

- Patches 2 and 3: no issues found.
- Patch 1 ("net/smc: keep clcsock until socket release"): 1 potential
  issue (1 Low)

A detailed review has been sent as a separate reply to patch 1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124074927.3622=
245-1-mjambigi@linux.ibm.com
