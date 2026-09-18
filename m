Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244983A874F
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717223; cv=none; b=EAg7pgK+UciZ8RJcjH0QZ1Bp2gJosJ6J+IxEWEIG6SMcZhKqj+WHfu5F7aM2q5tDA1T+bNhv4Lr8F4nUWwSX9qZUt2ODNozx21lXW3EshvNUg3Dtz4fbdQq+p5UNJkakfuLiYvg5HuWoO0KGWYsp2jGZczLZ6ofAYve95BTgJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717223; c=relaxed/simple;
	bh=R8LC8YEaitmVRi5k8dV7JVjInF2OLWS3ik12/lo6ucY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cEwkMx8OCV4blEoqaxU+VPDrGUwcjoITOkxsHKUHOjTP6ZSPhczFaj3n+TEJ1ShDX7W3sNxfnRu44hbglSBJyHhWw06YzzV01IhvDDeYTBquORn4qdHtqHm4GisDQQgOZBA2uIYJK+atP1I/7Pr6JAPNDiSWnfpl3AJl4/jzhaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSbFyToL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSbFyToL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513131F0089C;
	Fri, 18 Sep 2026 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717210;
	bh=kGBzgYfFWBxFPPm7cTyBmGLiTJrYVSU+h5irx2Q5zrA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XSbFyToLP8XVSB1LRjiRGibmAKxs8Mfj2auTEYZvR0rKZJxPkyIbSUpqBWzvUHqls
	 MnJJ/ny2/s86UR9icys12uJpGpQtHgJ5vEasTslEn1ozqVI3WlP192Ijx6eczh0/8V
	 nkg978YSYR2FEHsefuxH5DQgHkzH9LP+tsIEOr3Wo5T+gzqE5cYOPGS9dk+6F/afY6
	 kURq1XklVBPVkZCimzpIXsA1/YEDymGRZTOX0i7uIk2K+ePydsepRPUrA7CXKcumMT
	 D1wlhJ3eGw68KTlaV30NmedK3DGab3bt3roVHozvVuFK5x5d5ax+evNrJXZpmJCLYR
	 vQYiCFz6uvXZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 04/12] net/rds: make rds_destroy_pending()
 cover single-connection destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-5-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:09 +0000
Message-Id: <20260918074010.513131F0089C@smtp.kernel.org>
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
> cancel in the destroy path already rejects - guard the queueing with
> rds_destroy_pending() under rcu_read_lock() (the last stragglers were
> converted by the previous patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> itself lacks any indication that a destroy is in progress, the
> predicate does not cover the destruction of a single connection
> outside these two cases.
> [ ... ]
>=20
> Fixes: cdc306a5c9cd3 ("rds: make v3.1 as compat version")
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D4

