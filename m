Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991C74F93C0
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741103; cv=none; b=dickDNOuaROPAdnCjoRqvhDqOIRG55ciWN1NJbUB0rfHx+2z9jprZBaFNwLV0gNjzJG1wH0AohAa/q+evaGMXjr0sy95L4lPbJnvRrmTmWPu0ZO98LwQrwK1ZY00G0qILIMGdAsQTnlchre7wFzEXOG48zkZepdLvf3Gcnh/i4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741103; c=relaxed/simple;
	bh=iNegNO/dTh8qwUDqa+57zApakCSRP59sd+uJ5QvvMg8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cPFWoSder/82omHpYV3dDN+SF84fkEw03mBEAp6XVVaKHq1U+BwueYh2IZlu1TbIzDZsNPywvcrHsizeEF/9IklneeCye2ATt9uHO3FYLdYDtAFpHFvztqUFnz8N3eiSZwdV5D7s4YRe6cQ4HXvK0RZl4wGHztd8qb6KM19CSkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TImDh5HO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TImDh5HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FCD1F000FF;
	Fri, 18 Sep 2026 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741102;
	bh=iNegNO/dTh8qwUDqa+57zApakCSRP59sd+uJ5QvvMg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TImDh5HOsMroQtsYkHNeODTSFIEBxu9NNrVecdUev9EQAEugBjQyKABYJxuxeVTZd
	 gQ7CgRl+nBMdGFRDv/b2/TP0dcwaqPcHptNab8ev2pqBnOoPm+qq7ky5fe5LVrGrda
	 h1JmTXd848SSJBD15TcAOzuD6p7FjVG78OdriJcmTkjdjaKtAEP8bCzD3FA6vbANTP
	 yCJuf1TwoWZ34CR4lrgegE7IekUUjLmDHMlgzR2X0oKOrh1qn1OhHpE5sJCPgvR/k8
	 4PVeeh4YEzfm1L0NRybPe+xhZGSimNrLPrEYexeQxaWKT8D1l1qclkRI1MVtxF8mOS
	 kKMFoWfZWSUUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 4/5] RDMA/mana_ib: Make kernel CQ arming
 robust
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918140407.2922819-5-kotaranov@linux.microsoft.com>
References: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
 <20260918140407.2922819-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 14:18:22 +0000
Message-Id: <20260918141822.68FCD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Track CQ polling credits across owner-bit wraps and serialize arming
> with polling under cq_lock. Check the relevant owner bits before
> advancing an outstanding arm, and update the hardware consumer position
> when polling exhausts its credits.
>=20
> Expose the allocated CQ capacity to the core. Pull the explicit-index
> GDMA doorbell helper and its declaration forward here because CQ arming
> is its first consumer; ordinary GDMA doorbells retain their zero client
> offset. RC-specific PSN doorbell use is introduced later.
>=20
> Preserve the baseline's dynamic interrupt moderation doorbell with a
> zero client offset. Read CQ owner bits through the scattered backing
> pages when the queue allocation falls back to non-contiguous memory.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918140407.2922=
819-1-kotaranov@linux.microsoft.com?part=3D4

