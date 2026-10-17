Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7236D3C1D7F
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208296; cv=none; b=NBRJB5Zj9CKLqeR1OL7bWilR8mMwBStA89PQ9tZxB/dcbRgoV/n7mrM+hJieQgaOXa6YxMiEO3SEV3KSw3f5mKGvExoq6uk9SOpqmEl1opmyJVDUBVg/NSraEyGMXfjJc6Maz3R3mAWHJAMlfGIs49zLq5o/tp45taug6jMa2/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208296; c=relaxed/simple;
	bh=DB09+IBPqVjdiMPttdp9AJl9JXZBCJc92PVyh1naZHk=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=PQpt22AIweJqvE/mXirqE8TGHc0YF5AxYJfINGQced4xBxwgKh3bjk5/BRY48dLlddakHWVltFqYmG0oRi+u7PbliDFUFLz/HF9+mM25wTFAHTRo2ObA8PMyzWNx+aqML0xwHy5nB1f4PIwhd35AhQ++oBqL8AncyYKK1B/qL30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpX1DKx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpX1DKx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5D01F000C5;
	Sat, 17 Oct 2026 03:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208295;
	bh=+4b03VEzkUeB+sW07Z8xWjUoK06maCNP8/QQDAunero=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IpX1DKx4Iw+qqDGTgK5aqnmUDTiqLxIYSBBtxzLsPE4p62U9pEVivW2q0nJMCIcp9
	 8u42dYFPEz3kWzyEy2+VrlIN6J34YXHuqW7C//+KcwzWN22X1CryS6lfQno+TfhQ3G
	 UTt2AD8Zge+W3c2r9qCUW+bvDNPFPw6V0/pIbwFgto+8+63VHhk/cvMlNjRcczvght
	 AjeeOXoXlmF4Msjl3pCDJGuxpQ2Q2hOBcoA7G9A+PWFuCZ95QtmhZYo+P/XOCnT7t6
	 c2f5k69XTt7Eq9uOCrKi14ttDxM9hGXOj5MApP5I2mBpnT6cEHTp40PKuay8PaaJ1V
	 3VwTpYk946R2w==
Message-ID: <sashiko-outbox-175257@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 05/13] net/rds: make rds_destroy_pending()
 report a connection's own destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-6-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:14 +0000
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
> sites - apart from the workers' own self-requeues, which the sync
> cancel in the destroy path already rejects, and the destroy =3D=3D true
> rds_conn_path_drop(), which the destroy itself issues and flushes and
> IB device removal issues ahead of the module exit that destroys the
> connection - guard the queueing with
> rds_destroy_pending() under rcu_read_lock() (the last stragglers were
> converted by the previous patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> [ ... ]
> missing pieces of the requeue guard, which stand on their own.
>=20
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D5

