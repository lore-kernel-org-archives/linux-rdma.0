Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDF137AA6D
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430342; cv=none; b=nRTVzJWfUhYGEOoqAi+Y3ODBcEzdBFDPGgNdJk2Pjv7l6vQNY0AqfPNuMp1BqzSX25pT35oHSoW8WGzADgIAmU0b7cBwsSKMl/me3JiZM2wd487vrmDzyvx+3GwSaxm6m+D8nvBhj6Q2qu0axVfVecAAkROBMf6e/39Lzmqzmmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430342; c=relaxed/simple;
	bh=ZaPjsBgpHRGFNPPflhurf2nTOWfy5GEu60clQ/lXkBQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XnrZPJix++1sazkc7usrAwTxZ1ez4kVylwxr3xha8F9z6WyDtdFygXVRLaQbysxn0SzD+vU8cdU8TRR4Gmh8Apsc5iG7qKtlyaO9TObbuTYQLLXd3faXalx6ZlLcXmjFRR+9sUMVtoZORquIWR3Q6LM1H6kydd8FFVKQsk0iVmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaQMuszU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaQMuszU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFD41F00893;
	Thu,  8 Oct 2026 03:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430341;
	bh=HLWs21vYRdsF0ROrQ4D1UOGCy+PhGcaDGkwqLfKv7v8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HaQMuszUskmE/lSDsoRnJ/LbUjmauFfy5hw1M1sDjGfWHdyhaQEEKCVEne0j8vg2O
	 osj/MY7K1UXqYuwEKIyzHpGygOX12joORaOEvXfceAKYcqN2h9eGktakdyXvrW/YmO
	 GKCzCkfmmvhsiYlyoV6syQTiYfFaPJTc/ARoV9KwpRM1GEhHqTLg8pAQr5L5RXci4z
	 0jj54fcdilwQKQpMHV/PsFQjdxeSMz21n1J+7b2C0ilCiNePjR0DuzhJhNOULNZhSC
	 xPN/+KJHjXWuDCjWIHQmR77tpvqueH4NBMplLd8JlFo2rB3qsSehXFlKYKiYncQpEB
	 XhsksDZPcD/uw==
Message-ID: <sashiko-outbox-163553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 07/13] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-8-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:20 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> list_del() the node from a stack frame that no longer exists.  Make
> [ ... ]
> lock held.
>=20
> Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueu=
e")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D7

