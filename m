Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFA13314C4
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730112; cv=none; b=hMbEYzNP9No8RFLJGMcu4n7eAIsD6IH872VhEFpAA+txKFeCH9jJgxBzNuYw2/5Ob2Awa5CUAN21t/lhpjVcu4wDMVz8tgvzx5j2p+cUpUSKa6SYjmdjvOUrd0BY0RB9N5cAxxgK8rRn1tiVZ2XOOV7FC9E/aetMNllxlONfdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730112; c=relaxed/simple;
	bh=7SOGXC5EYL4KZye/3isOOT2PDSfN6BPwC4hY5Z1QeC4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xt0HgMgST1EN3F8FD96EajQY6Pdz6UfvVQORlAJMoH7TquPR/SiVUpdH23mzVz8QR77FDFmb1d5j4BkU432965A76Avvd8vUVE718FdPN4y3+jaSPrgZwoh0HHqmEW1uYcVtmaJLrzDruPvj8P74PWm+1PXYiejD3q/g6mEGIL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IT5JyFHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IT5JyFHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF23B1F000FF;
	Fri, 18 Sep 2026 11:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730111;
	bh=7SOGXC5EYL4KZye/3isOOT2PDSfN6BPwC4hY5Z1QeC4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IT5JyFHvSIBIA+mWQw1vo93C1mLjlvRkg+dCaYEwId6NuiMpHTGG8abjQUDR/kQGV
	 axMYRYJ4DvyQsUCTzU7QoHtB+MKXNXlDoOEy9Q31aujj1JeH3p9YDNVelXT56w4l/r
	 E9SbR1zaTlFVlVv/B2mlblQ0ha7mNbn3D9HeKbTfzvoTeQfgJNH2v2tdxBoRE12FtV
	 ueFnML0LOSvAPo3ZpJ5wgCO+4JM8OGenpSOlfr7nAySWBD3Azp4dvoq/6gWSzhHmlu
	 Plb0BKH3owmFpMAWCA5Xiw9erntj3ro9i/uS4b4gynpgdpgRhGWpBV5tLg7ngY5viL
	 J082s2f4bV+GQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: Free IRQ when CEQ vector mapping fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918110428.36586-1-serhatkumral1@gmail.com>
References: <20260918110428.36586-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:15:10 +0000
Message-Id: <20260918111510.DF23B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> irdma_cfg_ceq_vector() registers an IRQ handler before requesting the
> CEQ-to-vector mapping through the virtual channel. If the mapping
> fails, the function returns without releasing the IRQ resources.
> The caller destroys the CEQ, leaving the IRQ handler registered
> and potentially referencing freed memory.
>=20
> Call irdma_destroy_irq() on mapping failure to release
> the IRQ resources and drain the associated tasklet
> before the caller destroys the CEQ. Use the same dev_id
> passed to request_irq(), accounting for CEQ0 sharing
> its interrupt vector with the AEQ.
>=20
> Fixes: b800e82feba7 ("RDMA/irdma: Add GEN3 support for AEQ and CEQ")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918110428.3658=
6-1-serhatkumral1@gmail.com?part=3D1

