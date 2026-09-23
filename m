Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EB8346ADC
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153668; cv=none; b=laLM7KKCoryluEUZpeFC4lBHbbvaUnbQ/aJwWnQII6+lzyQ644CnZvyHg5YElsvKwGTVfy+nzPCZXTV5lpouY7w/XgXWOy5aFEu+8VP12HqUWyHjJyUawe16p7TuXedzXfeQGWxT4ylKy1J140yX3KgJev2+BaO78CdInzM0J90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153668; c=relaxed/simple;
	bh=PGgFURUyZO/ohJMnPgyO3xY5apld+Y80AQTIq7719G4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gZr6j9eK9aQFwtSEGmS8UAs8K1BgSQ0u3ohC4c5nXqwGxrooUV9VBk5lNCQNKplTGKaKwtXR34WZTrZVf+A+CRiPCG6PbF7MC+u0lL1UQR0O0pla038R0wgoW/FzJ6O86OA6AGXYAseZQtf53FpNz8skxh66Hvmu5G9tgwuSrGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQE5nrqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQE5nrqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A331F008BD;
	Wed, 23 Sep 2026 08:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153663;
	bh=ndg4rc84cx2ticSsfn7u2LjDMljf5c26NP4gnSXSKJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CQE5nrqkGqwQzItOI7LvGbOVPOJbnZbLXqFTDUJnNRJs2BLMTOHvatja5jDYYc7MP
	 U4vyW5aZ+0+5RCcathZYtWKoCV90AxQ2qvbWaoW7bxBNsPTVwP2+u9TPTBDFYXrkMA
	 EZFivKqD/HXxpxW3khiLCV2FV9fWmxFHEqbccuS0K3oii30rDcMPjTXDhil05fKsrq
	 U/+biOe36cLl9+5WaSzA0qsVoTWErk9rKOTg5Jgj13lSz3bsXQSEI9tHhF87bHR8pI
	 YgQIJxnMAcjKa45pwsExLMg6i49CR4ODBg/XtlYSp56AEsUG82DkDF04pFWUA5YZ5p
	 LMWSM6EmZg4LQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 07/12] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-8-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:23 +0000
Message-Id: <20260923085423.C7A331F008BD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> list_del() the node from a stack frame that no longer exists.  Make
> [ ... ]
> what keeps rds_conn_destroy() from being called with the transport
> lock held.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D7

