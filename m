Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A7E382380
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271446; cv=none; b=qWIrMLnMSuD2lREnv+aSeRRxtKGI6MGGxLVUaaHfpZx0RM3wszB3ECdbqCFPAFXwWImUygWvrsiOnMht2d1tUuEl4RNDk9bOw8uc87KoG79z/DJERy9u//2eQerkYtpUei75kqn3shtf7tE3cL8MvqLAAbdQIpxL4d+Z6kIcR/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271446; c=relaxed/simple;
	bh=RxKgm0p3g7cT4cgVbklit5u+ntGmMuXOGvGzo1xfJm8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hDaHOxeUYNZEA8EofYXyZPypdAEE91YlSv1wLpzD1DWqAGUQvG3B5KF7F2/RvljyojEWqb8APg34HoZNbFHqZrFNHySxWMYGGGa0AHUeRyNHe1bW9YLc2/C1WjVJNr2hRPJhELvW0uJ3hGCkr0qm7Hhz/uBW6B+710G/DsHAT8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+uPUslG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+uPUslG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9048F1F000FF;
	Sun, 13 Sep 2026 03:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271444;
	bh=GdatywEsCTNxEbpIFEFbkbsdFjfoyT1OVkBgEQNqkKc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+uPUslGFnYNJwjZHnluOGmmcOOZgwQ05stC3Evj/d8WznnCV6q8Fczd6lZBv0SV+
	 81bp9E3hfsvUIrk3Th9P6HtQDgLKnjc/7hg0i40xG2OuOk/sV616qrmJanorJOMSoN
	 yePcqXDXmSP54gUJQQhjoOanD8iCmsUoaPVJ0fmI9Ar+ffo6/3fAQWWbvNQYyPpdcn
	 i0WRiuAeMrjKWnx0+5PN7Erbd/Xfffo8QOUw9TmScJNIwbGZJm/5opI1le/IBqyQ1k
	 embBFj/09KefZrbKY2UbsbdQrO4MfNbnTBM0WazO+6qprKqJQLr8mUYT8pmzHOaSOd
	 n9fBXxfowZ16A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 9/9] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-10-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:44 +0000
Message-Id: <20260913035044.9048F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by device removal,
> netns teardown or module unload - and every dereference of i_conn after
> that point touches freed memory.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> callbacks walk a receive queue after rmmod freed the connections:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D9

