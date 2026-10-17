Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF13C9891
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208297; cv=none; b=VVMF+oyqCEK3RRUVYE6Tg1LQEjFoyZU+E1bp5y+IhLT6x4AMvzmpmRkLFIKRzRpkQwc/jogD4c2ViKRN/3H7rBSJ/Lk0zwtJEnTd4q9NqXrRL5d+kE0aOSyybNNACG6wCAE5AUbZfWvgv7evEd7afP6YF9f3rskLoJENdxjw5bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208297; c=relaxed/simple;
	bh=eHkTWT4SEtFoWoMH4v75poP2WKsPE035uU2VpgzEFJs=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=uLj9FL00K1AWIm22RyUqbTM1ZyUGi2+iBWX1TfHlr54JFuiVRZbS5tTKKF0Um+2r++22s6iqw9LYW8Y3PeMmM+sxIdSnAUDuibxN2lLs4LQ6+AEzYqM193/VOgUFyFgPLEG7PG9d8IWs0hiwru6Ci0cXVOg2NOXN4TkKOrhE7hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfXVOkCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfXVOkCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DD01F000C4;
	Sat, 17 Oct 2026 03:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208296;
	bh=LxGg4vWTUc20LJWMNkyJXTbCzzmvQxmPBmcgsf3V3wU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=gfXVOkCPbueTDg9eh7f0CpT0a/iW8ksocZhr2IfmEIMkIOcnAgAEqibi2URUsT7mr
	 3XIpCkACR7H8TCxZw0/mKIVfaHFEggc2H4f40i7gE7Nr+/nlrzgKrGi//RIY6GfeVR
	 z5JA7tv1qXMmn/U1R2fb13TXUV3UJWQogwRODfnG6yu/PrClE6D+97M7ZPBv+RaITg
	 H8tSUdcGzc9JbkPWjnmRnuceuuffcQ/DM/1f/i54EqdDox0ntO0+/dFP+Rbtzt7qUy
	 lUXUHFz/J9XfkTTLh2t1MEcgnaGgqeXThFLwdDjSS0y++yHad6IVXf6WisF6mkjpvN
	 F8rpWjBTPXwGA==
Message-ID: <sashiko-outbox-175258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 06/13] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-7-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:15 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D6

