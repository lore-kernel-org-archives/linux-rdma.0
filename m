Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5B49E140;
	Thu, 10 Sep 2026 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079128; cv=none; b=JDT5c9YP9sQpOtZo9A2YwS7bWdm8w/MCjURhVoxx3aJOArOySTUoEtQoIcuTVBgcOHttKvjquAkGbLpndWUY+j1cv79fG8CXwiql5e1rvw1M2PG7/oUqa5E5iQqpj3aj9TCYEgP+ZlaY7qUzJWphwBdG1j+5NcRQn0qPiyD+9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079128; c=relaxed/simple;
	bh=kc7sPW6PGc3MqxXyPqVV2GFcQgW+yR2WfR2A21ykdEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tKTvOBH1iwOPMZPC97haqkaLKQRQHbfcrUSGKrhRWkD6p0FiiQuZB/+IX/WeaNjs/qc+u9Jbjcl+1Ytz/TqmLrDgkNooSa0U3bs87EHZu/wKX00NCbkGoo5p+BwjaqqBGDEghrFgPv1djnKqnHQy6NpxjLprTDGxG/ithC3vCfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PT3H1w/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PT3H1w/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DC71F0089B;
	Thu, 10 Sep 2026 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079123;
	bh=kc7sPW6PGc3MqxXyPqVV2GFcQgW+yR2WfR2A21ykdEI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PT3H1w/C2w6ZhbLc1bMlm1vhpt7t2eRIOwbUNI6aIUsqWcWiIucLtGE92JyB7iB5l
	 ZhyM24ZKzzo6d/LiR+DEWyzji1QBfMecpSkku79r7VJ4vc7ycFmzWUDET7OhVqOJ1p
	 6+cVYq9xj6wkv8T3mmmaWAKCKljoed8JoxORq2QFawM5cmaR2Yhsfb8gtzJ5BRLzZU
	 BE6c+82qeh2ba9jdvkLAbAyyUTh137ub217JNbcjZi502/ZcnWBYkgh6iEd1Ys5R+d
	 EnQ9UWFKVNTO9ncmbKW1tqjkoHg1AOTkphsQo/NfGQJ91VkT7D8tpHSrFTbJhKF4xO
	 ObuAtMiHo+5lQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 07/13] net: mana: swap queue sets in
 mana_xdp_set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260909222416.884246-8-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-8-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:23 +0000
Message-Id: <20260910222523.61DC71F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Carry the XDP program with the queue set and install its per-queue
> references before redirecting RSS. This keeps the RX buffer layout and
> program together during publication and rollback.
>=20
> Do not replace the live program during allocation. This also avoids the
> pre-existing failed-preallocation stale-pointer bug; its standalone net
> fix is linked below.
>=20
> Link: https://lore.kernel.org/all/20260904202640.3900685-1-longli@microso=
ft.com/
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D7

