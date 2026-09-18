Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB0E3A785D
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717227; cv=none; b=MkdMERtkpGi1m6Lq4tv+rb5bUygf06HQejH4GtUSOTr35iCypfs0ZYFOGVhmPhbVKPTj/uwO0P5r99gb3Vw2Hzf91hJuLXRsrnR8f0hGNJqK4UwLlpVe+gijD5upiCGulUcLeBn0cyZr7RlhLsZNVnGcTksZeLVmhAz5oy/pjNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717227; c=relaxed/simple;
	bh=wd1PxH/6ZzH71MZlY5XwpMccFjPSZjNxyO5Eltc+KzM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JNsZeRS4AdNs0vFwfalfczgFL0LvGW9A8KnD5JpShr7waPeTmSUvizEvFNxtoZFRgjLOes5F4s6OBLJDkUf9uvMHdNA+kz7wouXbSoVSujAinIloFH4N/CgqdnWgWao3u/y3S1UtJwELgbeQ4oQ97+IkdlP3pCuzEiI2niFRzSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHSeo8yX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHSeo8yX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AA31F0089A;
	Fri, 18 Sep 2026 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717209;
	bh=G7zUHpV7bL0NKSnUhfKlAl6Yb/hd3CYVZEo8Mzr54hI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aHSeo8yXHsVa/psBnYE53Ph1DquOJjqE9eET6kClAoD8RTCbt7IqSrJhUHFDTM+lI
	 tPg7wLcNUAGIMzy5qolg1HbIPD1BdFKWpP94cQuRfElyq0uCP3nJVtr/Zq1vtJHhj0
	 5BvbYjWTiI5uSdsYgIzAfZey9OjYO8Zmx38yb/T+se9g3b97MQMVNer6ePhYpjKPnT
	 JRRZjM6ncxX2Yr0RM3mF6uVP8dpFrfJ21EIEzsxb/pD5K7d8aXNvfRVmNMHFblNq1n
	 mIWxixdOyw7kSFbjGYHh8D5IJh8lWiDNlesUObmhRK71F7qA7XPCTkf7d2t8vZAvLG
	 a6E6309lPIdAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 05/12] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-6-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:08 +0000
Message-Id: <20260918074009.02AA31F0089A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D5

