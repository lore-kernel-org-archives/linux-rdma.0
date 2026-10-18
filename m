Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D347604F
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792335168; cv=none; b=hByLxhVBSzMEPh4dStX6hhrwC7oda82tGKgyYewGJ8ns0TU1v/r0UTJHp2grxP3qFjXcAJHN8rTmqYLL8Z1gCuq3qYAzFT9Eh5sqPXmplcz5Hac0gPORDkFcF0y9qERLibQnagJlSpPTEWwPu1hO28SyVH5jzhDozfLqFJ2vLKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792335168; c=relaxed/simple;
	bh=aNrlE19j6zTCslny4CV7OqdIUXaj/QzUTtSqQT7QmhU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tZGNGr8PGecRrJ7ZGeAk7AlnyHElErcc40py40vVrbH27nXT3wQlV1aqBKqL7kJzoWBttFLOyxdADgB/4VC14f/22xCNw+W3GRWk/yTrgvb9FOcN0gnufeIy6TkwGOgfdOLCYil3Rz60YAhZc7qjSPG9J17jLsm1o0mk1ymwNgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMxR7xm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMxR7xm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA78D1F000C4;
	Sun, 18 Oct 2026 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792335167;
	bh=aNrlE19j6zTCslny4CV7OqdIUXaj/QzUTtSqQT7QmhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YMxR7xm/Jczk2SZcEBfl6xtbKukzrbPKskZs6LpXGN9bDNP2cNFSCEHpmuvrbrWdo
	 I8Z4OVh2mAsVy9FrPQcPv/nbHURnHWBTO/PKmVPiCHiMxcKnz7gOwmhOm4YtXqAoiz
	 rwpRoz6LPGP++R/acfiPLrn3CwBLoJM520qhNk05sPzs549uOFLuudig5+Wjk5xqW7
	 8mRH7KffqqT6aKmSBDAzEjs6f0R96IyknVNRg4ej+m6HmRRjykp0DZ2sPhrL/wPHza
	 ulLYPtja7+BzvqAoyEfl5Y20ynpORhocM9sjKjcvz+V1iNtESfvKtuIVn/lYTcppGV
	 beQqwilR7S6dQ==
Message-ID: <sashiko-outbox-176220@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261018144907.20123-1-serhatkumral1@gmail.com>
References: <20261018144907.20123-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 14:52:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> In MLX5_IB_METHOD_STEERING_ANCHOR_CREATE, the user-supplied u16 priority
> is passed directly to _get_flow_table() without an upper bound check.
> This can lead to out-of-bounds array accesses on dev->flow_db priority
> tables.
>=20
> Check that priority does not exceed MLX5_IB_FLOW_LAST_PRIO before calling
> _get_flow_table(), matching the existing validation in raw_fs_rule_add()
> and mlx5_ib_create_flow().
>=20
> Fixes: 0c6ab0ca9a66 ("RDMA/mlx5: Expose steering anchor to userspace")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261018144907.2012=
3-1-serhatkumral1@gmail.com?part=3D1

