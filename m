Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDBE409102;
	Tue, 13 Oct 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885113; cv=none; b=HkuZABXp8y6TWXF36bpE+x0cP9h7H7RWoXvHBTtliHd5xUkOw1dIHPk4xUxwfQ+asFXOuShMB7JavPG8H5gcLodfg92zVkiOL2+9VVoEQopXzYHRpIwfrzW8modamS77KiItOytWcPK2JqFeycRvzzF6Qy9wr4IHh24JH/T4afw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885113; c=relaxed/simple;
	bh=gZInb+Zx8Fo9HrHdz6pj8kP25/HsQx3X/dYwyr5Lgq0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=AimyPiPeTg2lsA08urlH7dUXvUWcFzwg7InqE1DGjONzCt18pFXe+8Lig4zacx4S/FLkHygl+YtnLzETY6fDUhrkTCfyWZyW4o0XdAEUKfh1x4dty7yOGsX6I+sPKxdWCd/GaZMhP2jUXtkguIFLJaiwIH5+f2vvYtjwnihXceY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUPqIDzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUPqIDzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DF41F008A2;
	Tue, 13 Oct 2026 09:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885111;
	bh=gZInb+Zx8Fo9HrHdz6pj8kP25/HsQx3X/dYwyr5Lgq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aUPqIDzIloHUu1eB1D1jensLegD27D//AbA8bfYrkz/XCcui0AVxudRKgTHuqcSLz
	 iRtcMg52BhXXhP3zZZwO+Z2nkUIowKFq4g39tnYD2bBf/jLIFhsi/bjC291d0cdlCu
	 6K1/fcheie6SzgetlFyV/N7oIi1KAcHlx9RhXcajJy1EhQbjs0zmNaeVl89Xv4OBue
	 snfAh0WXZUl2v7FIUBxxotqAaEmIOnY7eqPz2OBgWXisyp5eViPCDaO32rN1651GDy
	 +r1j00QRWbKbG/hqawrQJcrgv2H9JdEKPGCZRL0WjBDs71SyFBqtuKEZSltci46v0r
	 dfVcJv/e7D0Ng==
Message-ID: <sashiko-outbox-169393@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 3/3] net/smc: hold a link group reference for
 free work
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013091716.1210420-4-nicoyip.dev@gmail.com>
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261013091716.1210420-4-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 09:51:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> __smc_lgr_terminate() cancels free_work asynchronously. If the callback
> has already started, it can still access the group after the terminator
> drops the last reference. The callback has to dereference the group to
> find its list lock and check freeing, so that check cannot protect its
> own access to the allocation. This lifetime gap was identified during
> code review of the scheduling and early-cleanup fixes.
>=20
> Take a group reference before mod_delayed_work(). Keep it when a new
> execution is queued, including when a previous callback is still running.
> If the work was already pending, release the extra reference because that
> pending execution already owns one. Release the queued reference when
> cancellation succeeds, or at every callback exit when it executes.
>=20
> Use the reference-aware cancellation helper for connection reuse,
> termination and cancellation of a rearmed instance by the free worker.
> [ ... ]
> Link: https://lore.kernel.org/r/179113886433.434549.10069135669585050618@=
kernel.org/
> Fixes: 13085e1b5cab ("net/smc: fix deadlock triggered by cancel_delayed_w=
ork_syn()")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013091716.1210=
420-1-nicoyip.dev@gmail.com?part=3D3

