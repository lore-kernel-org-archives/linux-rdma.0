Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D014EA37F
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220609; cv=none; b=adfeUOE5g1l2Hl0VvNEwS+tajcERNISnZjUg3BVQK3IhMrF3sEDEW2r15egUWWoaSbzmBFoiHUwrgnnS8r1yfsq9GzflPkuVj4rf8GsZu0IGd4BdWY569EWAK2TmjHD+l3/9w9SBHcO+h4BqMg8bIWytI/M8mBvs3QpDj8mB4Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220609; c=relaxed/simple;
	bh=uibo1X8OxjIalqTp+C5ba9vPfwMgxtFKRYMa0hmxGls=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BFN4e72YNAWMu799djW6+MOWkz7bEWn85bXEm6Zeo0ElH5tUmXgKA3jjFdWi0IhFhTE15qVOYN7MdhlV5J8QsRtx0dwo63oLvLc+ibog2xR9Ahnfa9sU+Bfa6PXMBQMqdbx5/KeICkEdAMAEKwHhYlrtWbkVQwA3gVcU5VDO0xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvObyTSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvObyTSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE2C1F00899;
	Mon,  5 Oct 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791220606;
	bh=uibo1X8OxjIalqTp+C5ba9vPfwMgxtFKRYMa0hmxGls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TvObyTSd4MGCmTPcCaBbnETocf7nhbXFY/zTjhQ0P9Zi/u+xJd1EGPf46WkGtErZh
	 xAFYRB4hmKIKJj2COSc7vvF/e/WLRk1AZUam3ysV9550u/edWw+WZXBDhzendymvpm
	 18NEC0i47t4GSF67lnYWBQTjLoqSES4A4cGlCQK8QIuPkpsgB0Y9sgscWB4CmeHWL2
	 hvR1i+wc0LJ0s47hQWKpoYQE7k0RG/elIJKEq5ISJbQlU3zwWSPVxBFh0N4GzaolQ4
	 ty6lgF59gZgMCxF9UFJEelwocwf9oxERfKxFrZbuNNS72ZeTx/nd6qBZR49peQFW1c
	 tbrfpZI0/B4hQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY
 on flowtable offload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julius Bairaktaris" <julius@bairaktaris.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004171636.3545085-2-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
 <20261004171636.3545085-2-julius@bairaktaris.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 17:16:46 +0000
Message-Id: <20261005171646.ADE2C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The next patch makes the flowtable emit FLOW_ACTION_PRIORITY for flows
> with a non-zero skb->priority, which on IPv4 includes the priority
> ip_forward() derives from the TOS by default. mlx5 would reject these
> rules and stop offloading flows it offloads today.
>=20
> The eswitch does not use skb->priority for these flows, so accept the
> action on flowtable flows and ignore it. tc flower rules with skbedit
> priority are still rejected.
>=20
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004171636.3545=
085-1-julius@bairaktaris.de?part=3D1

