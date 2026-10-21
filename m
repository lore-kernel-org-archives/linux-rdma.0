Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792613002;
	b=kqm26iAWggmi/eTWM7bq9Y6ww1rl24JAxob0NIjhCNPTwib0PGFF6fT1n52GagOQCWVc
	 QUXAuhqcNU6WDSWxIU8N5gEMzQw/x3AdsBzoMix9Dtt1i7cOUlpgdU4pUcOz9Nja7iTR+
	 JygWhx/jQ76gL3UxQUK6u2RTVdPtZOv2IpjGs+UeL0MS0epd9XqsbqaH1wQYe6FdU38jy
	 x+JfIsqIcNhULKmcNa1duRmKRWWq1SU9vaziQFUcalOGE+U3yq5HqArWeMHDEYIvlFBPs
	 GJ0OZpCsXIbrHVVGIF5jh6xFtpJkg3Slpdro6ACj2ZjSb60su/pzmtRTKdVnET4DJ3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613002;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5zUMpCoqfKa6msbUC9aAPoNiiG+uaJDo5hhzqIA6Mkg=;
	b=zRVidh7t2vmoKG3TsVqNKlw6qD0MbCQYswKlEaV4nNbFRLuuN1ShUYG4X9k7E6D65OOK
	 Aq9F29XR9V3gHPIC5jBA7RseduArczBgg3zgzpfjX29TXh5/Y4P20Na/Qyksa0I+6789q
	 PTuyhqjQBpZ3JlmKuTSVIE8N42btrT4ky4OIhh+BkdOHQPGmbpRtP9EHUkxiU0QRRcGu5
	 X17zA+G0zaQbLQB2SCRe4MjLE4m2onw9Y3WkSTOP7eiWoU8hoiaLN8/rNhA3ijhEWhHzN
	 Z+/cJMyFpK5+G5OAJ2vXzza5Orr7dJANSFEQqgA6rtVj9aGJ+DvJN823XAFaSmNG3EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxrPF1zD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A63606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 20:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxrPF1zD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C43E1F000C2;
	Wed, 21 Oct 2026 20:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792613002;
	bh=5zUMpCoqfKa6msbUC9aAPoNiiG+uaJDo5hhzqIA6Mkg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IxrPF1zDE8fcmxiUbas15w7Xz+MmzRnJivbknqi/pMHutNAiPCfE2KtLegcvS6cRh
	 qdcW5ma+SO9qGXNb4J2gnqHPHHhB/bVa9nq0bm+uORJzYNRIgdEe6tRRGGWxqBrMwi
	 zDBYp7ms5kFHlKEX063pWZ3HUaeC3KTPdXXZe//gts22shFr0EY8GVRR4eHI6xq3Z9
	 y0YKujPvVUZHld30RPzB6PUVaGZnu+6OfnYr5ks+eSDURg/dCpM0dsW6Fo+4x8/ahT
	 QgFDd3B8fFWDwSzTg8xBUyLefZZGElN2MMLsTZGurDwzE5j82RQsc0KiTM6FFbdYj1
	 v3h1qi5bmRf/A==
Message-ID: <sashiko-outbox-180620@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/2] net/rds: do not initialize transports after
 rds_init() failed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261021195837.142802-3-achender@kernel.org>
References: <20261021195837.142802-1-achender@kernel.org>
 <20261021195837.142802-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 20:03:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds, rds_rdma and rds_tcp each have their own module_init().  When they
> are built in, those run in link order, so rds_init() goes first, but
> do_initcalls() does not stop when it fails.  The transports then
> initialize against a core that has already been torn down: rds_wq has
> been destroyed, yet rds_ib_dev_put(), rds_ib_unregister_client() and
> rds_tcp_accept_work() still queue onto or flush it, and
> rds_trans_register() hands the transports to a core whose socket
> family may never have been registered.
>=20
> This was seen with CONFIG_SYSCTL=3Dn, where rds_sysctl_init() failed and
> rds_ib_init()'s error path then flushed the freed rds_wq [1], but any
> rds_init() failure after rds_threads_init() has the same effect.
>=20
> Record whether rds_init() succeeded and have rds_rdma_init() and
> rds_tcp_init() bail out with -ENODEV otherwise.  Modular builds are
> unaffected: the transports need symbols exported by rds.ko, so they
> cannot be loaded unless rds_init() succeeded.
>=20
> [1] https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
> Fixes: 55b7ed0b582f ("RDS: Common RDMA transport code")
> Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Assisted-by: LLM
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021195837.1428=
02-1-achender@kernel.org?part=3D2

