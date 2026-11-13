Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546313;
	b=5V76WG3BB/ojUe2D9lX3IoovrNEk67Fg+lTkG+mqcQXHkv705P7EmT7Vfcp+ponkaDXG
	 3nqbpBVvLXE12LW0A/eOBastZfF/765RwknqLHOtFbWCpqNUopH2xQ5c+lOoiaMSB3yEM
	 hH56PlDMEdoxDwTJ+sVqQXpepVkod4hwBOdg5zl3JYs/GtmwnmQjqJlmQdQi5b6jpl6eu
	 IqK4fQbUsX6RK4FjJB7re9Z21l+afGosGsr5dIhHFMG0kI1/eBPC/Q0wT1t1Utr8vGMWg
	 LMSanVD5mkR1DqnFr+H8VGa8xWFwOKK4sSn1WEoV0uQAmrNDZtuaXselPMKw9RSP3Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546313;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pSwzMkReJFpEtxz7H7AcT/mhfI0WGH05upTGA61BBIs=;
	b=gmGogc1FAxPJM/xdoZTq6SG/7UB9UAsnFq7a2d1v6o1zZKjcmgLxZuo8VsmnkIE/ZQnJ
	 Mn6qmcpxgBFB65X9cTuzotgt+PMQkd9kMFR6grZzxmXQN/A/TO1AnOLN7V9cLSF1ykTuO
	 OH3mqTtOde9pSWUzIMMSeqZqaQJrnEjUQJtDfqBw6xex6Jgvma4lbOl+3gZRKNSR2pXLW
	 23drm+ekRLmoeHqthhnm+hgO113wGRxYBRtE+hL3LjfUxy+ZCQohNY2ACWeqxkbqWUotw
	 LHH5Wy8rHUgLgwRSJ11mkWID3LR4Sxg9tAz2GgYRm0iD2eSF/mj6AFCjIBODW494Ltw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EENN/6Da";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DFF606A339
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EENN/6Da
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585CB1F000C4;
	Fri, 13 Nov 2026 05:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546313;
	bh=pSwzMkReJFpEtxz7H7AcT/mhfI0WGH05upTGA61BBIs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=EENN/6Da948sRS2PhuAxKILyUE1Z211shJI4mwC717bPsXWclClURNNcWSswdxCE9
	 Y1TxmRtvJl3KbO0QIG9GCxPYCjlvz3gpAqpvN4tqExd9IBiy8/gwsdrcSd/Mk3gyBO
	 GkzMIeioap74sz/pYWyEgdrvpBvL4RwmNYEs2Y/rGMwvmHOQy5XoP6826JNbnTvTzy
	 uxvqoq9/7P1NPg5S5OApkn198vZ7JpNVEaT56lWJpE/Kj275vTTmx/UF2Bz0Pbpd8N
	 HyHJkN1HU1Rf4jLRgTZAGkehKtbDokDkLvpKC3aWFPrT2MmPz1huNf6nA7xW/QO8Qs
	 2UHGuc+TbMHiA==
Message-ID: <sashiko-outbox-212194@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 05/12] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-6-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> rds_conn_destroy() tears down the transport state and immediately
> frees the connection, along with its paths and its workqueues.  This
> relies on the assumption (documented in the rds_conn_destroy()
> comments) that "no one else is referencing the connection", which "we
> can only ensure ... in the rmmod path".  However, the callers stopped
> honoring that long ago.  Today, connections are also destroyed on
> network namespace teardown (rds_tcp_kill_sock() and
> rds_loop_kill_conns()), and the following patches deliberately let a
> connection outlive the call.
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D5

