Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F014F2D060D
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936942; cv=none; b=D5NO+X5VC2EvFVNXS/KyDcBNpwZk1zXsH1tQGyPQvaA22FOSzrMNPuvgsxXq2AFK6C1BMEa9dha3Uh5OzXIyYkoUZoGSmUM80bI51YZPMjWaCn4tjns436KBHSOgwRrHd/E0qgU87Poylozm5n7oUpHrKEByH9bINOV++pLidIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936942; c=relaxed/simple;
	bh=Mu9DDrWdSyGK9ddLVkoSQQfZkadQgHL03AEcz61vq7E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d23x02OOC71qtM+PjYNWH5wMXO9DAGnAWPlSueT0b+FjQbvX70m2yOWnVJcksRvLANvnJrf9wxUQcEoXgorR/vg2DTn8JovAPrhiY02KLVWijJCy8iQtmsGqDwGI3PciZTFvM3LUEVxbLrhQ0mWlM15v+1L+V4pnad/zhdlnrL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4zXgazX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4zXgazX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5921F00A3D;
	Wed,  9 Sep 2026 06:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936940;
	bh=Mu9DDrWdSyGK9ddLVkoSQQfZkadQgHL03AEcz61vq7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N4zXgazX5liI2y4rijwVqi2u1fUwrP8RRH8zdyIkVIRW4It/ga6DUBYZycDVzaerL
	 Fd1IC9NRTmJXrqNZrOo+MpxZVfwk+iZEA1YPFTnKQ6ZGrubLOSgUkuQB75UcKIh658
	 5xPp5Peg8MS4WTAneMyhPsXN/b4g2/meoBtCDQsE+Io3P9syWSLlP5noRWMprhztQK
	 Oh6JhrijWBLmWNeL6G8bKltKrdJtkAO7C+u28l+w73jByl/i1PPoAQH94e1KaIYoVf
	 ekSW//kbeL6FkeF+7LZbV0R8rZXawy9+Fyiz4fPZKt0U6k9yGqhop2ZCDpcMtBcrp+
	 S1W2+rv+sNU3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 04/14] net/mlx5e: macsec: Block TC offload
 when MACsec is enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-5-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:39 +0000
Message-Id: <20260909065540.3C5921F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> The MACsec protocol marker will soon move to flow_tag and that will make
> TC offload unusable at the same time as MACsec on the same device.
>=20
> This patch makes use of the mutual exclusion mechanism to make sure that
> TC and MACsec cannot be both active at the same time.
>=20
> One extra bit of logic is in macsec_upd_secy_hw_address(), where
> existing macsec rules are drained then readded. During the two loops
> it's possible a mistimed TC filter add to throw a wrench into things and
> prevent the 2nd loop from adding anything, since accel rules are now
> blocked. Fix that by keeping a best-effort TC block across the entire
> operation.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D4

