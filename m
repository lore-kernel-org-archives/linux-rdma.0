Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AF73D9555
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884728; cv=none; b=ig8NQLI8tmfbvY/HPtA2hcq8Im5KyRlvSnWsLdFhRGhdrrvL8O/Cu3k8FARLkzXTXnugF3Es5LUfxUUgQmwg9pHISAMIPVCIloRU//VJDKj6Faexh9Q4KeUVvIj98NOwQwg224EM28waSzqMbiEluNfvXVLDDQ8DHJvP5k9jHtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884728; c=relaxed/simple;
	bh=UZ7EPUN3h67vxWvwRxSEAwJx9WYdkhJgGUigRdtcPFM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QXWHglFXHAYYhEJNahuj9LDrZqNguIBPQTlmbruuXvHFbPwM5mCCu7Dv/ItCSU+pvy2UaAvETvwqAlGY42VxtG6ErgYGKDvdieZWKXJXTM8B1Smbx3FvJYdjCneVio8hlYa/DfQbCnncN5VYlD6JKNCHz4PKVVWHA1gbJkXaDQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjqJS+1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjqJS+1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030521F000FF;
	Sun, 20 Sep 2026 06:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884727;
	bh=kiaFW1CJIHZFNXjioUwPX7gZWN/r24FZnziGXC8XkUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NjqJS+1AoYl3LC5JX7pyC3h6w8NqIQ7WXOrP4frkXVyjPnMJIPh/j02q6yBqasNSo
	 7adajc6YGFhlreKQmayYvmBXgjXctkTcHyVacIaJnGk31E8g2HH0FroKFuj85ks4El
	 r6jCspbt5K4K3tD39spLgQ5FOfSF6I1QzMw6s6MnOEvyKtsj7c3nRBXenVuEVQFzKg
	 VmqFO+eTDp+HFhyaKVAbL7vjXzRQ/CUepZtq3Hh/ZhF3dYonOT99XC+D2nNPaM3YD8
	 aHyaYoKDn5x1lyeecFVbSUe6xEYNjVJdWaRNkhSvBOmV/YAWO0PPSFKk4fP23HSoHs
	 ny4cKFZQ6BjpQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 05/12] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-6-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:06 +0000
Message-Id: <20260920061207.030521F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> rds_conn_destroy() tears down the transport state and immediately
> frees the connection, along with its paths and its workqueues.  This
> relies on the assumption (documented in the rds_conn_destroy()
> comments) that "no one else is referencing the connection", which "we
> can only ensure ... in the rmmod path".  However, the callers stopped
> honoring that long ago.  Today, connections are also destroyed on
> network namespace teardown (rds_tcp_kill_sock() and
> rds_loop_kill_conns()) and, one at a time, when a peer negotiates an
> unsupported protocol version (rds_ib_cm_connect_complete()).
>=20
> This leaves loose ends since references to these destroyed
> connections still exist.  Sockets cache their connections in rs_conn,
> and congestion updates will walk the maps' m_conn_list.  The CM
> [ ... ]
>  infrastructure, no rds_net, single conn hash); destroy keeps its
>  one-call external interface; holder coverage split out into follow-up
>  patches; rewrite commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D5

