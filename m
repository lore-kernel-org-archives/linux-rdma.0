Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F5F36B93B
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430336; cv=none; b=OnRNwBESOmC2cJy0722sEh3q9MZ0Brkv32Vhuq/uLW/jLQyMIoiyOI8NQF1eyLvcquLLlJ8r7K1AbC317MhX7GSx1jfpX2HMJAT1BP+3COZgkxl+bMzAD2xOIMGtQ3Dx7VEX+p5/jdKK7wKNmBeit9Qb7xhRahQ2is6ma2+fHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430336; c=relaxed/simple;
	bh=sJcKtEyCC92VakLSJ7l2SW2QADTkR/VpEykP8vZSGXY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=PFrCmhcGJvLZ15D5p/AqAzWhSp9MPvea9zPoPg+pTmRNrc0WVhOSQ+0w30ogjAdMaTPiLNnF867XyXjDWUPFmEkVk/kDtfx/EAPJDXNlla2CWhaaObPJS41/QxIYDx3UOi1Hi/hHq3ZuCjXvaPRYXneJ1vdTOJJzrVQJfHx3gjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaK6Ok3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaK6Ok3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAE21F00893;
	Thu,  8 Oct 2026 03:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430335;
	bh=VcR8pskmVuz9LNXz6or3UWeJR5Hq7CSiBDFpjf/24Cc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HaK6Ok3oLG+n6DKF7f+ue9NGA9Oa26aOp6PGKiWAywBHXd+bzD8rx15pzGmB10wXh
	 FKbgez20cQuGD/Laby8jWMMItYziS7Z7pY8c27lmFG5HamIsjg9v2vL998gtqvlNyz
	 n2Ww6R9M+5GHty4AAzVBoa+NxQoMvHyEbkdv6w35tGhMEgo1FCCNSMX2Jj0DcQ/cjz
	 4brXuZmd+Hz/4zVPP/QklXzBCvoPCCEq3QGN971XajNaNv5B9lSoeaB/zyHcE2olnU
	 FehjBmY7m5wl/dkSFwh+v1u6C6lEDERYQUWo0N6/f8D1+4ANjJe2pj8klzEHjDLPIs
	 2yCYf4W7pz6Vg==
Message-ID: <sashiko-outbox-163543@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 04/13] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-5-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:14 +0000
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
> module unload cases; the following patch extends it to the destroy of a
> single connection.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D4

