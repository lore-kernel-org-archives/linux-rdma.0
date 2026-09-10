Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2323B9617;
	Thu, 10 Sep 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079129; cv=none; b=Dpy7OPjPOHoGvkHkkUKZimuOBMzZXy2A69RDI7oBAeQXNpreZ6x3PChH0Ui88mVqbFyXc1FZflVyQvUrlRZXouNkW8psDj6nDK8zdC1W5jcuGfCWSOkoW0k+weV+wU0H+M2QNw2+6eL5MeukPfaEvofw+eXssBHWiPkXsxUDKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079129; c=relaxed/simple;
	bh=EeBV/zphyG8pyqlValCIPk3DiocUGuc9ZvFwD4AU4IQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NuQ3pZRsmP35249yEUy2UvGS4SwcqolxajWZxQR23vDOKZIcWdEuk+AHX08F0WF2NdNGXo+ZjTGGeAh9rK2rfny7VtfLYfsg/v179/eD85ccnf/NBSE4IUK7qFs+HqEkIMK2NU1gAhTLlk77MQsYre7LeMWx454p7DC5wOy/qP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFM87zx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFM87zx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0051F00898;
	Thu, 10 Sep 2026 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079126;
	bh=EeBV/zphyG8pyqlValCIPk3DiocUGuc9ZvFwD4AU4IQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bFM87zx9zTUCrOeVJHORXCAkK1JRizEmW+hKa1doPOsdDTSCZzwsD+jkRqcnZQYHI
	 2kS1Q6TWmNIWFjKt3/ocqqe2LyTTe+mOuXWa299Qsj1KrzwWltBUCFh4L2dvEz+VAE
	 81or1CR/AA9yfSZCm9IYF59wX+PZGlVMs4SamuiQktGk+AieWDGyqlUAB+mXUvQ7jF
	 v/adXUto7YsoYlVkdVWvBoiqd/DHn7QcSq1RWQEfR9kqVbEgAOAOettZL7iEjfn+tE
	 1H+166p+RfRv7E7DdPOlB5JETTcxiUJZh/w8QdGFCcscjQm8tjee/jPi3SFtccuHaq
	 K07k3yfSso3/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 11/13] net: mana: keep a user-configured RSS
 table across a queue rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260909222416.884246-12-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-12-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:25 +0000
Message-Id: <20260910222525.DC0051F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Preserve a user RSS table whenever all entries fit the requested queue
> count. Regenerate driver defaults. On growth, a retained user table does
> not steer RSS traffic to the added queues until the user updates it.
>=20
> Report table loss only after successful queue-set publication. The
> non-swap allocation path still replaces invalid tables silently because
> its callers do not consistently hold the notification's netdev lock.
>=20
> Require RTNL for RSS setters to serialize them with reset/resume rebuilds.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D11

