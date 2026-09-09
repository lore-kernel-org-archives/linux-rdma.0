Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9886D3537E0;
	Wed,  9 Sep 2026 03:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924591; cv=none; b=jIs3dQhbIiElH/xH66ZvdaQYdp5yfRUWw64EZ/gOs3mhA3kYX9Cl/UYsja6f+Y1Yh5Hv8B4WI3f19qY5Y/9JLkwAFwqwEGVTuUuLjVkghBU+Ob9XecwfFGwY+jqjfcNkR0H10b8ro43vTCwst6orDKl2RWNBHtMYWU4jvUk6Fks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924591; c=relaxed/simple;
	bh=T8IMFSMUlh6EPZRijScS2c9U6LSW0/EDIEDu7OrG5s4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kLczSU4OQkxnfgy1QZ8pJ3LZ3gyj6JS/SkqQU/bCmCqHi/uLKODQfDWCfKhwtlDEeWP4JpJj0XAmyosklE2hl1MpJuGjhVyl/Gql6cUkKo3C7yCUblFh8I1SUGl+Wwb/sz35AdVCGp+oiKbgXqIJoD0wBt71bdWm7dLxRcdEg6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/WAOhu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/WAOhu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB061F00A3E;
	Wed,  9 Sep 2026 03:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924590;
	bh=T8IMFSMUlh6EPZRijScS2c9U6LSW0/EDIEDu7OrG5s4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c/WAOhu34wicu99D6pfMmbFoXYeu3ovOy5aynUMdD8bpybcMf/+R/+FvtSS+yTFFS
	 saOWXjcpMSitCTH8lng5qj8y4nLLR1DkxkGGSEceVkxzlgqoZMghZT/qKSM8NG/0+2
	 LTF1a3rx+3kK0tGPoH4ppdOaM2tXvPmBRYuYhqhWUrt55K9Ur3aTpP7OYLZ8ghcGna
	 Xlg0+r5s5xlNubwDL6Tk9jqgY9E1pSNNTcUPs0FcdtypnKfreDuLnUXJVW20eC7C55
	 NbfWGb33auRnOzDyKMqvXas1mVXwBMj4AvYqqMYwfMaSS7mxZuO2X0F883GFF3lRxi
	 yZiNT+VOOLwcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 13/13] net: mana: keep the existing queues
 when the channel count is raised
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-14-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-14-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:50 +0000
Message-Id: <20260909032950.5CB061F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Keep existing queues and allocate only the added tail. Growing N to M
> now needs M SQ/RQ pairs at peak, rather than N + M.
>=20
> Track the fresh queues separately for failure cleanup and XDP references.
> Wait for TX-selection readers before freeing old containers, and clear
> slots during partial teardown. Full rebuilds now keep the current count.
>=20
> Advertise in-driver resize recovery after converting the live resize
> paths. Failed rollback still requires recovery.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D13

