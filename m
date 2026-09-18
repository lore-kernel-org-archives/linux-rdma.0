Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557BB43935C
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717219; cv=none; b=JU5PNPGhVbIp0q+RSvrFIz86VKwj1s0dqiPW6dA7vDWABN/XtCTS6NcrB+zk4RksB/z1jA/PzxaoL0nUasgFDX110KQr3WCFLuMeH6LRVOKAlOqcv3+dsH2L2W3xjIrAoh8COKuOmIYZhIbrh5zUTa78eM2jheG/2JOeqnDU4PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717219; c=relaxed/simple;
	bh=G0qkJISWHNb/LsIoU7/iybRIlzn5ga9alOzrlImL6Hs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BLQGrrmC58Dw2bBMoLwHBt563Au8nLC45P0lgdV8SjI8/f7QSbIXtxeMGmCzAceWsjaODAJEhcebVXyqRwHiHP4PPA4k4pC7O1xZdBVX/bZyzuEubkfyMkZYNGg53s14hpLAt+fBp4yttUV/aFMuPmuqm8Kc9F7PK9WDWwU9TK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=daYsLb0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daYsLb0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44BA1F0089B;
	Fri, 18 Sep 2026 07:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717209;
	bh=1R6dSbfsoh7rn7RJlLz3w8GJR/65WpJ9GO9A+C/L83M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=daYsLb0aivF8NIxrxiXOMVgm8zBS/3nvGZcIqWNPsutQCLpG4aBakR4V/HyYLfbfZ
	 AcAzLuFo5PkqFU2dO44aBorMU7QDXpxSSjPuAaE0CIrgEZO1IASpZ0/u4UVIs4bfgE
	 5oCGNUYTx0J+bAoM+/CGR9PDxPgpNtMuRM4EI2kPE9tMs368Z3F3yycn9dxyg3xqRp
	 qtkNO5pp0s8vU1J//gyX8mvXH9kkNs6IihN0Lif0QBCJXx7doaTj3vFktQwSOYWQG6
	 EFHCJ8S8u6lGh5quxjLzZi/iQAciuMbrtEicrwV+TB8yg87KU4S+Nve6/t00yd/uLf
	 9f6VXVrFyz7vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 06/12] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-7-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:09 +0000
Message-Id: <20260918074009.A44BA1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending (a racing lookup-style holder, or simply the destroyer's own
> put not yet run when destroy was invoked from another context earlier)
> would execute transport module code after that module's text is gone.
>=20
> Count each transport's live connections in t_conn_count (incremented
> when a connection is published in __rds_conn_create(), decremented as
> the last step of rds_conn_destroy_fini()) and make the transport exit
> paths - rds_ib_exit(), rds_tcp_exit() and rds_loop_exit() - wait for
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D6

