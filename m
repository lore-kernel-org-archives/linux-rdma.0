Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E649E120;
	Thu, 10 Sep 2026 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079127; cv=none; b=iOoEi9t/363x7oiwd65/rXdSVbwSZPHh8KCLOIg5d3iT3b3u7jJ7vsiLYzf2ZwhSgE5zJSezl8V4H1S2MCBFfhdWp4DbL5usoV8LqMRBO0UNU74a3ceUtP7otN+9wPV4rvDGSK+jsT/8yQonw5RxdFC8iBqfYyYELz9NWt7l6O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079127; c=relaxed/simple;
	bh=7CFKx4GZlKaBrnVw2TlIPJE+siEU0vWkYugEINMveTY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BgkU6FTt1kKNdWUv1wEDKfdaWdgWkfF+vrHTzkHGrfaoRRTizjXF6Xoig1hY2e2CNWDpvxIMkaFYhEW85co/bHvWnAzIEJhpbict5fkW9wDMM3nuWbo/TqG4aU+pJfqwdWZdGy3le1HTMR7muhB51tOlf+K5x/5X0PWsRurjhwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmpoXby/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmpoXby/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105011F000FF;
	Thu, 10 Sep 2026 22:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079122;
	bh=7CFKx4GZlKaBrnVw2TlIPJE+siEU0vWkYugEINMveTY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WmpoXby/a0b4jyMV6m0/blTxcKV1hToxloFZtfNbp1shc89vz5wMsNcK2HTL0G2Ft
	 2h4sUAfJuSqgrx2wPa5r3ZMTZ00v6RhZiX9z5Ah7MJqtyfstfgWY100TkFpgL1bLX1
	 WSIiwosETv5EvVeLMhRKgnXAl8uQxUbR4QToQ59DXuftbV3v8dNF6fPruopU42R6aP
	 dWB+BUpoprchkG0ZpQ6IgUyzKKxCLtYA1mBXdvvpjoG7sCEqLrNyNanoiHgSnafYvq
	 CY4X3lpkNENfdpg65hXoj1/0l3ACp7dWk9UzGoLPxP3suyqUCgeFQwYhn6rWkaTcWu
	 88hHm05+sir6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 01/13] net: mana: add queue-set allocation
 and teardown helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-2-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-2-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:21 +0000
Message-Id: <20260910222522.105011F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add queue-set allocation and teardown helpers using a scratch port
> context, without releasing the vport. These prepare the reconfiguration
> paths to retain their running queues if replacement allocation fails.
>=20
> Extract the TX drain, retaining pcie_flr(). On reset failure, leave
> pending TX SKBs mapped; this does not prevent subsequent ring and RX
> teardown. Track successful drain-initiated resets and request best-effort
> sibling rebuilds, without reinitializing the HWC. Clear removed ports
> from ac->ports[] before those walks can reach them.
>=20
> The new queue-set helpers have no callers yet.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D1

