Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6305463B74;
	Sat,  3 Oct 2026 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791053099; cv=none; b=CuYMunX8VO7hydftbtP/lPq5DgLWi/uKohA8h2viyYzExExjgsKJa6MqZMcZ45AMpx2IFR1EebMmwsHd+pjmIyhWR+05R34VUGFCGnt5SITcYz5RkPxzocQczc9HtQNYmZ8kjGjF1tg89XRpWzquMkiK+/Wh1cSw/e2mup1EGyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791053099; c=relaxed/simple;
	bh=vzClbZ1yhPpYOQD3APbB2vG2z25Gq0V+pcYX5tb17dg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PQTQFxubUFKxHzik2yFGIXJFjTXy9j4U9jTy1X9zfWPsK5IKB41ijmF68Cf10D8ePq1KRT52lwhJkbFGSZpDEZyw+EBMIFU7yLF6HyuMyptYI87BGtLUM65zpusEiLNynoGxSAiNqhL5J79920DQ0ptlCuU1161hx/W+sy8nX1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBY8CBev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBY8CBev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4FE1F0089B;
	Sat,  3 Oct 2026 18:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791053096;
	bh=a3A+J0hGoQPLo6LpOmORy/dVgc0mUfEcA5hdDBTogGE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eBY8CBevPswwdbIVAp5YMQyXTJo++vIgKZyw+WLcLkubndXpu67WswnYsCwuJgts9
	 uvyJ4i8e8oGm/wzbGusCEDRni352ACPrA1zZlRJRpSfGCuVL0aNyQJdx5s6763grfN
	 B3QV0whRUvf04Ntl14XRjqyIaSBN1MsNZ2rjl1Uv206UjO1cj61xEHED1ud14DslJE
	 rGi0oHAuq8YyxQaVZSPRYUMnaNzH5sSNC9mrijdXALYjwliry4tGahhep1HtLqZS3S
	 z6ZhGeMzgAw9w0XqQhtD3QTKdvc9/BQwnTdT9zwjaaFOQUADIpLVqRCjfQAbtnC4kp
	 gUGZ67ooFSI3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/2] net/smc: serialize link group free work
 scheduling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261003183237.2284245-2-nicoyip.dev@gmail.com>
References: <20261003183237.2284245-1-nicoyip.dev@gmail.com>
 <20261003183237.2284245-2-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 18:44:54 +0000
Message-Id: <20261003184455.1C4FE1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_lgr_schedule_free_work() checks lgr->freeing without the link group
> list lock held by the teardown paths. A concurrent smc_lgr_free_work()
> can set freeing and cancel the delayed work between that check and
> mod_delayed_work(), leaving a timer pending on a freed link group:
>=20
>   CPU 0 (smc_conn_free)            CPU 1 (smc_lgr_free_work)
>   observe lgr->freeing =3D=3D 0
>                                   set lgr->freeing under lgr_lock
>                                   cancel_delayed_work()
>                                   smc_lgr_free(): drop lgr reference
>   mod_delayed_work()
>   smc_lgr_put(): drop last reference and free lgr
>=20
> When the timer expires, the timer core accesses the freed memory.
>=20
> [ ... ]
>=20
> Fixes: 8e316b9e7260 ("net/smc: improve link group freeing")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003183237.2284=
245-1-nicoyip.dev@gmail.com?part=3D1

