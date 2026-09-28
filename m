Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6D2296BB5
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576129; cv=none; b=lBhREDcwVTHNYqMeiu9HaodJlGO3rGJcuamyfCcGub5v5BZfp4S5n0J+NCiuh2sj4Fvwfs3jdfArFqUz3eLdSs3TIF1s9zxQAl5Mg9hSXbBg/hLhExSLkBkbS9zOneSUWPby9W6EsMvfCRRg1LMFY7a5uPCKH65nvHwiBYOFoWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576129; c=relaxed/simple;
	bh=UGtKA3TnPIs0XRo1x+2mc1V4xV/T+zHS1VSjRXjra4I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GSx+1H307hauehhLKjZoMS1p1l2N6grLzQP9WDN3paoDT8P8BhZtg3D7YLJ5ggCZ0pAIl+37XGJjsaV7mlKzigw8zbTQooNX1a7MoLdxG02GCVG76xgvNhsOOE/5Mx3MeVmTQUBSrzXXBrFNAKUVedjLNsLCZgymZEN6vXYV+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRVO7ADe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRVO7ADe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867E51F008A2;
	Mon, 28 Sep 2026 06:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576107;
	bh=bXeXLs7Ek4Tlsd8J8bS5UCBYMn6+Khjvi9KMHRSZnpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eRVO7ADe3Ndq8DWpsJbKkT5NkyWrO3P1F/p/cKY162ZKYGgyiiHSWl6tdOuYmJ/LX
	 o9hiXI8DBBdtzcD9KkLFodNpp+fr/xdVfXM6b1mZzig2Fh/6hWDZaYRvnDVAdCF2sx
	 dhjsijHALBX9BYFrhmjK/emNpn6p2c8A5pKMDAMOYhEnLmHPTe/o5ApyQRjvnc+u9L
	 Ho8geoH1LmUgr3OMyeBH2a0TVH+n7Wbkxv6Q6iuyZGNygaZOL5kP3gaFltmRypjuxQ
	 DFzCz8scpP/UG84+GWbCHe7F66q5RKLPKYVYcvh+tVqWglmVvBoIqYOauX34zGwjpG
	 N3SX9ywEhiL+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 12/12] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-13-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:07 +0000
Message-Id: <20260928061507.867E51F008A2@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D12

