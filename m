Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B123BCD0A
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208304; cv=none; b=iIQAR3ZNPRIlonIEs5Xn3gbKvDy03HfMktiQ4tqORWylICja7Tk8UQ+SplHiAw9GYkNndMAZlZzA0gbN+VH2Opo9eMEvrmnHTOfcth/JF1aY7juc/DYRayStSnn/+HCVReBgutOirbd21Lu195zqFW6v4bXYZZhvCt7FlYTtdx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208304; c=relaxed/simple;
	bh=FyiXcrgkFcDUJEGCMWy9jizyQcsZhP3jaN+tLdYkOjI=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=Doru3xc2tiiJJRxBbEhiwIujAC8mcACZjOJv/RhUxasegBaEmleJwG3aBddODJXyICwqmcJqSiFbJvFi8ldjTD14Eceu4YNJ+KCZSDRWd3dkj5T1oEwWuCYXoW7NDD+P08uiU+Tp8ySVAqt0h/c5gbNbwizqtTIrbMCfjQ2xWNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfA2ZQgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfA2ZQgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6291F000C5;
	Sat, 17 Oct 2026 03:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208303;
	bh=7iDsKcVOEnWZ9NqSs+Ve64fdKYCiHaTraZRNswlm1Yc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lfA2ZQgszYVoDTW/rHncX+AjdvI1+gZxKcirbVqzhVnufmvHmnJQGJU8kdO+xRJhU
	 bnuTSCTEGI+GcA4MUKf/vRRLij0Gd4x5rdQZqOpLgotDOhGlW9tSG9ajBzLK1Wg14L
	 XFTORL3KXCPPl8PO/1J+UIyRkLAodOwuwBpQoxjiiIOaEASQEdPNzT10uQvD0/Rb62
	 lsCPvMP1JEyhpNzrwfXPh5EYyQGOtVvn/ceYfwcF71eFOAmn7Uge7TFQjLjqyp8ZDu
	 j361wF1uER3yIhsLVpCMYD9twKMMCS9k2VuqhdYaWHyHU4hnqp2qKLlunf77UQaHmY
	 r05gpVbbbfDIQ==
Message-ID: <sashiko-outbox-175265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 13/13] net/rds: drop rds_conn_count in
 favor of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-14-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-14-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:22 +0000
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D13

