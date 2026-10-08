Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1104437C0E5
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430343; cv=none; b=nUEE0sOXOS69m8ycm7dgEZU9P7c8vt3ANDvKU2P6icTVVi4A4wgzJnSYRACDEUZGQ3yWIJD1cHsxNclmuqWetO51ZSRld+p+g1lVUv80k4I4XfG9iNdaxCyhMk9/5KAw0pv465WdRC7pYLG8InjdjV9664/T81GDIEF23K8BzIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430343; c=relaxed/simple;
	bh=uMRVLX+htOapPjqPkf4JOS8hJ5bvsDAEMsq1ySY58ik=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=uPdmJGAvaPrG1i9hqGau67FKn7exAoki/y5M39T1TfsZhIgAJDXBO8OysI4qVGUDzJw2ANziNk8JijG5E65RAZbNcQhVl6vkhESD87JVGZmKtGl8HtFBjb326IyypXWe0v2K7fVVIYBdq1VI+VA0I48p1yXW2Zm06CF5+n+7sxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoPS+cJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoPS+cJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD37B1F00898;
	Thu,  8 Oct 2026 03:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430342;
	bh=hop84a8oSKPKOaeEGZFd2wSIHpf4OPmEAZwxxABsyFY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BoPS+cJCPyl/YHyd0bIpn49cVBe9MRsxMxrCpPj9atzYfkoW7/rliCPKTDfT/rYUe
	 eOh1/WJ1kJUz+IVDerXrErJnH357UYOE6ANkJp7hacR7MOgjPA5vKF77HoK1nNWQ02
	 R6preHb9NfaFoYoqRGkuK9Wih+uUnWk7oQTtmeglUpqo9xhNCDT1Cjo1gAPfTKGqBR
	 hQEXCJ06/x1yqEtiH5sZGpKvgOIpS4cUsLGQsRTdhZRZnKY697QU/BtzYLksrPmfZA
	 IeiE/SlnckWfJtmbMyYrQC9QJdPZMDZT6brk/KbX5Uc3ECVp+MblQFgYNoLOBXPp5T
	 tAnKzAcUXS5fA==
Message-ID: <sashiko-outbox-163554@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 13/13] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-14-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-14-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The patch "net/rds: wait for connections to be freed on transport
> unload", earlier in this series, gave each transport its own
> connection count in t_conn_count, incremented and decremented at
> exactly the points where the global rds_conn_count is.  That leaves
> rds_conn_count with a single remaining consumer: the seed of the
> per-path workqueue names in __rds_conn_create().
>=20
> Switch the name seed to t_conn_count, as UEK does, and remove
> rds_conn_count.  The numbering becomes per-transport instead of
> global, so connections of different transports can now receive the
> same seed; workqueue names carry no uniqueness requirement, and the
> seed was already reused as the count rose and fell.  Removing the
> counter also removes the rds_conn_lock round-trip that
> rds_conn_destroy_fini() took solely to decrement it.  (The free path
> still sleeps in destroy_workqueue(), so the last reference has to be
> dropped from process context as before; only that one lock goes.)
>=20
> Based on the Oracle UEK commit "net/rds: Each RDS transport
> should keep its own connection count".
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D13

