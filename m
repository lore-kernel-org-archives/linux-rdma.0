Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13794390224
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208295; cv=none; b=hGaLQrEA7CsjPngxLdnDwzrn6+kGkcX/tKucc2rQ4554ic6B35tN0sa0l3DcMhRZVcCJ9Cqe5Vpejkneog0yvoBenpF0Xfexxbpg/8BclHGJ56r5u+bM0IfAF/fh/JQIDm6+eu9erpDNQ5HX+sU8Pd1pPBzqpLnxXh+rLcycOlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208295; c=relaxed/simple;
	bh=R8sLpW6RlkVEomqli5Y6SiC1epKkg3O4AZrREMAQSy0=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=WwoCo5+4T2QokEtTbyUwpKozEiFTJxXmVGwcS0fNwgqP3z6bj12sWAk6isdE3tV+4g04R9dDuHELTpUYDgxH0Dnn3sfisJmlSbdnxy6Af2nwfXwriaHvO2AE9zX4aeYZmVb4lmZLRSzu55G5LvRoxr1HrNywuA2fcY1UKM125cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTplMwzj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTplMwzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501401F000C5;
	Sat, 17 Oct 2026 03:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208293;
	bh=wRaix4OAaeUEj+Y9bhqw6xtJbhnI5Tg0tYH7DFvQfQk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=HTplMwzjcQ7xUUfxc4YzT6mWm+n55iuH3U/OLNXlmSyoo1kN9XYgP+VgiCkr6+9TA
	 4pWD4aW7d5QU2rxSSvgKi3x7Jmh2WwRfNXrkbntneJZVx7Nx5g0qSyyKOMtFZ2M43j
	 YQxqFkDuTjH34lwbXkpMoA/LaKc8acJKThcrHxsfSbT+5sDJAZFy2JvCSXRF/X4Lce
	 nHrGCpPfNUzCDfljMGwarwFh3OSS5H92jhrBtyDrxrEatBxHl4nxpt86mbQi4chiuL
	 If/DuijKrSq2aYJ6SwSN6OyZBuSMNOJ0jEDCRPdikhEPBx8UgWzwsATH6qBCzg4e/z
	 mR/ck/LQRJxnw==
Message-ID: <sashiko-outbox-175254@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 02/13] net/rds: undo conn_alloc() the same
 way on every __rds_conn_create() exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-3-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> trans->conn_alloc() may allocate transport data for every path of a
> multipath connection - rds_tcp_conn_alloc() does - which is why the
> lost-creation-race exit of __rds_conn_create() loops over all npaths
> when it frees the connection it just built.  The passive-connection
> exit right above it frees only path 0.
>=20
> That is not a leak today: a passive twin is only created for an IB
> loopback connection (an incoming TCP connect to a local address is
> refused with -EOPNOTSUPP before it gets here), and the IB transport is
> not multipath, so npaths is 1 on that exit.  But the two exits express
> the same "undo conn_alloc()" step in two different ways, and the
> following patches add another exit of the same kind.  Move the loop
> into a helper and use it everywhere, so that the step cannot silently
> diverge if a multipath transport ever grows a passive twin.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D2

