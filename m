Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473CC37E5FF
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271440; cv=none; b=hbApBwWo965vYvWaDK3sJejkV6SDnljXmXdJC6geFPXqQ7J7lVc2fd2GXSk8vmYKw8pHSDsImvK7sa9HYx8Ned4QSnnpWAon277IpRemZEF2+I2w05XN7UgWy7eB/qYgLBuRGBWrF91NIqfnNzYRoxEv/rCB9lwt9VzHVKIMVwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271440; c=relaxed/simple;
	bh=C+upZ2TDEHb2udcakHEcyXzAP4rbqSE/MrYUY3J1FO4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gxI7KUAdIKv5DhlqarZkDw6Qk9rMLlkF5pG7iCIirdNCZsFp/y1ljPemJeiRpTQH6o2/PTRjDDzFNPW8C7q839B5XJBKW2VA3y7yC8cgWi4edhUlOXpA+o0lYd2qt1t1bhmMFrvqrhyNhX9NJwD/xHx1HCVEbRaPN6XNgR472gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUYU7TNo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUYU7TNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DF81F000FF;
	Sun, 13 Sep 2026 03:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271439;
	bh=CTm8uNbZiPjrwMPcDWkS6i0rqijJ1jFMDSgYyVMuyTk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AUYU7TNoJSxoAjQmvCT3zn5fAEugiKXyVlZmpGKGWkwDeycHRn1d/6jECLSzmx8IX
	 8bnggUnBvWeyKgwXlN7oCsbSdFFCcRiu1dOQqeieeoIbczntTU7pM1Aod//94t5FaA
	 YbKwIGqqTyXXOf847zXUTeBCHJTb4zkqR7o1sq90hqHkzlCoGX+DUONK8y/zEw1TwL
	 xKs+0wE4w/zctWy9ysOjuQ5AJWFB700IjdeGdEtXAEo1x/IqBgfMNcaiH7S/hCh0Bs
	 neNVWFOfnmTtwnrimAbtR8zUnQCYQYlOvmOzFziWxZD3VRUPusgExrQZMwGkk3foWi
	 xCm/Pps+wr14Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 2/9] net/rds: make rds_destroy_pending()
 cover single-connection destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-3-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:38 +0000
Message-Id: <20260913035038.D8DF81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  However, nothing currently stops the
> work-requeueing sites from queueing new work on the connection while
> that happens.  The existing code would suggest that this protection
> is supposed to come from rds_destroy_pending(), since all of those
> sites guard the queueing with rds_destroy_pending() under
> rcu_read_lock() (the last stragglers were converted by the previous
> patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> itself lacks any indication that a destroy is in progress, the
> predicate does not cover the destruction of a single connection
> outside these two cases.
>=20
> [ ... ]
>=20
> Fixes: cdc306a5c9cd3 ("rds: make v3.1 as compat version")
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D2

