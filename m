Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB4C3A1E67
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050183; cv=none; b=PpVytDz/gj+4fN7GyjaFxFW75sRBfu3h1RqqKakT0Dfk4Mnvqx6ct2uSX8NdI9nQO5wj/McjX3e0r1DKbLY5XUx1URWt3o9tcixykSwduRJzX1ZeDxrW0ZYAu/5I76vV7Qxm10Gkn0qByKZQo7oXl2uE8+2dWtPDsg3tz/XIAAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050183; c=relaxed/simple;
	bh=pdTX7QbSOBdmzTbVMGWsJ3S1nI01sIyogTYFlPpYZmw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VyvjkVpYDTkxmCqIlhbaO+dmTMMmjGon3kHNPffI6YQYygKOeel8sL+onsMp68A+aCcGmlN/wySg60+4w3z4VflDTuJUouAK8pA7eqhJw8050gWu+zat/13M0Ys8/58x4mCY2uElzecZj5aFQifDZxwJiomLALuNoAL2YxJnvOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xgj9N7v4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xgj9N7v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353F61F0089E;
	Sat,  3 Oct 2026 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050182;
	bh=MAA7SQZ2DgRqWpL58L0WSALJBvnZaIYV+TCCa56mwn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xgj9N7v4QK1Hr0C19n7Mnps/TesU4gJIHGuJkFUyjl0/QE49/jsTeNb+kYUpACcps
	 GlVj6DrsGfOu5ynU3KDaXPD/L4WM7whfKdlkTWJA4IEjm4xBY7GfuRETYREMdSeyFV
	 a0BaKGoV0uRgpW6smINzA+9kuad2q1ag0zsuEGtDweZQ3Nu8UG1m1c86yS02dszj6a
	 cuK0BT8gEYYNUyBV60KDRVIVdyvv9VoUjrCexF9qUaBxznJNImVPVXdha08zDGe8pw
	 EJmQ5rg4iMnPAM9AubDROdTW5ETNRzv/Wm7qTGNsfbwN1d6P+YiHYpZKc7SG5kUFqj
	 B5B15kjxolBPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4 1/2] net: rds: fix uninitialized trans
 dereference in CM event handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163408.250568-2-achender@kernel.org>
References: <20261003163408.250568-1-achender@kernel.org>
 <20261003163408.250568-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:21 +0000
Message-Id: <20261003175622.353F61F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Aohan Mei <henrymei@tencent.com>
>=20
> rds_rdma_cm_event_handler_cmn() assigns trans only when the RDMA
> device is an InfiniBand CA (RDMA_NODE_IB_CA).  On any other device
> type, e.g. an iWARP RNIC such as siw, trans stays uninitialized, but
> the event switch dereferences it: unconditionally in the
> RDMA_CM_EVENT_CONNECT_REQUEST case via trans->cm_handle_connect(),
> and (with a connection context) in the ROUTE_RESOLVED and
> ESTABLISHED cases.
>=20
> An RDS listener on an iWARP device therefore crashes the kernel as
> soon as a connect request arrives: with CONFIG_INIT_STACK_ALL_ZERO
> the wild load becomes a NULL dereference at offset 0xa0
> (&trans->cm_handle_connect) in the iw_cm_wq workqueue.
>=20
> [ ... ]
>  not destroy connection ids RDS still tracks; drop a connection whose
>  address resolved to a non-IB device before a route is resolved on it;
>  changelog adjusted]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163408.2505=
68-1-achender@kernel.org?part=3D1

