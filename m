Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C523D9556
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884732; cv=none; b=MJJ7Ylci2zbvcKcz3kV8+lgCEdMbMYkR923GAmQTzyTA9fWNvzanAAQZSLk1hgPYYr3DGVHnG1brX5I6o5V6tcb2SBV4gzPuUEyMnkjvCTa77lctjuuW0MxrAgpHKCZDmbk1ws7QYgG6pYKVLsw7I3AIIqxiTsARQdZUBLcnqwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884732; c=relaxed/simple;
	bh=1xmozZuiBYL6Mc/FMel/QErWQdzVKOF02wpscJw1k5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fTOXAjdV/6gA5DwjG/PycuwBNuI+nEm1anSAH0k7Hc/uSMh0GrF/+2oBL6Vve7uq11x5+YTEi6JjOwgaW5Cev1GeE1NPV4piZdnd4tBjdNhcqmEkfvfUsP9Fr0yDfIceBvQqDetAOYMyf+4wO8LfuXjE3ORWO5CoQm2jQ29IzXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkgFtUiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkgFtUiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03B71F000FF;
	Sun, 20 Sep 2026 06:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884730;
	bh=aBumpCxNFXz0sPMelESfinSwfEAEBezUsF/tK2H0Xiw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AkgFtUiRWR/crPztg7/6iEN9J3M4thsQn1dMBkVEnw6YgtI+u9icbE7FeYxdX0SK5
	 LFdAma9BoDv0aIcf/KfwaX+PUASN6lPP9WSDviaowcGtZIeEfjbaRWH4VgDkgGDHgQ
	 M1XiTtaJeaXBq3gbAliDWXPM151O1MNXu0Fiot13WFixLVAt6PigTsw/fjoDn8Hy56
	 g1RtqxU29qL71w2v6BfCh8KjK7Ftv8FcqHgB3zsSXCJkmG+PXE8qK7HWiWSN8DH7Sw
	 lXDq1oGsLMbFrL9881mfXxdbd9oLHp+To3lu0tgbicEaIzJg5fl8xN9UvyAA82XfK5
	 DjMQChCCdKCxg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 11/12] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-12-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:10 +0000
Message-Id: <20260920061210.D03B71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The previous patch gave each transport its own connection count in
> t_conn_count, incremented and decremented at exactly the points where
> the global rds_conn_count is.  That leaves rds_conn_count with a
> single remaining consumer: the seed of the per-path workqueue names
> in __rds_conn_create().
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D11

