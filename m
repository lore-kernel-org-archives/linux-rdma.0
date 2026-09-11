Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044F33DB31B
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 02:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093793; cv=none; b=Ehmp3yb3Rt5p8gCqdyO2FzLuwPBQN6QJBN3LmJ9KTA/af6hvmE/FDHOjrEMXoZSzrIYNlwV02/3mKxyBT0uhPYBRiaoSdWwYZdP/4hFjENdlYRH3IAxJUui/qYzUrVhm5iKworUptcFEloPMqSDdla9t6e6K1mitV4zFpGHgU8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093793; c=relaxed/simple;
	bh=4+2voUG4a8T1x/8HLm03FtcnNObDSt3nQ8Ap+XsVuL4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A5OPJZc+TYKguTHp0gT33umK1F12wFUxf5/LR9FwOdsp07ri+MdoZyMEHbANNmpJu61DT/iSHmR8mdHvPvoGp+payEbyP2rYaTAhC/Kb3wk/LDWBaMDPxDmgYwvXxxBcAT5HzLB/od+HwG4jPN1V2aALPTRz1GtZwpszt1XmCp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQTed3bE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQTed3bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BE91F000FF;
	Fri, 11 Sep 2026 02:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093791;
	bh=BkGLEsWJT9rJQB6yVHGlIa7pugGcT/BNDz62MQh6iBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SQTed3bECKtHIQ0rk9Xtjovzuqua25T3LFT09D7U6V/pQkiKzfvG00CwCKVfs8yHa
	 FK89Obv7ddL8klpu2IAX6hugIJm9iMI/Gj4HmH4pv6nOLdDHmLLBdXoi7inNGysM04
	 g1w619+9rTx9MUXXYc6h+uxdxlhV5ga5JWgIZQyQ9SAZR3hss9loSOgd3cH3/qqPm3
	 rOAO0eT8A5bExRPTUZxkLQm/j1d54GOAdKWBfnJptK9ByOumAdk8cV/rlzcg9olGOc
	 EA8PCBDh/oCbQMrXT23+rEJt9Pg50RP2WFAtUqs32kHQBZaA6YalyMM8Aq52ezmViJ
	 zVfxwq0VZ+Jcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/uverbs: Make CQ handle mandatory for WQ
 creation
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260911021557.2113-1-lirongqing@baidu.com>
References: <20260911021557.2113-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:29:50 +0000
Message-Id: <20260911022951.59BE91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
> method definition, so the mandatory attribute bitmap does not enforce
> its presence.  When userspace omits it, uverbs_attr_get_obj() returns
> ERR_PTR(-ENOENT) and the handler stores that error pointer into
> wq_init_attr.cq without validation.
>=20
> The bogus cq pointer is then passed to the driver's create_wq callback.
> In the mlx5 case, create_rq() calls to_mcq(init_attr->cq) which applies
> container_of to the ERR_PTR value, producing a near-NULL pointer.  The
> subsequent access in get_rq_ts_format() triggers a kernel NULL pointer
> dereference:
>=20
>   BUG: kernel NULL pointer dereference, address: 0000000000000296
>   RIP: 0010:create_rq+0x32/0x550 [mlx5_ib]
>   Call Trace:
>    mlx5_ib_create_wq+0x14a/0x210 [mlx5_ib]
>    ib_uverbs_handler_UVERBS_METHOD_WQ_CREATE+0x1f0/0x320 [ib_uverbs]
>    ib_uverbs_run_method+0x296/0x320 [ib_uverbs]
>    ib_uverbs_cmd_verbs+0x1a0/0x260 [ib_uverbs]
>    ib_uverbs_ioctl+0xa8/0x120 [ib_uverbs]
>=20
> A WQ without a CQ was never valid; the legacy write path always required
> one via uobj_get_obj_read() in ib_uverbs_ex_create_wq().  Declare the
> attribute UA_MANDATORY so the uverbs framework rejects the ioctl early
> when the CQ handle is missing, before the handler ever runs.
>=20
> Fixes: ef3bc084a8ed ("IB/uverbs: Introduce create/destroy WQ commands ove=
r ioctl")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021557.2113=
-1-lirongqing@baidu.com?part=3D1

