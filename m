Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EA113DBBD
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208301; cv=none; b=sNrkvatIsgidIfsvpIQpfO2niA/vYMlk7Ni5ADk9spjpspjkezQebM2oBMUyhWPRUp8v+XkNNadELg7YLrOJjXdeOYMSYOu8/P+kPPky4m/9XbWiR3lgJHS6xjtXWCYxSkpbVXA0+gsUo+EVw4Km/9EkKyUk2Piqd/2cjXSWtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208301; c=relaxed/simple;
	bh=1d4Gv1FhJ10+YNxIlE/g95NJsVpSUbwhCvotRXsscLw=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=UM9sPnDy8UvCcwgb3MytUaFbbpM7FUtGiZwTAqrJ3dxU4DykwhNNxB6l3NwdqvZwocS5WoBa93eXeuwuf5nxbun+TmKRF7hv61NgUQIqr54N9jK5jLzuElHL4JNYXb48+P/xp5ICb8sk/0GXyzvCW2pvK2qVutMPjkhstaENhWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjZaWCab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjZaWCab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE461F000C4;
	Sat, 17 Oct 2026 03:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208300;
	bh=SCkGJ0Wb9BkcfOHPjKF6o9n4W17xv9najlyT9YM+3f8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IjZaWCabUY9rf6H6vaBWefy8JeuaWAUMOBGpX94LTS7kVYOT9UokdGwmL5l0/vkuJ
	 RrZLz+ssUl2LZnBy7OzXQwHJF+LgYfyiMTvUpyNvv8VODYnOx6qP8oBVn32ELTy9ZX
	 Ju5quQWwYW5m+EBP7DLx5yig6//g+Bj4D1Htg5l/1hZYOg9Iwrw5hvHZq4jJz5uB74
	 l1veFDSWk0/VcCIM51fGKV6G+ps2FJzRR6lzJ49f+ZJF2w/9akERYFPE87MfxBWSxM
	 kFJ78mAYAJHaLqiCylA/NIBx//McAV6TDg9lPEnTubR59y6+nlGncu5LbKxe9p/OkN
	 iNpS6dJ/+Bjpw==
Message-ID: <sashiko-outbox-175260@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 08/13] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-9-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:16 +0000
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
> pending - once the following patches hand out references to lookups,
> sockets and incs - would execute transport module code after that
> module's text is gone.  At this point in the series the initial
> reference is the only one, so the wait only has work to do for IB,
> where it also catches the late arrivals described below; the
> guarantee becomes load-bearing with those patches.
>=20
> Count each transport's live connections in t_conn_count (incremented
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D8

