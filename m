Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A2C4252BC
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443459; cv=none; b=Jbv9SUiRJms7ny/3R6WJeHvusakGGxgQeaqFzNl4J0cT5J0C+H9llFZUoSn29fgTrh9dlpO6zz/OJbvByEpTB6wspsoRUBrP7GLzy274lx2QCZVBVaCQAF1GKjI4NU2ovRZwuQA0OZ5bUl/ksZ4Pr4W7/ST1axVcGHXFzIuMAHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443459; c=relaxed/simple;
	bh=dIfUBDjnXMWZdKana0PCPoJlzjaCXxMUgRHIFk0Oi5Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FESBdOhGrPkNjCkrJr33qMWhKdd1xJMOc01LFUESHFZGRR8pK9z2m63hReeBcU5bioAyEIR8reVxkU3bmls5OHdczdGn6o4lEIgcRx8WGNb42583PgdcxsoDhzeX9amttUeV9d/XThF1EQsFehkv1v+oOgje1DjxiRBfQdCHkfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVjyCFrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVjyCFrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540501F00898;
	Tue, 15 Sep 2026 03:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443457;
	bh=jhVxu+i95GN5EXf6Z4Etjq1MnW9MMd9z4/f0ROJDZDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LVjyCFrAthJ+RaDFRft4KXOzuQLoV92sRdreiKGzN3vFeKDId+C5oqgbpXYjnwpZG
	 yrGXXWNRNBI6h5yNWM4ODSrh6UvpHFXq03h0Gr5h5Hu8cEX0CPOvP+pbpiuoAzlbVc
	 CNIi4NUVTCXi2PfhG1GS0J9n4ACnEQfud2fxHCOBUI8zWxD/nEdtclDEew1LX4sZC4
	 NKaQamBOKrKpIoC6fCNBw6QLqsvVpBZPEg+F8k1kxYZ5P1VigRje1bOmB3icBZ8LwP
	 f5Og6ZcpGOOvkzb1neUbJiDKRlKKCTRRmmrcK1Z2MXeNHhJn7xPJlvnEJJL71RivZv
	 oM8bKa6inkOFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 03/13] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-4-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:36 +0000
Message-Id: <20260915033737.540501F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  The sites that can re-arm those works are
> supposed to test rds_destroy_pending() under rcu_read_lock() first,
> paired with the synchronize_rcu() in the destroy path, so that no new
> work can be queued once the cancellation has begun.
>=20
> Five arming sites never got that guard:
>=20
>   - rds_ib_send_cqe_handler() and rds_ib_send_add_credits() re-arm
>     cp_send_w when a send completion or a credit update clears
>     RDS_LL_SEND_FULL,
>   - rds_ib_recv_refill() re-arms cp_recv_w when the recv ring runs
>     low,
>   - rds_tcp_accept_one() kicks cp_recv_w on the freshly accepted
>     socket, and
> [ ... ]
> rds_destroy_pending() pattern the other arming sites already use.
>=20
> Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize =
netns/module teardown and rds connection/workq management")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D3

