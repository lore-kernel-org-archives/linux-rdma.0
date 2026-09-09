Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E613B3AFD06
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936941; cv=none; b=kImGW3Fm4ZrMuOdeX5zTRvqoJtc1V93qrT2l9298nq1KvoT6h1ym1yOhd9/wfcu/QFPQMFdFk+sB4QfPyVkDwAl5sK54CXWYO17XifatNtL8G7kxOxMcLY/+vXQ410URU7/dA1/Hz0zimY0t4MfZW6u7VowZ6pf+BKfBWHnVAd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936941; c=relaxed/simple;
	bh=ohTqKgmDmZArRyn9K9HP4iL7GsyUMR8SvXLvvgyo1u0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gc8fsRLEkv3BYNJnCTYs2YBYD6rMQVYXZVEORyjBni6zszHHLF5UJ/ayAUOTKUeHeKImqevQtXODcZDgeXFqZrRmPJ7fYOO5jPgKEiA0izZbn943sfkqpNkHvZwSOcrYeGmyNfNeDHeYO7vBVA5mEsWdY0VA7quIsygJY46NkdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+fZ40kH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+fZ40kH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BCB1F00AC4;
	Wed,  9 Sep 2026 06:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936939;
	bh=ohTqKgmDmZArRyn9K9HP4iL7GsyUMR8SvXLvvgyo1u0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j+fZ40kH452pBYAOvmvBZ83u/ky3HDpuDs9r77Vfo+aMvaeIQxvTnd7/A4cMTHBI4
	 AtAnA5VV6hKbqivo1xCRYJ6ZHL+pMpF3TANtBYx1JGxhCqzu4WV38WUcZKK8O5D8fD
	 QshI+qfZdcXics7imGcEGu9NS9EUdWuVPUzeWWcnF3ymHKWrDmPrktjaYGLwj9yRDu
	 O/kOj444xYyyHA6/1g6SF279iPqRISbqR/qf3XfO8XwM9C7apNawHCsmSNDEmd1sCh
	 ReZ2DSO7ZZhu0iT0HngZ1RfeJVzdwfa8fz6QFASR8pw0JuwWqB5OXtXAvua3asG+vk
	 UnogzgHWpwbVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 03/14] net/mlx5e: psp: Block TC offload when
 PSP is enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-4-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:38 +0000
Message-Id: <20260909065538.E0BCB1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Make use of the mutual exclusion mechanism from the previous patch to
> make sure only PSP or TC offload is active on a device. Later in the
> series, the PSP protocol marker will move to the flow_tag, which is also
> used by TC offload.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D3

