Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA1F414DCA
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576125; cv=none; b=nWLlo348RJP/o8jLFuxBEmoH9mDsF3aW2WRe7l7bDgPbzlPfb41OpqyG25SfmMLyq8bSIp1Dy8b+wNnSSnDh1HmDIUI+YY6YWFJPu10Rx73ZFvWUmXYZ/W32yt2JKIHixrSeTfmIEspFrqeFvPqPL/JJM8PjR9Ia63L2P1Jirc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576125; c=relaxed/simple;
	bh=IwkM1dF4X0eOJjYXOnmrDLpBIbo+tLjann/y+XMa0Ek=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sgC3DkDJwa1fGRCEnsZEIx1VZIghlPhROzwBpMW9iYQMg8iuIxOyRxrNnS2TRqahkLlDSCnzmtw82RzHgNtraB5LpzVD7v/FInN9nSIngHN2ejkNp4YkWQdMgnk6xuSEp8eQazkAvxHt17GBljtWr0jqmNgk/bTtqevJpXQg88E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+OPnPy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+OPnPy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E72C1F0089F;
	Mon, 28 Sep 2026 06:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576106;
	bh=SYxL4QKeoYj4nZY/CeSH1Vsn4MWU224ZRZj9TsqDHnk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f+OPnPy+gkfZG5fq8KS8CaXB75DeDbczqyNZgsQnlbybiYN5/kHNfD8BxWFqqv0Pa
	 2RPqV5zZXiR0OcKgcqXYYoGwMqV08UBIu9+IsQosTRvnK5QNgiewSudGwG6wSrb4So
	 iyEM6ZQH0qK5QsHqcV7FrLfJVVIexuKuCiZtUK5mGlYAweA612imMT+ska4nm83oLH
	 0xMhTGfXIp9NNgga/XvzKqQNZDr8Abn07Lo45f3xyfE9V4lWH49ZtyVmHf7dONKRy7
	 HDqCIPll3Jg1AXqCyXknYedA3WHOnhpp6ELdMQCXWkgyMFtfR/IvgWoV/a4m6nEXhP
	 LQp1w8hfPEbOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-4-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:05 +0000
Message-Id: <20260928061506.3E72C1F0089F@smtp.kernel.org>
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
> single connection.
>=20
> Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize =
netns/module teardown and rds connection/workq management")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D3

