Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365851;
	b=MPHf+c9TiCX+g4qd7YeWADYsFUM6GifmzdMp71WWkONYI0+27MhRnhsJtCEcIrREABaF
	 9utg+tIbWM8xkSTsatGRqhyStjGhydz0c1cgYPF6tMUbZJnjNmV0zse31Lp0DpalmBP8D
	 vfM2mbI/3Xx2Ycjb3UuOtEVrE98EY+kx3vaWVDL+nSq/CUIMAaH7unqB6ymv6eRTj9z06
	 11pH10Rj/paSx3UErw5OkVh3atQQ+njnzaB6WCGLCZsVFKlHgymPMEfCxbCNY246teqoj
	 77nVrcWvlnxQ6SP1GZyiwHIAokYin5sTORxrs6E8YFza092qGs2ZxGldH2Avk8JMbwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365851;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TM5ZxfvY6xdqtmC+66I3Hgw2xODPaUVCmeWYFYnn1L4=;
	b=VXOOoJu6C4lCoBEgEDfahQBiOv8Yy/viZUav7VKxm6rmUn+0Z2u4kW6Id2A8tgcrZA7j
	 QKk0ijoZKKUPjfNm1+zf3IdEEZH5a/ICN57X0DI6atPMirLduGmgQY/JABIEWZ7ztJqPc
	 r4IZJ566nHuG8d75qU6GxLwCD9CT5yBynB0B0yqkB0HIGnsrofHGUrLsU2u5HWpAdhzAt
	 sp89lvvGJeZk4vzZbSRRY4ZTESZXD7/x273wDcPKwAqfwOb3nkCOKb+/qi3Sfn+WIiO37
	 F8wNmaVbXe+B+uISvkTyG806Biz3fQoUIZ7jxy9LZpwDkJnMnTm5cDVdQaSNzpb27YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=no1sLpx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED9606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=no1sLpx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A904D1F000C1;
	Fri, 30 Oct 2026 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793365850;
	bh=TM5ZxfvY6xdqtmC+66I3Hgw2xODPaUVCmeWYFYnn1L4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=no1sLpx6eSGxVuZ8uAa27FnYVPVYEbOM7Vi0mvGl639fQBDF/Sy7AAYznH4Z5DXmR
	 fo99b+aw1lumiJNTXASHEWna+wzwrS5e39/NuZLqS+4dUryQdgISiQouhbDWUbHLLs
	 Zq3PEEsDP+fNf4lnZRlOckeWLqzpaT9sGhaEkWCoev4+mdsx/a98OrWT1sI5LxWov2
	 cx6lmJAxQaYlXZuGlP/Pyv5TqO37/2nIm53jrZkImddBWD95FWFAP6tqgvIizNLYEu
	 wnXKt+/S353DEcYZWkhsdHoY+oQFIEF6VbjcB/tE8Z3RDzHv7sDYtrFL996IRHLvlg
	 /fj+8+9oUwsJg==
Message-ID: <sashiko-outbox-191049@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 03/10] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-4-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:10:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D3

