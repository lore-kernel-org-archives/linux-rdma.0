Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E254A5C54
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 11:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472878; cv=none; b=L42STpPNxV+ktcmZoYR5NF8/vIOH3QyHx6lwfaA/R6U7LMgA4wue4pznZISQ4b8Ek/k2z7sVNXZ840DvvH8x+Q6O4x8GdsF9a+td+EMpJcYuFMhspUZxQrmNlqWTj2i2jJguwCx50vyNAWjZliWwo7dBPbH6vM6j+1Y34g5daGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472878; c=relaxed/simple;
	bh=g2QAtRnhtr0jEttJK6u6cQXI86vzNRFoi8rPa9pSjJg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=txqu2+MVPMt0zNNWL2M+ajUUUjpMir05L05p84JE3rIwSna1ghW5jJQaHb8WskhMY3/aXrQ5gNgdhfRW1Bk8nW028oPg3of0EQSP3o4D2Q1ZVBGiRRaam5TXJqEf65CMNyWRr5HrqrG3BomOVbiOt+XzE3fzb4WTa2xK3EH8QSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSOdzDu2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSOdzDu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264D21F00898;
	Tue, 15 Sep 2026 11:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472876;
	bh=g2QAtRnhtr0jEttJK6u6cQXI86vzNRFoi8rPa9pSjJg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GSOdzDu2a1bOlvyO4arg3k8ANYxscn2So47mG7WcOTKpPlagyX/xSe320Ozu2CwHg
	 obuOyPbpIjNZhWJdbI55eM16uVcKnXQ/ZKhJp64TgCOEuLxUJR9+LGZ0OldAvatoO/
	 IodhkqqG2sml8WOnOuVEU9R+6clo7Xvt3Eusc9y1/MP+5x7iu9Z7hgz/z9Uibs638C
	 JHENfyhf2UMvSLBpzZkrJIqUAyJf7uYdbg9E31HNYaCK6A8HCDJWYTyLgWsECP3sYO
	 +AERZfr7JlObMwiLVDwHoYA8orEbRgUHXBy54o8n6QhrxyqzbtwjGyk+k7TNZ0oFLL
	 6wo8dRhBM1NzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V3 2/3] net/mlx5: SD, unload reps on shared FDB
 create error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915113459.3934760-3-tariqt@nvidia.com>
References: <20260915113459.3934760-1-tariqt@nvidia.com>
 <20260915113459.3934760-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:47:55 +0000
Message-Id: <20260915114756.264D21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_lag_shared_fdb_create() sets sd_fdb_active on every group member
> before reloading the representors, so mlx5_lag_is_active() is already
> true and the guard in mlx5_esw_offloads_rep_load() does not skip the
> VF/SF reps. If the reload then fails, the error path clears
> sd_fdb_active and destroys the shared FDB, leaving the reps loaded
> while SD LAG is inactive - the state cited commit was written
> to prevent.
>=20
> Unload the reps in the error path as well.
>=20
> Fixes: 68c2dd59a6c7 ("net/mlx5: E-Switch, Tie rep load/unload to SD LAG s=
tate")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915113459.3934=
760-1-tariqt@nvidia.com?part=3D2

