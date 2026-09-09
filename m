Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7063546C4;
	Wed,  9 Sep 2026 03:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924591; cv=none; b=D9vet+lbdtciWkaJmdPC2nNNbN+cxPmdFbF8wDMP2GwbyXNMNRGpJfetDVXd5HzpdcR2K8gs8EvMpFhcyPZgivNgM8Z/Y2lIXF91YCUViwgA5F0wE9UfviMSB1HlueLWVljrsAglq1LI50DgQ+QH8WoNDJUjnPqJcdb7AW/JYJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924591; c=relaxed/simple;
	bh=kLST9fnkxTntJ2JEMWrIn69ZR7O3m4djXnbYFFI5jrQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aHjFuUB0kKSIt0Ei5zUyVkFhykZwTls66SkVONORRK3vbv1O0Ul2I+GfoDe6tQ0EYwfz7FxpNGzc69m+TWIGNgwnA6Z8NR4IdMcV9D9Xg2dTBWxLkqvAkjDNS6vf+StbykAgxDBQl21AiJvHENSaZkqQLXlfgLqLfDW349l++f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/FZkais; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/FZkais"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FE01F00A3D;
	Wed,  9 Sep 2026 03:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924590;
	bh=kLST9fnkxTntJ2JEMWrIn69ZR7O3m4djXnbYFFI5jrQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q/FZkaisD65KAPs/oGhx1qX3jcz9TxUNHQDsugg8FBZL/BrbIneqteyC26zBQ6phP
	 Jyahgbu0bEquAvyMPbfICd4dERUZ4joVrDGmgtmSGE7SMNUuoxV+6JLRwH79y1fiA0
	 I3hq8ut/EZh9NXZ0APCGHyUOrJ3Kd2MvhMkkcldjypce6Oq/xVrjXm5e6i/mWnel9S
	 GfYakeGv+/JHut/6dT71UtBzOx/KkidYPs05VeminmaSwweYVL9EvrMlvc1gSzZrJI
	 DqGH2cuvYEixX6QjOIJfXJ1yMJza28shU0v492VIhSi3G1OhBa8puDnj/F86I5C8+W
	 2KixGkqBJ2aKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 12/13] net: mana: keep the surviving queues
 when the channel count is reduced
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-13-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-13-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:49 +0000
Message-Id: <20260909032949.C7FE01F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Split the live set into a kept prefix and a retiring tail. Reductions
> allocate only pointer arrays and steering tables, retaining the kept
> queues' page pools, buffers, NAPI state and XDP references.
>=20
> After publication, wait for TX-selection readers before freeing the old
> containers, then retire only the tail. Failed publication discards the
> new containers without freeing shared queues.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D12

