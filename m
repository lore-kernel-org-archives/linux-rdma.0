Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520FE3A254A
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050189; cv=none; b=sufDPc5rdFt47NBJVsIRJ5VkWr/iBF6kV825vNYUeCkdxCjPiVHBHTLF3eDQO14t2da1jjICSOZHH1hqggj3Wegc8a0tWLIP5+tIyvER3cvYnkAcmRo6LVmIpPYc6PM+QAnSEuTdLtM0BAN7uivL+v6XuXuhgmEdvHx/08e+IZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050189; c=relaxed/simple;
	bh=Zne1sQAFjzPDQa9O7ZDQTZgY69q0fVr5yYE7N0Khalk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IOZXt325o2xnyj1S53NoRYr4fwCsJURKjCRpMJza9+YxwDqVTTzpMVYylJ+5tTOUD2cjpj3PXbdLRikYGRY7mu6qZ4d5Vma/W/PjZeMeixD4K726RPuIEAAYdtxdPIvc3dvX/gd+H3JAr7H9XVYcEFEBHxtOQTRn6sfgxCpSU4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiHxUXiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiHxUXiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164E41F0089C;
	Sat,  3 Oct 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050188;
	bh=uHrPGRYBm5zF7HLzVUFymel1s6ttwNNDt43lD4gSIig=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kiHxUXiEqRAjbyG2t/cArsCeRl4Bu61R5Y7bZc9OpYDZcw0UFEZdOnxEHa5ELcsAu
	 hOVha/dfmbMYBw22ANIsbTtvI5ESbI/DB0Ju3/aDNGyRP+BMbbJUTA9qI1dfzV3PPd
	 Je4xU3JZVmYo1J14loSVhuvTjl0/Upaz5mX0LfplljC4rTuWCI3rYSNNdymuhTtDca
	 UH0ME4G3xYzKP5ULLY2mNjSrnQhGyg9+WPj9vL8pjgtvzhMURPtTE6aVZ+1Ehb5VZC
	 qkfNbeJPOamVLuYxRsWm8C4niNtL8Yb+XWCvynvCMRXV9jdfw2I+fYfh4BQQy+hMkq
	 XVh4B78D5ef9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 05/13] net/rds: make rds_destroy_pending()
 report a connection's own destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-6-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:27 +0000
Message-Id: <20261003175628.164E41F0089C@smtp.kernel.org>
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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D5

