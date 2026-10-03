Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A96B3A83B1
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050193; cv=none; b=A1fEclnRAnKJpaJUvRstQerS/5CspZ6zrn1HFBX9CP1BH26GJY4yrO20PF/MHDVSj4UiQRlhwy9Z5phB1+bSgsQKmL/HyYL5WodKhJhlQCOhTGSMBAgh7d/n4bBscwpykocLIbvRvanckaEHfs8+Yox/CcO/yZfBSyXDrg+RaL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050193; c=relaxed/simple;
	bh=wfT9REAr/iymQ1N+u/l4IhJwAYjP4TprupDuHCfLIwc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F++ETdQprqPZr3bGQh+yLiZaxgCyNlNANH3VfQiWubMUr2kleMnaW2UOLSBlZzuEXmE/DopeezMVEtTxH9g68O67ORbq6jrf2e5eLOJru8HjeUJvstOoAxYdWISOra65D+uHnI4IyVd12VHqIpZltUIbU6au8KfqEBO+vd5YfBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jru06AMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jru06AMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AB91F0089B;
	Sat,  3 Oct 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050192;
	bh=Eu2fOmWIDhVJ/6BwUDFRnvG2p8S4nm02B5yYqV7FXJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jru06AMFhfQGZhIcqYthRFk+OdPXR2zDdcOLEVlkBb8/eaGxYRAiZX5Uokkr1GA85
	 cSSFoJbQvZXzGrgfbHTgjJ269s5l+Ld+jxMzcnNVCYRdaMFU/URAGhUKfQyFE01GdX
	 tTsDnIeayN3R8GqY5scfV0VMnwGjqNecLsnO9WQx0gflLs0OP5J4YBIgkmkO/Z+GfM
	 J4Mqkc3ctaaO0xA91krcP9r7I9dy28BwcOEmu+pQmaf08j1MjTydKhKMITeeub1hD2
	 50/v1eovBIE/0EuxjvIStpjxON0+21gjiX1Go41SkFMWlN9hYM0SYdz7FXiifOJCcm
	 XAzwqN/gOKH9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 13/13] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-14-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-14-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:31 +0000
Message-Id: <20261003175632.13AB91F0089B@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D13

