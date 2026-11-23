Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415586;
	b=B2wK8GJO/6QoOFriQivS3WLza/xwRWFad080l5AUmKsvTG2JFXOgPEPhcOPsr4qrvHf9
	 zWMmFLEOlTxDZSTJF4bDXNxY3t296oNl7CS44+d2qVZ9Lkwsreal5hvZyQixIemwjZEfR
	 Nzq+on/NiWnOf2YQG3vUFtIEsmjQ/6e9a2V5ZTqEpm4+xR75TDs7mVBEiFKCESQGenC4M
	 NOtv2NT9+UrXW4HJDDBGdhPuAKAkebwqGuVpmSHjxPPjzSoCbraqnSDH5rQLi8IB7rprn
	 QQpdwyRFl/QT+JHyfbdVULLEtN4k/SXno5y3wUhcTKr+cqZyPvaLmUF0JKCNY3bHN8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415586;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rSPttq3XPC3TbG3AdvPFVWgZtSuXXukuZ8MKd07HXvU=;
	b=at8ViMERyve+dEC+FdJrouTeQar65WRIScFvsO5wP40flJhzwxJyRKBjYmssFBDRC0Lw
	 d5d6a+wOcBq20IWLhWMxx52eFCcjALm0cjx+prwM7AYAaFdyEtPDYMr/hE6AyV8hYJIDk
	 af+PQQKOCGxi9ky8rM3mGdw4cEZeEMu2iys5hqhglfblZ8jyZMZ6xc+Kdn1GoHO1eLu14
	 dT2riVdEg1S1ovdJi/+Me0SNeeeKrf2FKQSnaC413pKRLlks4vZPjiAsXRQqAdR1L8bBd
	 LqYYvNCjSAuCDWXXuqVa4xwCuFYpL0QM0vHSlwJzToDSmF4ecE8bFeV2ZMXUNQmRQfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PR6OgckT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD58606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PR6OgckT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974151F000D0;
	Mon, 23 Nov 2026 06:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795415586;
	bh=rSPttq3XPC3TbG3AdvPFVWgZtSuXXukuZ8MKd07HXvU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PR6OgckTZaAziGipmw2lhsDc7VayXkcAZxeP65xTiIaid5VFbR3w+PPkDHnEelsH7
	 XJVvMV+OrvvU9QTikjU5SIhh0BxQi3LhExjyVj6pQZyti/w/po3MvomAZE+FsK5oeQ
	 kO/R6y9DJTJ1w5MSUO0tFWmw8RcQ9LH/QCF2c7blwyNzGOCdsayc3VclqtvM0uKUI/
	 UOK7yoB6hGn5NSq/Wmhldaut9VSqXvruXfkV2GWgH10U65lJ6uRRsIQbsCztnXvJCa
	 ygLswrKXxpnwoH+mHjlTKZHqjn8P5xfRl5UGRFAHP0v6fO/Gd6YiqA8gO9kgV2nbQj
	 D2021AbKUdKkw==
Message-ID: <sashiko-outbox-228766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Remove redundant kernel CQ resize code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123062641.1964605-1-fuwh1120@163.com>
References: <20261123062641.1964605-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 06:33:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Commit ce68351be075 ("RDMA: Clarify that CQ resize is a user=E2=80=91space
> verb") made resize operation only used for user-space. Thus some
> data structure is redundant and some code is dead code.
>=20
> Remove redundant code to simplify the resize function.
>=20
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123062641.1964=
605-1-fuwh1120@163.com?part=3D1
